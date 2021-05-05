Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03B437427C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhEEQrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235900AbhEEQpP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A0961431;
        Wed,  5 May 2021 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232556;
        bh=krCIKtZo6P7jGrPBiaStvZ2n8tEKtJJdDsSUq2CkYcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sylkFScHikRlzJrRuAm0C1sxigX7XOZ5Ke7HyJrI+EM0hyeFen5cke0Y5eJ+4Qod0
         CM/KSp1orOUytEnBUU884+514jBG55sLGqfwCky35VA6Ew8cMXqiWZ+JoXad0Rac2+
         Fvw/SWwulKXwZMPAYMVOihxoSyC8k4AlWzHg+feaMrFKyFCEh61JLaJUqEaNvVRlQ4
         xaPHRHwgjNFTVrmGq2Uzx6qg5LQT0a4nMfQqojDtxrq8Fc/keyLvzZ0EvtDKLBnv95
         umFaaXjPBOEXACz8Pmiw47xiYb0qxLy1rBK5Xf76o4vdtn2Mq/i4scBEbCd/b5IYPp
         IR3QH9noU7vbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mihai Moldovan <ionic@ionic.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 070/104] kconfig: nconf: stop endless search loops
Date:   Wed,  5 May 2021 12:33:39 -0400
Message-Id: <20210505163413.3461611-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihai Moldovan <ionic@ionic.de>

[ Upstream commit 8c94b430b9f6213dec84e309bb480a71778c4213 ]

If the user selects the very first entry in a page and performs a
search-up operation, or selects the very last entry in a page and
performs a search-down operation that will not succeed (e.g., via
[/]asdfzzz[Up Arrow]), nconf will never terminate searching the page.

The reason is that in this case, the starting point will be set to -1
or n, which is then translated into (n - 1) (i.e., the last entry of
the page) or 0 (i.e., the first entry of the page) and finally the
search begins. This continues to work fine until the index reaches 0 or
(n - 1), at which point it will be decremented to -1 or incremented to
n, but not checked against the starting point right away. Instead, it's
wrapped around to the bottom or top again, after which the starting
point check occurs... and naturally fails.

My original implementation added another check for -1 before wrapping
the running index variable around, but Masahiro Yamada pointed out that
the actual issue is that the comparison point (starting point) exceeds
bounds (i.e., the [0,n-1] interval) in the first place and that,
instead, the starting point should be fixed.

This has the welcome side-effect of also fixing the case where the
starting point was n while searching down, which also lead to an
infinite loop.

OTOH, this code is now essentially all his work.

Amazingly, nobody seems to have been hit by this for 11 years - or at
the very least nobody bothered to debug and fix this.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/nconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index e0f965529166..af814b39b876 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -504,8 +504,8 @@ static int get_mext_match(const char *match_str, match_f flag)
 	else if (flag == FIND_NEXT_MATCH_UP)
 		--match_start;
 
+	match_start = (match_start + items_num) % items_num;
 	index = match_start;
-	index = (index + items_num) % items_num;
 	while (true) {
 		char *str = k_menu_items[index].str;
 		if (strcasestr(str, match_str) != NULL)
-- 
2.30.2

