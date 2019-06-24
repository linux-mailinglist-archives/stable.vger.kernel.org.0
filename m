Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AC8508AA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfFXKVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbfFXKVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:21:45 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2742089F;
        Mon, 24 Jun 2019 10:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371704;
        bh=V5HZXV/YhrsliP3YAP4QFG+MQTQNMfCzWWxrY8RiI4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PT0ZyFdIazvV7mCF+WibJ68xJNZHPEv1vf6yxs2F81qXClkvcg2PQtGxkTO+jwfx7
         MYYq16rtWZARHnrG4bxO1Rh3YXUL8EC0ZM2D4Xb7tzSzQ/IGnVrjE5rULjwT1txb+b
         9Jmm7WWYMDpOFlADAphRl18Nxh2Q2j1ETzXSB+Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.1 108/121] binder: fix possible UAF when freeing buffer
Date:   Mon, 24 Jun 2019 17:57:20 +0800
Message-Id: <20190624092326.204850152@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit a370003cc301d4361bae20c9ef615f89bf8d1e8a upstream.

There is a race between the binder driver cleaning
up a completed transaction via binder_free_transaction()
and a user calling binder_ioctl(BC_FREE_BUFFER) to
release a buffer. It doesn't matter which is first but
they need to be protected against running concurrently
which can result in a UAF.

Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1950,8 +1950,18 @@ static void binder_free_txn_fixups(struc
 
 static void binder_free_transaction(struct binder_transaction *t)
 {
-	if (t->buffer)
-		t->buffer->transaction = NULL;
+	struct binder_proc *target_proc = t->to_proc;
+
+	if (target_proc) {
+		binder_inner_proc_lock(target_proc);
+		if (t->buffer)
+			t->buffer->transaction = NULL;
+		binder_inner_proc_unlock(target_proc);
+	}
+	/*
+	 * If the transaction has no target_proc, then
+	 * t->buffer->transaction has already been cleared.
+	 */
 	binder_free_txn_fixups(t);
 	kfree(t);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION);
@@ -3550,10 +3560,12 @@ err_invalid_target_handle:
 static void
 binder_free_buf(struct binder_proc *proc, struct binder_buffer *buffer)
 {
+	binder_inner_proc_lock(proc);
 	if (buffer->transaction) {
 		buffer->transaction->buffer = NULL;
 		buffer->transaction = NULL;
 	}
+	binder_inner_proc_unlock(proc);
 	if (buffer->async_transaction && buffer->target_node) {
 		struct binder_node *buf_node;
 		struct binder_work *w;


