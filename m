Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45F07982B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388770AbfG2UFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389766AbfG2ToS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:44:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6A4E205F4;
        Mon, 29 Jul 2019 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429457;
        bh=ZPmfZoJlLwTcRkZU0BsWm4+fuP0Yq8LQoHWCzuFYCAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmAsbEE1NfwvcBSn2zR5owKMgkf/FIbZsGl1LpKIQfqMDSfL/4qxk7YjVj9+NW871
         5MDywK8Tozj2XgJokzyYsfufyrmTtMFQ+/OKOhgbt6xEQSkL/J5Fs73/EnXsvzTFD9
         glE7PgwdUfwj5veBnQdX0d0xyJIg15CHv2FXHS7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8b3c354d33c4ac78bfad@syzkaller.appspotmail.com,
        Hridya Valsaraju <hridya@google.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 4.19 103/113] binder: prevent transactions to context manager from its own process.
Date:   Mon, 29 Jul 2019 21:23:10 +0200
Message-Id: <20190729190720.129090388@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hridya Valsaraju <hridya@google.com>

commit 49ed96943a8e0c62cc5a9b0a6cfc88be87d1fcec upstream.

Currently, a transaction to context manager from its own process
is prevented by checking if its binder_proc struct is the same as
that of the sender. However, this would not catch cases where the
process opens the binder device again and uses the new fd to send
a transaction to the context manager.

Reported-by: syzbot+8b3c354d33c4ac78bfad@syzkaller.appspotmail.com
Signed-off-by: Hridya Valsaraju <hridya@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190715191804.112933-1-hridya@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2838,7 +2838,7 @@ static void binder_transaction(struct bi
 			else
 				return_error = BR_DEAD_REPLY;
 			mutex_unlock(&context->context_mgr_node_lock);
-			if (target_node && target_proc == proc) {
+			if (target_node && target_proc->pid == proc->pid) {
 				binder_user_error("%d:%d got transaction to context manager from process owning it\n",
 						  proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;


