Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4257924F
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387736AbfG2RnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:43:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46977 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387716AbfG2RnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:43:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 06289222B2;
        Mon, 29 Jul 2019 13:43:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=J2iLV2
        7s1a3PMhTYkNRzmNKcWJtobME+/NFDxZQiWfQ=; b=QxwaiI2YspcIiVRmiZ1l7E
        CHYI34krTM0Bg7TehuaOnfC1xzfQy2XiWDWBSF1GiUkaGdaiCnTEG8mfxQOL7NxV
        CYTIejoeM510AYE/gzIrCMYrk+/HcNLeYUjHqrdCPtd4yLxX9KXcQQz5SfQTcNkL
        k9S+9Zhu+RoxPvDP+gvI7EYYYZUlo2ufc6j5W+CJxOEB3nUh3+UlWFs+Il8aIdDG
        NpugKS+WpWUGDtHp9uFaxbkS3poIVgVfSEmz93r8OzXLuGHOzuhRhPoTUAwNy03w
        loMWmjiGem+aTwNKQmatCk4Ze1Q6A9XoKhTsalTbImezcNS4KpF9a/sfCYD1dcCQ
        ==
X-ME-Sender: <xms:KjA_XcTEO0eiR839gUsLLy9utsOY1M1_w-FjuZoVV93mIPv3DxU8OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecukf
    hppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghg
    sehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:KjA_XZ9klCye_7nhTHDJH6nnrfDaVtnajOAvuk36OvTpCrdHI7yEiA>
    <xmx:KjA_XTUbyR68k3jH1qH3K4voI19US-igsuP3CdVSewvIOQnCs_qicg>
    <xmx:KjA_XfHoxQorwsVQtd53d_antKWpsajmBAcI1rL_xNWeZeWeW96y1g>
    <xmx:KzA_XYYUGMPE9AoK4w-mZCbw7okBD6AMJ6H1NgS_oRR-1z3l8oyb-Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76AFB380075;
        Mon, 29 Jul 2019 13:43:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libnvdimm/bus: Prevent duplicate device_unregister() calls" failed to apply to 4.4-stable tree
To:     dan.j.williams@intel.com, erwin.tsaur@oracle.com,
        jane.chu@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 19:43:01 +0200
Message-ID: <156442218180214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

