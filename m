Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7879348F8A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhCYL2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhCYL0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C485D61A46;
        Thu, 25 Mar 2021 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671601;
        bh=S5j3nG5j6iipdN+6gyLF8VpxH2vLYLDsPzgnhRd8Xg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGc2olprPi6fHWO+MVxn4oAssmMU1G2RVMagOBmOfsqIhGon1ZLtNYI4HK3LeD5pg
         MrlPj5fN4pLWccB5MVJme/W3UyjGSkcVHcrGQnztaCZBD/aLWE7NFM7ZvJ62q1Rztu
         c9nB0C2gH1Ri+qpoYzbDKdPR6+x7xMm5dbTK9RY+09oHT83KqyCiZdHs0BQAyDFEVM
         Nw+nyKdM0A3qNFVLs74w4UqQXJDwRN4UdU8ckory3EoalLsSKVjN+ntytNTSXyn8u3
         pm+GZ1qi2tIRrQ/1KnWANdZbjxqbG3b/yOhmPIWauLcQ3ivf6fdYjfT7EvhX3hQjZc
         8xVk3EWsQncgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 32/39] locking/ww_mutex: Fix acquire/release imbalance in ww_acquire_init()/ww_acquire_fini()
Date:   Thu, 25 Mar 2021 07:25:51 -0400
Message-Id: <20210325112558.1927423-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit bee645788e07eea63055d261d2884ea45c2ba857 ]

In ww_acquire_init(), mutex_acquire() is gated by CONFIG_DEBUG_LOCK_ALLOC.
The dep_map in the ww_acquire_ctx structure is also gated by the
same config. However mutex_release() in ww_acquire_fini() is gated by
CONFIG_DEBUG_MUTEXES. It is possible to set CONFIG_DEBUG_MUTEXES without
setting CONFIG_DEBUG_LOCK_ALLOC though it is an unlikely configuration.
That may cause a compilation error as dep_map isn't defined in this
case. Fix this potential problem by enclosing mutex_release() inside
CONFIG_DEBUG_LOCK_ALLOC.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210316153119.13802-3-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ww_mutex.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 850424e5d030..6ecf2a0220db 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -173,9 +173,10 @@ static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
  */
 static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
 {
-#ifdef CONFIG_DEBUG_MUTEXES
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	mutex_release(&ctx->dep_map, _THIS_IP_);
-
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
 	DEBUG_LOCKS_WARN_ON(ctx->acquired);
 	if (!IS_ENABLED(CONFIG_PROVE_LOCKING))
 		/*
-- 
2.30.1

