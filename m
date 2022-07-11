Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4B56FC33
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiGKJku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiGKJkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAE58C17C;
        Mon, 11 Jul 2022 02:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13E61CE125D;
        Mon, 11 Jul 2022 09:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C733DC341C0;
        Mon, 11 Jul 2022 09:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531228;
        bh=qHgKYxqgAm81b0hOmcGoke/IsgPA+fooL4yEG/AmAo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwRbaVD8bw9bdAAP3YqGIcuE4GtYrwFS0eHdaOkq8kGxVNqdAOCVTsYXOgJU360FP
         02FbxXa4hYHOVZo18ZSb7KVd27lvJWBBg5xoylkrK4EJaPl8nmQA6XABw6X+K9IXdz
         yWoxirsQQEOldWYqaQW6Tc2/UmKR7j2xTTqHYa5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/230] dma-buf/poll: Get a file reference for outstanding fence callbacks
Date:   Mon, 11 Jul 2022 11:04:45 +0200
Message-Id: <20220711090604.904789107@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit ff2d23843f7fb4f13055be5a4a9a20ddd04e6e9c ]

This makes sure we don't hit the

	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);

in dma_buf_release, which could be triggered by user space closing the
dma-buf file description while there are outstanding fence callbacks
from dma_buf_poll.

Cc: stable@vger.kernel.org
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210723075857.4065-1-michel@daenzer.net
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f9217e300eea..968c3df2810e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -67,12 +67,9 @@ static void dma_buf_release(struct dentry *dentry)
 	BUG_ON(dmabuf->vmapping_counter);
 
 	/*
-	 * Any fences that a dma-buf poll can wait on should be signaled
-	 * before releasing dma-buf. This is the responsibility of each
-	 * driver that uses the reservation objects.
-	 *
-	 * If you hit this BUG() it means someone dropped their ref to the
-	 * dma-buf while still having pending operation to the buffer.
+	 * If you hit this BUG() it could mean:
+	 * * There's a file reference imbalance in dma_buf_poll / dma_buf_poll_cb or somewhere else
+	 * * dmabuf->cb_in/out.active are non-0 despite no pending fence callback
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
@@ -200,6 +197,7 @@ static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
 static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 {
 	struct dma_buf_poll_cb_t *dcb = (struct dma_buf_poll_cb_t *)cb;
+	struct dma_buf *dmabuf = container_of(dcb->poll, struct dma_buf, poll);
 	unsigned long flags;
 
 	spin_lock_irqsave(&dcb->poll->lock, flags);
@@ -207,6 +205,8 @@ static void dma_buf_poll_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 	dcb->active = 0;
 	spin_unlock_irqrestore(&dcb->poll->lock, flags);
 	dma_fence_put(fence);
+	/* Paired with get_file in dma_buf_poll */
+	fput(dmabuf->file);
 }
 
 static bool dma_buf_poll_shared(struct dma_resv *resv,
@@ -282,8 +282,12 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLOUT) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_shared(resv, dcb) &&
 			    !dma_buf_poll_excl(resv, dcb))
+
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
 			else
@@ -303,6 +307,9 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
 		spin_unlock_irq(&dmabuf->poll.lock);
 
 		if (events & EPOLLIN) {
+			/* Paired with fput in dma_buf_poll_cb */
+			get_file(dmabuf->file);
+
 			if (!dma_buf_poll_excl(resv, dcb))
 				/* No callback queued, wake up any other waiters */
 				dma_buf_poll_cb(NULL, &dcb->cb);
-- 
2.35.1



