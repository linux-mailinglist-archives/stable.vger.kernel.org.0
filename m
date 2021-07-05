Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3771D3BC076
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhGEPgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhGEPey (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE3A619B2;
        Mon,  5 Jul 2021 15:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499085;
        bh=nFiVBD9s1F0BKiFDeyhGID7OC5rzFoiX0HeTvFie4L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0s7NSQcG4AhAnIQCCuZFJtyf8drTZ1yCjslgGnO7023fl5Bd76qD3hzvLSerAfiz
         tEisbni1RFYHA+s51Xxd5qg8Lzxn1wxXATIc2Q1Q6XmZInV5jc8DV9jayEHhaGVacB
         ITbLicwBQCZfbGCN+AkOBVc85r1tMAQa6KMwgn5B3Zhr0hDVdOZrUXx1KbRmBFCRMS
         fO07oHyQAl0cK5YfKfAqzOinkOK9rcS1h/sdLVK9wQLq9FdOxEsUHbS2HIvj9jrRxx
         jCWdjV1+Jcj3wg+QU3Wzt5BaRhBPA8Kvw/UGRIL6JNeTPkiBZ3NhZdd4rBR68FbXMZ
         /cHXBZ91Sjszw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        kernel test robot <lkp@intel.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/17] random32: Fix implicit truncation warning in prandom_seed_state()
Date:   Mon,  5 Jul 2021 11:31:05 -0400
Message-Id: <20210705153114.1522046-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153114.1522046-1-sashal@kernel.org>
References: <20210705153114.1522046-1-sashal@kernel.org>
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

