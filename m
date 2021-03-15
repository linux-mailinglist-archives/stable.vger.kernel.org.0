Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D3333BA7B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhCOOJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhCOOD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27BF264F0B;
        Mon, 15 Mar 2021 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817034;
        bh=/JTvGATYW5r/jlAqVIzH0rTIktRXFjvbCTITl6syH2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFThMuuveseEsqLvMS+Dr4PgRsZaFqLZ+20LBDoARZo5iCNPcyX5mJaXHK8QpqwTd
         f9yS6STLiD5Pd4kLL4GLCNUQcCyjrMa9bSrhr7yF9XqyeBqKxPxkSixsYBBD4O+JjE
         ou/xK+ebyY58M6HfDzCRxIXpzFYPP5U5Bi5GZZsg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/290] seqlock,lockdep: Fix seqcount_latch_init()
Date:   Mon, 15 Mar 2021 14:55:50 +0100
Message-Id: <20210315135550.693627314@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index cbfc78b92b65..1ac20d75b061 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -659,10 +659,7 @@ typedef struct {
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



