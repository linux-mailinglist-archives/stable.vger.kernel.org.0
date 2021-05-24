Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C5038EF91
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhEXP6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234870AbhEXP5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6435D61951;
        Mon, 24 May 2021 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871011;
        bh=8UAYECxSB2/SyPk/IQ/Eo++kvlCJAddxyNSq/jyfuTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lf6tq+XHk4YE6YzK7ekcIa7ubs0vxubuev+MxGFqQIuFY/57VlgFsfeVVFYiUlZBk
         eJDolvWwVT3rsxlrHoCKYdIXVgJc87g/foh7KcBefyRAPUg0FfxYu/FFZfwf9Y9b47
         AV8IKMrf/vCquFJw/UJwsgI9KD8HtAw+EDTHLI2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 032/127] locking/lockdep: Correct calling tracepoints
Date:   Mon, 24 May 2021 17:25:49 +0200
Message-Id: <20210524152335.930163642@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 89e70d5c583c55088faa2201d397ee30a15704aa ]

The commit eb1f00237aca ("lockdep,trace: Expose tracepoints") reverses
tracepoints for lock_contended() and lock_acquired(), thus the ftrace
log shows the wrong locking sequence that "acquired" event is prior to
"contended" event:

  <idle>-0       [001] d.s3 20803.501685: lock_acquire: 0000000008b91ab4 &sg_policy->update_lock
  <idle>-0       [001] d.s3 20803.501686: lock_acquired: 0000000008b91ab4 &sg_policy->update_lock
  <idle>-0       [001] d.s3 20803.501689: lock_contended: 0000000008b91ab4 &sg_policy->update_lock
  <idle>-0       [001] d.s3 20803.501690: lock_release: 0000000008b91ab4 &sg_policy->update_lock

This patch fixes calling tracepoints for lock_contended() and
lock_acquired().

Fixes: eb1f00237aca ("lockdep,trace: Expose tracepoints")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210512120937.90211-1-leo.yan@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f160f1c97ca1..f39c383c7180 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5731,7 +5731,7 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_acquired(lock, ip);
+	trace_lock_contended(lock, ip);
 
 	if (unlikely(!lock_stat || !lockdep_enabled()))
 		return;
@@ -5749,7 +5749,7 @@ void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_contended(lock, ip);
+	trace_lock_acquired(lock, ip);
 
 	if (unlikely(!lock_stat || !lockdep_enabled()))
 		return;
-- 
2.30.2



