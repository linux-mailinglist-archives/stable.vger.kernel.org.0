Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B452C226A7F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgGTQfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731594AbgGTPys (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D8622CAF;
        Mon, 20 Jul 2020 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260488;
        bh=M1pbtdsVuX5Qz95+Pj07YkmyhRfrOrhCWBaKOiEoEiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8/3rLc4xNXMHnl0v55IvtPt8q3bt4QWLQQHDpxDQ7Ri4FRcu1N3lxIrsnhEQ4aZo
         9Y9O53KnD0kbCwnK5j3Lo6W/utjguKatX9lAzjpaL4gTm3nXI3ZBphoZu/ejSYdooN
         k0NCH7NX6hywgxPNblem+srAfhQwGAPeizQedulk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>
Subject: [PATCH 4.19 120/133] intel_th: Fix a NULL dereference when hub driver is not loaded
Date:   Mon, 20 Jul 2020 17:37:47 +0200
Message-Id: <20200720152809.531402386@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit e78e1fdb282726beaf88aa75943682217e6ded0e upstream.

Connecting master to an output port when GTH driver module is not loaded
triggers a NULL dereference:

> RIP: 0010:intel_th_set_output+0x35/0x70 [intel_th]
> Call Trace:
>  ? sth_stm_link+0x12/0x20 [intel_th_sth]
>  stm_source_link_store+0x164/0x270 [stm_core]
>  dev_attr_store+0x17/0x30
>  sysfs_kf_write+0x3e/0x50
>  kernfs_fop_write+0xda/0x1b0
>  __vfs_write+0x1b/0x40
>  vfs_write+0xb9/0x1a0
>  ksys_write+0x67/0xe0
>  __x64_sys_write+0x1a/0x20
>  do_syscall_64+0x57/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Make sure the module in question is loaded and return an error if not.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 39f4034693b7c ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Cc: stable@vger.kernel.org # v4.4
Link: https://lore.kernel.org/r/20200706161339.55468-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/intel_th/core.c |   21 ++++++++++++++++++---
 drivers/hwtracing/intel_th/sth.c  |    4 +---
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -944,15 +944,30 @@ int intel_th_set_output(struct intel_th_
 {
 	struct intel_th_device *hub = to_intel_th_hub(thdev);
 	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+	int ret;
 
 	/* In host mode, this is up to the external debugger, do nothing. */
 	if (hub->host_mode)
 		return 0;
 
-	if (!hubdrv->set_output)
-		return -ENOTSUPP;
+	/*
+	 * hub is instantiated together with the source device that
+	 * calls here, so guaranteed to be present.
+	 */
+	hubdrv = to_intel_th_driver(hub->dev.driver);
+	if (!hubdrv || !try_module_get(hubdrv->driver.owner))
+		return -EINVAL;
 
-	return hubdrv->set_output(hub, master);
+	if (!hubdrv->set_output) {
+		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	ret = hubdrv->set_output(hub, master);
+
+out:
+	module_put(hubdrv->driver.owner);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(intel_th_set_output);
 
--- a/drivers/hwtracing/intel_th/sth.c
+++ b/drivers/hwtracing/intel_th/sth.c
@@ -157,9 +157,7 @@ static int sth_stm_link(struct stm_data
 {
 	struct sth_device *sth = container_of(stm_data, struct sth_device, stm);
 
-	intel_th_set_output(to_intel_th_device(sth->dev), master);
-
-	return 0;
+	return intel_th_set_output(to_intel_th_device(sth->dev), master);
 }
 
 static int intel_th_sw_init(struct sth_device *sth)


