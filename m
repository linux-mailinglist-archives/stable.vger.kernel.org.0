Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC14526BB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346461AbhKPCKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239164AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC4E632D7;
        Mon, 15 Nov 2021 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997775;
        bh=rfwb3BbPLhhB0j41/WJ59AHw3FNFj+OfFXZuY7Cir94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awYOZAQVh9dIdVs8RUwnaQxc1hmInh0n1Z61BCRX2YqB37w9eAGVRhufNe1yuza1N
         3jVM2Zz+T8jRzPD/PdIVmBD6sVm/FUbk2ofAfMX0PApEZrmeX2/ydIV/r6JCnsFKy1
         uF8/LOlsbnJoByVUFWkP1AqBqHOyW+29pINGx0zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/575] lockdep: Let lock_is_held_type() detect recursive read as read
Date:   Mon, 15 Nov 2021 17:59:55 +0100
Message-Id: <20211115165353.107496733@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2507003a1d10917c9158077bf6030719d02c941e ]

lock_is_held_type(, 1) detects acquired read locks. It only recognized
locks acquired with lock_acquire_shared(). Read locks acquired with
lock_acquire_shared_recursive() are not recognized because a `2' is
stored as the read value.

Rework the check to additionally recognise lock's read value one and two
as a read held lock.

Fixes: e918188611f07 ("locking: More accurate annotations for read_lock()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lkml.kernel.org/r/20210903084001.lblecrvz4esl4mrr@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2823329143503..1f6a2f1226fa9 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5303,7 +5303,7 @@ int __lock_is_held(const struct lockdep_map *lock, int read)
 		struct held_lock *hlock = curr->held_locks + i;
 
 		if (match_held_lock(hlock, lock)) {
-			if (read == -1 || hlock->read == read)
+			if (read == -1 || !!hlock->read == read)
 				return 1;
 
 			return 0;
-- 
2.33.0



