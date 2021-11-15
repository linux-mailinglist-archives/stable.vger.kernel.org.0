Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D64245243A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343834AbhKPBgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242476AbhKOSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAFE63316;
        Mon, 15 Nov 2021 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999583;
        bh=eF3/QmgcPn7aRdWZs01+PigrocKT3mCZencTM3OuFsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QivtaYRjukPMMuhtzeCavkfITQcwUnXWh7ySZ6FuZ5mrJSSckW9LtqJPmhtrUDpuk
         N3y/ZkkvpHiuffhp6Oihg/lG3MHYE0k/mi2Tsi4WMEpzWBb5IdnFlLAjBgsm4/7ghr
         NFh5MB7ThURzDmnHD0qakV0tIC7oYN38wtdcV42s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 349/849] lockdep: Let lock_is_held_type() detect recursive read as read
Date:   Mon, 15 Nov 2021 17:57:12 +0100
Message-Id: <20211115165432.045907260@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 8a509672a4cc9..d624231eab2bb 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5366,7 +5366,7 @@ int __lock_is_held(const struct lockdep_map *lock, int read)
 		struct held_lock *hlock = curr->held_locks + i;
 
 		if (match_held_lock(hlock, lock)) {
-			if (read == -1 || hlock->read == read)
+			if (read == -1 || !!hlock->read == read)
 				return LOCK_STATE_HELD;
 
 			return LOCK_STATE_NOT_HELD;
-- 
2.33.0



