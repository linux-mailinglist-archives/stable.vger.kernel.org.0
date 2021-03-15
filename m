Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A93533BA75
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhCOOJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232842AbhCOODo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A4F64EF3;
        Mon, 15 Mar 2021 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817022;
        bh=5Q28Insji8hCawfXC4N4OSXAj2QgE19Qfz+hVjQ/DAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezjW++H7DaIThPSu25UIKVd/uixf056rrqcY3KqwCSa/pPSUcC26NABixR0SMrO+z
         qLXcbhhXl0BnU61DWWnKJQxjdJbqDKnTVV70Tcooc4poppR6m/sqVaNZwBbj4J9FQy
         RmNiOA9iEZjL6torwVmvEhhIqmH5Qi4lm0CGX+Gg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 264/306] seqlock,lockdep: Fix seqcount_latch_init()
Date:   Mon, 15 Mar 2021 14:55:27 +0100
Message-Id: <20210315135516.564663602@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4817a52b306136c8b2b2271d8770401441e4cf79 ]

seqcount_init() must be a macro in order to preserve the static
variable that is used for the lockdep key. Don't then wrap it in an
inline function, which destroys that.

Luckily there aren't many users of this function, but fix it before it
becomes a problem.

Fixes: 80793c3471d9 ("seqlock: Introduce seqcount_latch_t")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YEeFEbNUVkZaXDp4@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 2f7bb92b4c9e..f61e34fbaaea 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -664,10 +664,7 @@ typedef struct {
  * seqcount_latch_init() - runtime initializer for seqcount_latch_t
  * @s: Pointer to the seqcount_latch_t instance
  */
-static inline void seqcount_latch_init(seqcount_latch_t *s)
-{
-	seqcount_init(&s->seqcount);
-}
+#define seqcount_latch_init(s) seqcount_init(&(s)->seqcount)
 
 /**
  * raw_read_seqcount_latch() - pick even/odd latch data copy
-- 
2.30.1



