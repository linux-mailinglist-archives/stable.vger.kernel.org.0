Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A52353EAF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbhDEJH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhDEJHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5DA661002;
        Mon,  5 Apr 2021 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613626;
        bh=S5j3nG5j6iipdN+6gyLF8VpxH2vLYLDsPzgnhRd8Xg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTr2F8XNJMELREsBbAftE1PdtxvhS3T0autS9xDrc7ldNjMqrOx5MFSjPneGbcPQe
         hmfjCuQspm6kQVpV6EC6AAyLsFaT2Dr15NxXqSJB1Tl2wYcVcTf3OX1NmImJkOVIBa
         zETU+6DK2jKsPybEqzNxRyG+4suJsGk1FiH0UeJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/126] locking/ww_mutex: Fix acquire/release imbalance in ww_acquire_init()/ww_acquire_fini()
Date:   Mon,  5 Apr 2021 10:53:13 +0200
Message-Id: <20210405085032.068014102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



