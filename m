Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080233BBF8F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhGEPc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhGEPcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2632761176;
        Mon,  5 Jul 2021 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498973;
        bh=GsM7kTT8tLZRHnd8pH8qOql2SjIfQ9+HXrYJLfJFeGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3gdTXmHG3G/+OLlfmXr/o9cHyF4HCRY4o6EJMWhdFqEmsJwQYDxC9Ai8VwBnAGED
         chXNgbU8UClZFcn9zYn4ZCWuoZ5KrqtGmIXBSAJW0h4P42TH0jzvgDpWOX/yqoWEZC
         g9Zzr7kqNlrUmX98ADahUMsYPQVUr1mEjumpVZ3o7CO3tcJDx/hf7GfTOLXvNzZz35
         1NP37VxWeGK296fA723f63WKv+KBTmqSOsQJBiTzbrdRSY+HfRSUwwIWSLhsQvJQa/
         wHu9sJ1h1amSKNfcmifoteVuHV8bUwUp59evxIHAFGnASsLvWi5PXJ78Wgm7twYFLR
         2zG4K8P0/S0sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        kernel test robot <lkp@intel.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 16/52] random32: Fix implicit truncation warning in prandom_seed_state()
Date:   Mon,  5 Jul 2021 11:28:37 -0400
Message-Id: <20210705152913.1521036-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
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

