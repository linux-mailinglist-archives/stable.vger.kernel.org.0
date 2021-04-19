Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26279364412
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbhDSNZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240623AbhDSNXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 386B861403;
        Mon, 19 Apr 2021 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838310;
        bh=/2CvmpTGdlmNE/GyxoOZcvGZshJIB1MvtP261I7s01Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqQboO4nIZR2zzpynBiDcnZ8MZaEH6m1PEmcq65lZW8qDh3ysRbYefH515qRmbTEv
         hDECJTU1Xc5J/7v1v68iGTnontasimSpN2TlU2hMAQlKLoLoDx5IspbI6s9aLMNWY1
         x+9QZW7uqsz9Q0ssLR97flS/spZK5hXAhvH0maDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/73] lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message
Date:   Mon, 19 Apr 2021 15:06:06 +0200
Message-Id: <20210419130524.321295463@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3a85969e9d912d5dd85362ee37b5f81266e00e77 ]

Since this message is printed when dynamically allocated spinlocks (e.g.
kzalloc()) are used without initialization (e.g. spin_lock_init()),
suggest to developers to check whether initialization functions for objects
were called, before making developers wonder what annotation is missing.

[ mingo: Minor tweaks to the message. ]

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210321064913.4619-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index bca0f7f71cde..7429f1571755 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -875,7 +875,8 @@ static bool assign_lock_key(struct lockdep_map *lock)
 		/* Debug-check: all keys must be persistent! */
 		debug_locks_off();
 		pr_err("INFO: trying to register non-static key.\n");
-		pr_err("the code is fine but needs lockdep annotation.\n");
+		pr_err("The code is fine but needs lockdep annotation, or maybe\n");
+		pr_err("you didn't initialize this object before use?\n");
 		pr_err("turning off the locking correctness validator.\n");
 		dump_stack();
 		return false;
-- 
2.30.2



