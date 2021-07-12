Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332653C51D9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345095AbhGLHnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348012AbhGLHkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5D161153;
        Mon, 12 Jul 2021 07:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075454;
        bh=GsM7kTT8tLZRHnd8pH8qOql2SjIfQ9+HXrYJLfJFeGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO96PGtXgk8pIq08JEcAl5B69R4ldRSXD9qdLezWkLZ/R8kXoJdUhhBizIsAC8JPf
         LMMsR1e/eByQrkcjveZ5e89eoExLOTg+2JMiU5ymbjro0rne4bxvAN1EmbAuLbceGJ
         b0w+dA7xYsrbFQYpqVt400CfU7660NPwG5Sokm7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 226/800] random32: Fix implicit truncation warning in prandom_seed_state()
Date:   Mon, 12 Jul 2021 08:04:09 +0200
Message-Id: <20210712060945.646455296@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d327ea15a305024ef0085252fa3657bbb1ce25f5 ]

sparse generates the following warning:

 include/linux/prandom.h:114:45: sparse: sparse: cast truncates bits from
 constant value

This is because the 64-bit seed value is manipulated and then placed in a
u32, causing an implicit cast and truncation. A forced cast to u32 doesn't
prevent this warning, which is reasonable because a typecast doesn't prove
that truncation was expected.

Logical-AND the value with 0xffffffff to make explicit that truncation to
32-bit is intended.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210525122012.6336-3-rf@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/prandom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index bbf4b4ad61df..056d31317e49 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -111,7 +111,7 @@ static inline u32 __seed(u32 x, u32 m)
  */
 static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
-	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+	u32 i = ((seed >> 32) ^ (seed << 10) ^ seed) & 0xffffffffUL;
 
 	state->s1 = __seed(i,   2U);
 	state->s2 = __seed(i,   8U);
-- 
2.30.2



