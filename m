Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD781631BB
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgBRUCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbgBRUCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E33E2465D;
        Tue, 18 Feb 2020 20:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056143;
        bh=Q2XUqAWzcsKw+sVNaQcUgDBogFgpDWgMzjvKDC7PDp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biQ+Ac7e8XoVctmuDQhNvN3lkO9UIEcJ157mMIsN6OU10K/lBMyUb1wtEvlQeclcL
         OPWXBLY28OZVGvdVfTISX26hKqCj/q6IrkxsirPWmQ92luDaxmNAlVa6MJWkKajq/6
         vl9bb1OvoalDlR+ZWKxnyod+nIRotJPMkZ1piWXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Robert Richter <rrichter@marvell.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.5 34/80] EDAC/mc: Fix use-after-free and memleaks during device removal
Date:   Tue, 18 Feb 2020 20:54:55 +0100
Message-Id: <20200218190435.722187790@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Richter <rrichter@marvell.com>

commit 216aa145aaf379a50b17afc812db71d893bd6683 upstream.

A test kernel with the options DEBUG_TEST_DRIVER_REMOVE, KASAN and
DEBUG_KMEMLEAK set, revealed several issues when removing an mci device:

1) Use-after-free:

On 27.11.19 17:07:33, John Garry wrote:
> [   22.104498] BUG: KASAN: use-after-free in
> edac_remove_sysfs_mci_device+0x148/0x180

The use-after-free is caused by the mci_for_each_dimm() macro called in
edac_remove_sysfs_mci_device(). The iterator was introduced with

  c498afaf7df8 ("EDAC: Introduce an mci_for_each_dimm() iterator").

The iterator loop calls device_unregister(&dimm->dev), which removes
the sysfs entry of the device, but also frees the dimm struct in
dimm_attr_release(). When incrementing the loop in mci_for_each_dimm(),
the dimm struct is accessed again, after having been freed already.

The fix is to free all the mci device's subsequent dimm and csrow
objects at a later point, in _edac_mc_free(), when the mci device itself
is being freed.

This keeps the data structures intact and the mci device can be
fully used until its removal. The change allows the safe usage of
mci_for_each_dimm() to release dimm devices from sysfs.

2) Memory leaks:

Following memory leaks have been detected:

 # grep edac /sys/kernel/debug/kmemleak | sort | uniq -c
       1     [<000000003c0f58f9>] edac_mc_alloc+0x3bc/0x9d0      # mci->csrows
      16     [<00000000bb932dc0>] edac_mc_alloc+0x49c/0x9d0      # csr->channels
      16     [<00000000e2734dba>] edac_mc_alloc+0x518/0x9d0      # csr->channels[chn]
       1     [<00000000eb040168>] edac_mc_alloc+0x5c8/0x9d0      # mci->dimms
      34     [<00000000ef737c29>] ghes_edac_register+0x1c8/0x3f8 # see edac_mc_alloc()

All leaks are from memory allocated by edac_mc_alloc().

Note: The test above shows that edac_mc_alloc() was called here from
ghes_edac_register(), thus both functions show up in the stack trace
but the module causing the leaks is edac_mc. The comments with the data
structures involved were made manually by analyzing the objdump.

The data structures listed above and created by edac_mc_alloc() are
not properly removed during device removal, which is done in
edac_mc_free().

There are two paths implemented to remove the device depending on device
registration, _edac_mc_free() is called if the device is not registered
and edac_unregister_sysfs() otherwise.

The implemenations differ. For the sysfs case, the mci device removal
lacks the removal of subsequent data structures (csrows, channels,
dimms). This causes the memory leaks (see mci_attr_release()).

 [ bp: Massage commit message. ]

Fixes: c498afaf7df8 ("EDAC: Introduce an mci_for_each_dimm() iterator")
Fixes: faa2ad09c01c ("edac_mc: edac_mc_free() cannot assume mem_ctl_info is registered in sysfs.")
Fixes: 7a623c039075 ("edac: rewrite the sysfs code to use struct device")
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Robert Richter <rrichter@marvell.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: John Garry <john.garry@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200212120340.4764-3-rrichter@marvell.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc.c       |   12 +++---------
 drivers/edac/edac_mc_sysfs.c |   15 +++------------
 2 files changed, 6 insertions(+), 21 deletions(-)

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -505,16 +505,10 @@ void edac_mc_free(struct mem_ctl_info *m
 {
 	edac_dbg(1, "\n");
 
-	/* If we're not yet registered with sysfs free only what was allocated
-	 * in edac_mc_alloc().
-	 */
-	if (!device_is_registered(&mci->dev)) {
-		_edac_mc_free(mci);
-		return;
-	}
+	if (device_is_registered(&mci->dev))
+		edac_unregister_sysfs(mci);
 
-	/* the mci instance is freed here, when the sysfs object is dropped */
-	edac_unregister_sysfs(mci);
+	_edac_mc_free(mci);
 }
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -276,10 +276,7 @@ static const struct attribute_group *csr
 
 static void csrow_attr_release(struct device *dev)
 {
-	struct csrow_info *csrow = container_of(dev, struct csrow_info, dev);
-
-	edac_dbg(1, "device %s released\n", dev_name(dev));
-	kfree(csrow);
+	/* release device with _edac_mc_free() */
 }
 
 static const struct device_type csrow_attr_type = {
@@ -607,10 +604,7 @@ static const struct attribute_group *dim
 
 static void dimm_attr_release(struct device *dev)
 {
-	struct dimm_info *dimm = container_of(dev, struct dimm_info, dev);
-
-	edac_dbg(1, "device %s released\n", dev_name(dev));
-	kfree(dimm);
+	/* release device with _edac_mc_free() */
 }
 
 static const struct device_type dimm_attr_type = {
@@ -892,10 +886,7 @@ static const struct attribute_group *mci
 
 static void mci_attr_release(struct device *dev)
 {
-	struct mem_ctl_info *mci = container_of(dev, struct mem_ctl_info, dev);
-
-	edac_dbg(1, "device %s released\n", dev_name(dev));
-	kfree(mci);
+	/* release device with _edac_mc_free() */
 }
 
 static const struct device_type mci_attr_type = {


