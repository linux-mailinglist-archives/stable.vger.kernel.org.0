Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8C67924D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfG2RnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:43:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40079 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbfG2RnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:43:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EC8D62227E;
        Mon, 29 Jul 2019 13:43:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u0DBpC
        ucsNXTuQb+bC87DYnVnrOvL3Pjf+NC2QZAN9E=; b=1mkBqxSUdtZICyjgVnt/Wn
        xEVoyvSGesfw0QIouYR/q+EM0O9+5/7yLYg8dKWaoqms8P/vnOpg7PZzm4WHSN3R
        x1ODH2TUHX5diVvbD3j7RAyJPK2a/8BJ9WGikrc/T+lY/ojidH5SzksYX+mxfjQ/
        hBI/BtDGXFl0aldHLO4ZGF6K3rZaoOQDLS4aI0R4liFEuuyIfdBgKk5Kqw931F6Z
        s5W1D4ju751G0McCSz10UST8/w7t5ntvfGSLi8yhPehnvmEVqgrAZ6dTtoG6fyjF
        dLZpskczCmdTznOXWMjnpcKjL0p+zSGq4/7Yv2aukW+BZj5dpbdtZ7s3WLwU1nNA
        ==
X-ME-Sender: <xms:JzA_XXYKqbuVZmBCtneBbeHGzrcjxhrkLegVWfGE8aS2q2-fvxLTTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecukf
    hppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghg
    sehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:JzA_XcBGRgzkO-KDr8TFRuBw2M4nOPWUdHWHyKFOi4vPSQM_MkMLuw>
    <xmx:JzA_Xe4LLBedRQzuQHft8JSMwXCsfHZ6HSTrCTssKSQUhQFE3C0XHw>
    <xmx:JzA_XeBD-J4XyY0dZcSzAeQVRp33wJ3dV1ALgyyXCwXWPT34BnPCCQ>
    <xmx:JzA_XcV43xOTqbRd1WG41iMEkemmpVL2owrmognOIXt5HWCaanbENA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F3B780062;
        Mon, 29 Jul 2019 13:43:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm/bus: Prevent duplicate device_unregister() calls" failed to apply to 4.14-stable tree
To:     dan.j.williams@intel.com, erwin.tsaur@oracle.com,
        jane.chu@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 19:42:59 +0200
Message-ID: <156442217919690@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8aac0e2338916e273ccbd438a2b7a1e8c61749f5 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:07:58 -0700
Subject: [PATCH] libnvdimm/bus: Prevent duplicate device_unregister() calls

A multithreaded namespace creation/destruction stress test currently
fails with signatures like the following:

    sysfs group 'power' not found for kobject 'dax1.1'
    RIP: 0010:sysfs_remove_group+0x76/0x80
    Call Trace:
     device_del+0x73/0x370
     device_unregister+0x16/0x50
     nd_async_device_unregister+0x1e/0x30 [libnvdimm]
     async_run_entry_fn+0x39/0x160
     process_one_work+0x23c/0x5e0
     worker_thread+0x3c/0x390

    BUG: kernel NULL pointer dereference, address: 0000000000000020
    RIP: 0010:klist_put+0x1b/0x6c
    Call Trace:
     klist_del+0xe/0x10
     device_del+0x8a/0x2c9
     ? __switch_to_asm+0x34/0x70
     ? __switch_to_asm+0x40/0x70
     device_unregister+0x44/0x4f
     nd_async_device_unregister+0x22/0x2d [libnvdimm]
     async_run_entry_fn+0x47/0x15a
     process_one_work+0x1a2/0x2eb
     worker_thread+0x1b8/0x26e

Use the kill_device() helper to atomically resolve the race of multiple
threads issuing kill, device_unregister(), requests.

Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver...")
Cc: <stable@vger.kernel.org>
Link: https://github.com/pmem/ndctl/issues/96
Tested-by: Tested-by: Jane Chu <jane.chu@oracle.com>
Link: https://lore.kernel.org/r/156341207846.292348.10435719262819764054.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2dca3034fee0..42713b210f51 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -547,13 +547,38 @@ EXPORT_SYMBOL(nd_device_register);
 
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
+	bool killed;
+
 	switch (mode) {
 	case ND_ASYNC:
+		/*
+		 * In the async case this is being triggered with the
+		 * device lock held and the unregistration work needs to
+		 * be moved out of line iff this is thread has won the
+		 * race to schedule the deletion.
+		 */
+		if (!kill_device(dev))
+			return;
+
 		get_device(dev);
 		async_schedule_domain(nd_async_device_unregister, dev,
 				&nd_async_domain);
 		break;
 	case ND_SYNC:
+		/*
+		 * In the sync case the device is being unregistered due
+		 * to a state change of the parent. Claim the kill state
+		 * to synchronize against other unregistration requests,
+		 * or otherwise let the async path handle it if the
+		 * unregistration was already queued.
+		 */
+		device_lock(dev);
+		killed = kill_device(dev);
+		device_unlock(dev);
+
+		if (!killed)
+			return;
+
 		nd_synchronize();
 		device_unregister(dev);
 		break;

