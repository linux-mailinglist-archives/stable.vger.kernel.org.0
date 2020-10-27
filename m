Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC529B92A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802224AbgJ0PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798456AbgJ0P2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E76206F4;
        Tue, 27 Oct 2020 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812489;
        bh=6Q7x4S6+9zUtrldXV1My6hy5Q1tvDQSMh9Dbc8fIYnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+RiS2Z5u91zaiCjBLeJGYpAYn4BOm+Wxj09xlqXLX12ry4mUgIxfd/oiB5jUhOjl
         3hSt7XsBBiGBuW+PQxYigZmnEQCoPbMk3BqByU1ggD/W6TVDDuEkIlFL3qE3uZUCtY
         fAab7aKUfCzzUeS46CVVM4P35gi2xf8QPFLj7N2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e113a0b970b7b3f394ba@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Todd Kjos <tkjos@google.com>, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 227/757] binder: Remove bogus warning on failed same-process transaction
Date:   Tue, 27 Oct 2020 14:47:57 +0100
Message-Id: <20201027135501.254038212@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index e8a1db4a86ed8..b27b6bf0c1186 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2323,8 +2323,6 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
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



