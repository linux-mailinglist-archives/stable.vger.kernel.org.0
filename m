Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE0F29C2CE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820854AbgJ0RjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760227AbgJ0OeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C03322202;
        Tue, 27 Oct 2020 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809244;
        bh=0Q3DlSByGyGSQ0dpJiZgz9W/y0e+sl8/RMS0gGeyX9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvITfj44P61UqZcwGaVtBRqFpV6mSF9El355xvJ/hP5AFK7scDQbEZJD5ZhNNLhQ9
         NPDbZSe/W3xS6KrTzsuWO8zjE0dNHTZLY2aDL9q03W5FMrtk0QfuiYZ6xuLM/HYxRR
         r1wCC+mx7sQUwNUESQ/hYWIYLGrcuT4G1fL4KnY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e113a0b970b7b3f394ba@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/408] binder: Remove bogus warning on failed same-process transaction
Date:   Tue, 27 Oct 2020 14:51:06 +0100
Message-Id: <20201027135501.031727637@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit e8b8ae7ce32e17a5c29f0289e9e2a39c7dcaa1b8 ]

While binder transactions with the same binder_proc as sender and recipient
are forbidden, transactions with the same task_struct as sender and
recipient are possible (even though currently there is a weird check in
binder_transaction() that rejects them in the target==0 case).
Therefore, task_struct identities can't be used to distinguish whether
the caller is running in the context of the sender or the recipient.

Since I see no easy way to make this WARN_ON() useful and correct, let's
just remove it.

Fixes: 44d8047f1d87 ("binder: use standard functions to allocate fds")
Reported-by: syzbot+e113a0b970b7b3f394ba@syzkaller.appspotmail.com
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20200806165359.2381483-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 0f56a82615389..b62b1ab6bb699 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2326,8 +2326,6 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			 * file is done when the transaction is torn
 			 * down.
 			 */
-			WARN_ON(failed_at &&
-				proc->tsk == current->group_leader);
 		} break;
 		case BINDER_TYPE_PTR:
 			/*
-- 
2.25.1



