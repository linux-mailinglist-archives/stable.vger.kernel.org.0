Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED1F79709
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403756AbfG2T5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404043AbfG2Ty2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD85521773;
        Mon, 29 Jul 2019 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430068;
        bh=4sXdNXPScPUynDeTvlfOIZNtQFPHYIYr4JtrETjXkEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ7XvDzTyJ4D2ksXp7pjDBTVQnn2xPT4ApLirjqL/yKCatO185BmPrIt7xr1CObs6
         7Z+W7PWt+11MVC9FydiqWSFgpC3gkygFbBLEi2kfqo+g/q6qRGZcQf/Mr7zmk0fJUE
         62ijR+jEZcjRCWzaA+sYVa3xcD35c06KNRG2LHi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8b3c354d33c4ac78bfad@syzkaller.appspotmail.com,
        Hridya Valsaraju <hridya@google.com>,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.2 185/215] binder: prevent transactions to context manager from its own process.
Date:   Mon, 29 Jul 2019 21:23:01 +0200
Message-Id: <20190729190812.268949872@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
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
@@ -2988,7 +2988,7 @@ static void binder_transaction(struct bi
 			else
 				return_error = BR_DEAD_REPLY;
 			mutex_unlock(&context->context_mgr_node_lock);
-			if (target_node && target_proc == proc) {
+			if (target_node && target_proc->pid == proc->pid) {
 				binder_user_error("%d:%d got transaction to context manager from process owning it\n",
 						  proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;


