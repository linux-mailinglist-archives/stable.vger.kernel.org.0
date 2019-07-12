Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6262B66D99
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGLMbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfGLMbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889E121019;
        Fri, 12 Jul 2019 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934705;
        bh=2UB7NHElc5e3ubkFiiIstTcEaan7t9U1hELRnX40JlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knSdtgxzX3aKbBqrj50xtSNVr88g7BljCPn/5k3uPPexpMJwPxx5NU+nGIPXb6wjB
         krQvPD8B/jnqjalmeIu+2reYeWErDsvlvP5/8KdNtLdQY0YJYw64702R/UHXZwbU9k
         pp9/ayzWeQcWnNrDUoCSX/2vcfWcEUZC3rIyuo4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+182ce46596c3f2e1eb24@syzkaller.appspotmail.com,
        Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.1 125/138] binder: fix memory leak in error path
Date:   Fri, 12 Jul 2019 14:19:49 +0200
Message-Id: <20190712121633.533436037@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@android.com>

commit 1909a671dbc3606685b1daf8b22a16f65ea7edda upstream.

syzkallar found a 32-byte memory leak in a rarely executed error
case. The transaction complete work item was not freed if put_user()
failed when writing the BR_TRANSACTION_COMPLETE to the user command
buffer. Fixed by freeing it before put_user() is called.

Reported-by: syzbot+182ce46596c3f2e1eb24@syzkaller.appspotmail.com
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/android/binder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4267,6 +4267,8 @@ retry:
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
 			binder_inner_proc_unlock(proc);
 			cmd = BR_TRANSACTION_COMPLETE;
+			kfree(w);
+			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 			if (put_user(cmd, (uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
@@ -4275,8 +4277,6 @@ retry:
 			binder_debug(BINDER_DEBUG_TRANSACTION_COMPLETE,
 				     "%d:%d BR_TRANSACTION_COMPLETE\n",
 				     proc->pid, thread->pid);
-			kfree(w);
-			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 		} break;
 		case BINDER_WORK_NODE: {
 			struct binder_node *node = container_of(w, struct binder_node, work);


