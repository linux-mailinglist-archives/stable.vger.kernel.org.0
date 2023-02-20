Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B834E69CA07
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjBTLkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjBTLkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:40:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166011B555
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FCFC60DF2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A83C433D2;
        Mon, 20 Feb 2023 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676893228;
        bh=s5nJdUNNKtUgr7Nk6DMmPwGr5IRZNWFX4Ll4jQV2vgA=;
        h=Subject:To:Cc:From:Date:From;
        b=q/fcCMsNE7l1RcMzRLGzXm+nfnwwRjkgxVlLEgaV01/yXaQ3eYLnfFNccCFoqPQKj
         nwtTf5KM87kqdeRumwOau87gjEcMjnkfQQTXDawIpbdHYCfSFEVstEEGvEyQFopA/H
         IUvqmGAWcjKcLaU/Mz2vTdSertXBK/YCBFQngyDw=
Subject: FAILED: patch "[PATCH] nvme-apple: reset controller during shutdown" failed to apply to 6.1-stable tree
To:     j@jannau.net, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Feb 2023 12:40:25 +0100
Message-ID: <1676893225104207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c06ba7b892a5 ("nvme-apple: reset controller during shutdown")
285b6e9b5717 ("nvme: merge nvme_shutdown_ctrl into nvme_disable_ctrl")
e6d275de2e4a ("nvme: use nvme_wait_ready in nvme_shutdown_ctrl")
c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")
9f27bd701d18 ("nvme: rename the queue quiescing helpers")
91c11d5f3254 ("nvme-rdma: stop auth work after tearing down queues in error recovery")
1f1a4f89562d ("nvme-tcp: stop auth work after tearing down queues in error recovery")
eac3ef262941 ("nvme-pci: split the initial probe from the rest path")
a6ee7f19ebfd ("nvme-pci: call nvme_pci_configure_admin_queue from nvme_pci_enable")
3f30a79c2e2c ("nvme-pci: set constant paramters in nvme_pci_alloc_ctrl")
2e87570be9d2 ("nvme-pci: factor out a nvme_pci_alloc_dev helper")
081a7d958ce4 ("nvme-pci: factor the iod mempool creation into a helper")
94cc781f69f4 ("nvme: move OPAL setup from PCIe to core")
cd50f9b24726 ("nvme: split nvme_kill_queues")
6bcd5089ee13 ("nvme: don't unquiesce the admin queue in nvme_kill_queues")
0ffc7e98bfaa ("nvme-pci: refactor the tagset handling in nvme_reset_work")
71b26083d59c ("block: set the disk capacity to 0 in blk_mark_disk_dead")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c06ba7b892a50b48522ad441a40053f483dfee9e Mon Sep 17 00:00:00 2001
From: Janne Grunau <j@jannau.net>
Date: Tue, 17 Jan 2023 19:25:00 +0100
Subject: [PATCH] nvme-apple: reset controller during shutdown

This is a functional revert of c76b8308e4c9 ("nvme-apple: fix controller
shutdown in apple_nvme_disable").

The commit broke suspend/resume since apple_nvme_reset_work() tries to
disable the controller on resume. This does not work for the apple NVMe
controller since register access only works while the co-processor
firmware is running.

Disabling the NVMe controller in the shutdown path is also required
for shutting the co-processor down. The original code was appropriate
for this hardware. Add a comment to prevent a similar breaking changes
in the future.

Fixes: c76b8308e4c9 ("nvme-apple: fix controller shutdown in apple_nvme_disable")
Reported-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/all/20230110174745.GA3576@jannau.net/
Signed-off-by: Janne Grunau <j@jannau.net>
[hch: updated with a more descriptive comment from Hector Martin]
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index bf1c60edb7f9..146c9e63ce77 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -829,7 +829,23 @@ static void apple_nvme_disable(struct apple_nvme *anv, bool shutdown)
 			apple_nvme_remove_cq(anv);
 		}
 
-		nvme_disable_ctrl(&anv->ctrl, shutdown);
+		/*
+		 * Always disable the NVMe controller after shutdown.
+		 * We need to do this to bring it back up later anyway, and we
+		 * can't do it while the firmware is not running (e.g. in the
+		 * resume reset path before RTKit is initialized), so for Apple
+		 * controllers it makes sense to unconditionally do it here.
+		 * Additionally, this sequence of events is reliable, while
+		 * others (like disabling after bringing back the firmware on
+		 * resume) seem to run into trouble under some circumstances.
+		 *
+		 * Both U-Boot and m1n1 also use this convention (i.e. an ANS
+		 * NVMe controller is handed off with firmware shut down, in an
+		 * NVMe disabled state, after a clean shutdown).
+		 */
+		if (shutdown)
+			nvme_disable_ctrl(&anv->ctrl, shutdown);
+		nvme_disable_ctrl(&anv->ctrl, false);
 	}
 
 	WRITE_ONCE(anv->ioq.enabled, false);

