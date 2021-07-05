Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC893BC0AB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhGEPhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhGEPf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C4F36199B;
        Mon,  5 Jul 2021 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499106;
        bh=nFiVBD9s1F0BKiFDeyhGID7OC5rzFoiX0HeTvFie4L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOMBLGUo1cAa+bOks0vZMFKRRGQDerx1jj9Jwilk5SygCaM8shYzFdP2j12T9Idd/
         qvmj/7m1V1HQJPv4iE29fYqnU05Ozz/YqAkYECuDVG75HOBoldWnQH0wUjFRiAKbFR
         ek3fGy1e3KbXsU6TiZ2gI5Q24gvy6N1pjZhldKKRFUJVbYNmF+BcTbJuuedGA75O52
         CCXvQMGsxlU8QJKvVg8UP3tbdULv5avfNGQCVlsQIsaGbEgu6wc0/Ebt30pxBOU62b
         xJOI2H4LLtiSa0AGxkK1d7jl8O4s4n/aQD1QgUPEN49q8L+59PywGUVG8laoDIRLhg
         6qW/19RscqHuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        kernel test robot <lkp@intel.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 08/15] random32: Fix implicit truncation warning in prandom_seed_state()
Date:   Mon,  5 Jul 2021 11:31:29 -0400
Message-Id: <20210705153136.1522245-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cc1e71334e53..e20339c78a84 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -93,7 +93,7 @@ static inline u32 __seed(u32 x, u32 m)
  */
 static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
-	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+	u32 i = ((seed >> 32) ^ (seed << 10) ^ seed) & 0xffffffffUL;
 
 	state->s1 = __seed(i,   2U);
 	state->s2 = __seed(i,   8U);
-- 
2.30.2

