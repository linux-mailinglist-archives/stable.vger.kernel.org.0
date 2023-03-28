Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE93E6CBF6A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjC1Mlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjC1Mlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52792AD06
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0925F61757
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195DBC433EF;
        Tue, 28 Mar 2023 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680007265;
        bh=hxm/IdFnmc1JKO1sHjqRkC0AJ4PlpmBRqODqpMO6Ahs=;
        h=Subject:To:Cc:From:Date:From;
        b=Rg1U7rlr0++kB7zjszu0FjTv/O8uiHdjLBq8vHDp8t/BdsQtg2uoQ9rbSyZmHYp37
         qpyM6sgBgfWpHObPmjlWzH5vVz1eCMO73YPVMZioyydlC+s1jMMzPa7v0D15atnCMc
         gDP8osFX69bvFmbZVOEWuxAIytdE92VVnTmdd4Pg=
Subject: FAILED: patch "[PATCH] dm crypt: avoid accessing uninitialized tasklet" failed to apply to 5.10-stable tree
To:     snitzer@kernel.org, houtao1@huawei.com, ignat@cloudflare.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:41:02 +0200
Message-ID: <168000726237133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x d9a02e016aaf5a57fb44e9a5e6da8ccd3b9e2e70
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000726237133@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

d9a02e016aaf ("dm crypt: avoid accessing uninitialized tasklet")
d3703ef33129 ("dm crypt: use in_hardirq() instead of deprecated in_irq()")
c87a95dc28b1 ("dm crypt: defer decryption to a tasklet if interrupts disabled")
8e14f610159d ("dm crypt: do not call bio_endio() from the dm-crypt tasklet")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d9a02e016aaf5a57fb44e9a5e6da8ccd3b9e2e70 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@kernel.org>
Date: Wed, 8 Mar 2023 14:39:54 -0500
Subject: [PATCH] dm crypt: avoid accessing uninitialized tasklet

When neither "no_read_workqueue" nor "no_write_workqueue" are enabled,
tasklet_trylock() in crypt_dec_pending() may still return false due to
an uninitialized state, and dm-crypt will unnecessarily do io completion
in io_queue workqueue instead of current context.

Fix this by adding an 'in_tasklet' flag to dm_crypt_io struct and
initialize it to false in crypt_io_init(). Set this flag to true in
kcryptd_queue_crypt() before calling tasklet_schedule(). If set
crypt_dec_pending() will punt io completion to a workqueue.

This also nicely avoids the tasklet_trylock/unlock hack when tasklets
aren't in use.

Fixes: 8e14f610159d ("dm crypt: do not call bio_endio() from the dm-crypt tasklet")
Cc: stable@vger.kernel.org
Reported-by: Hou Tao <houtao1@huawei.com>
Suggested-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index faba1be572f9..2764b4ea18a3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -72,7 +72,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1731,6 +1733,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1777,14 +1780,13 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	 * our tasklet. In this case we need to delay bio_endio()
 	 * execution to after the tasklet is done and dequeued.
 	 */
-	if (tasklet_trylock(&io->tasklet)) {
-		tasklet_unlock(&io->tasklet);
-		bio_endio(base_bio);
+	if (io->in_tasklet) {
+		INIT_WORK(&io->work, kcryptd_io_bio_endio);
+		queue_work(cc->io_queue, &io->work);
 		return;
 	}
 
-	INIT_WORK(&io->work, kcryptd_io_bio_endio);
-	queue_work(cc->io_queue, &io->work);
+	bio_endio(base_bio);
 }
 
 /*
@@ -2233,6 +2235,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;

