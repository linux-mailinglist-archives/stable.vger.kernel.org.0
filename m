Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE28D7F357
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406446AbfHBJ4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406713AbfHBJ4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:56:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805432064A;
        Fri,  2 Aug 2019 09:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739776;
        bh=TZyC/e3XWGinl9VbLp32LC4zDGiye8OtkVuPC0YrCuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2gQdk93RCDDpAzTQO/DBEAmBgusyW/DXt5snZZymcg2PbHWU9+YnNA3KvHXGJN8b
         8VB+uta3i+ZAz7Kq5WP+bXcPzkHU8TTY++tv0gcAlm6+ysCBn8EqXF7gklJ1roFi6x
         x7GF/yaCXX6rKfGDGvFwcuBb+WGIxcwmZQtpt0cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 4.19 09/32] binder: fix possible UAF when freeing buffer
Date:   Fri,  2 Aug 2019 11:39:43 +0200
Message-Id: <20190802092104.545353007@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
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
@@ -1960,8 +1960,18 @@ static struct binder_thread *binder_get_
 
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
 	kfree(t);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION);
 }
@@ -3484,10 +3494,12 @@ static int binder_thread_write(struct bi
 				     buffer->debug_id,
 				     buffer->transaction ? "active" : "finished");
 
+			binder_inner_proc_lock(proc);
 			if (buffer->transaction) {
 				buffer->transaction->buffer = NULL;
 				buffer->transaction = NULL;
 			}
+			binder_inner_proc_unlock(proc);
 			if (buffer->async_transaction && buffer->target_node) {
 				struct binder_node *buf_node;
 				struct binder_work *w;


