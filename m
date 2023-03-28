Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B956CC393
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbjC1OzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjC1OzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B13D510
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123FD61840
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFAAC433D2;
        Tue, 28 Mar 2023 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015317;
        bh=k1N7dHmalUzQgKvoTbPJ0heyvLSaRgpyQcstFsWvkUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cj7s4KjZU2bliGhRN3dKl5IMoK+jbbGi/Q86ztt9CWGhJM5TjS20hp36RZzzjHIFp
         zs/DVeBobnyWsugi9QlxG7MRiCoFLIf56TLodZuhuMvAK5ixZJGTdUK7Qct9czfxPk
         m8RfKoszIiT+/mYKnH59LhefCLUMPbnkfhpJS5J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 238/240] dm crypt: avoid accessing uninitialized tasklet
Date:   Tue, 28 Mar 2023 16:43:21 +0200
Message-Id: <20230328142629.607611853@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

commit d9a02e016aaf5a57fb44e9a5e6da8ccd3b9e2e70 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -71,7 +71,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1728,6 +1730,7 @@ static void crypt_io_init(struct dm_cryp
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1773,14 +1776,13 @@ static void crypt_dec_pending(struct dm_
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
@@ -2229,6 +2231,7 @@ static void kcryptd_queue_crypt(struct d
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;


