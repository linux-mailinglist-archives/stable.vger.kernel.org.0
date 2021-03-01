Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974173284BB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhCAQm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234284AbhCAQej (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:34:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD35464F29;
        Mon,  1 Mar 2021 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615935;
        bh=P76GmgKonaS5OMVkvujMCxWqvPLCJ5l/7BbjJKQRm4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2+l7E2SNVjSXjxvwYX6HWtQcNbv8Mut1l8kZHvgAvAiamJLGGcmobXAo2OBWnG/k
         dCbJgk77HOgOoYWfrrBbFLuuNAH5B4vjbgJde9auKPPiwOH0F1HVsRmWBHpJ0JAxJc
         6tdnKU/F0AatR8Q/dU+z+FeYYsVcWDa3dzFMTHjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Coly Li <colyli@suse.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 113/134] libnvdimm/dimm: Avoid race between probe and available_slots_show()
Date:   Mon,  1 Mar 2021 17:13:34 +0100
Message-Id: <20210301161019.141033407@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 7018c897c2f243d4b5f1b94bc6b4831a7eab80fb upstream

Richard reports that the following test:

(while true; do
     cat /sys/bus/nd/devices/nmem*/available_slots 2>&1 > /dev/null
 done) &

while true; do
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/bind
     done
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/unbind
     done
 done

...fails with a crash signature like:

    divide error: 0000 [#1] SMP KASAN PTI
    RIP: 0010:nd_label_nfree+0x134/0x1a0 [libnvdimm]
    [..]
    Call Trace:
     available_slots_show+0x4e/0x120 [libnvdimm]
     dev_attr_show+0x42/0x80
     ? memset+0x20/0x40
     sysfs_kf_seq_show+0x218/0x410

The root cause is that available_slots_show() consults driver-data, but
fails to synchronize against device-unbind setting up a TOCTOU race to
access uninitialized memory.

Validate driver-data under the device-lock.

Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Coly Li <colyli@suse.com>
Reported-by: Richard Palethorpe <rpalethorpe@suse.com>
Acked-by: Richard Palethorpe <rpalethorpe@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[sudip: use device_lock()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/dimm_devs.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -317,16 +317,16 @@ static ssize_t state_show(struct device
 }
 static DEVICE_ATTR_RO(state);
 
-static ssize_t available_slots_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 {
-	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
+	struct device *dev;
 	ssize_t rc;
 	u32 nfree;
 
 	if (!ndd)
 		return -ENXIO;
 
+	dev = ndd->dev;
 	nvdimm_bus_lock(dev);
 	nfree = nd_label_nfree(ndd);
 	if (nfree - 1 > nfree) {
@@ -338,6 +338,18 @@ static ssize_t available_slots_show(stru
 	nvdimm_bus_unlock(dev);
 	return rc;
 }
+
+static ssize_t available_slots_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	ssize_t rc;
+
+	device_lock(dev);
+	rc = __available_slots_show(dev_get_drvdata(dev), buf);
+	device_unlock(dev);
+
+	return rc;
+}
 static DEVICE_ATTR_RO(available_slots);
 
 static struct attribute *nvdimm_attributes[] = {


