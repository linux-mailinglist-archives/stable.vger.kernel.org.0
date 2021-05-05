Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326C53745D0
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhEERH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238311AbhEERFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8423C61417;
        Wed,  5 May 2021 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232942;
        bh=fTf4qo64soCDRDnKGHNUSCNtTuVdhpbH+CBMMyRAsiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADt4CGzvTPjlC80Vc6rHc2RU5Tx4I2RK4EtcJdNYzp4h1/xGh5Lqlso9GPhjQqBFg
         d20S680luo3LKHATvcFVbq+i2yWjZ2ZPVM3TrCeHuLilhwp4MXkZ2K7B6dgRYkVFK2
         PwnLiVn0LJk+cDvZ4k01dgndfveHfC0pMGdR2EFDE4V0TtI2FrYTKxMd14unIlRgsY
         NoXpHJ/JinpqoFwakpJSbZ+b7+rW68bJqsHpoyFDQ4MsRaJkFItHRs8ud4CJ/7WcIL
         w+xsr+L7xaf29PMOlE3s4p9Ee0Qf0bsv2OUWesl+jB3b/dWsC0jsNUqdjaixP245j0
         oFrUaklS1sB8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mihai Moldovan <ionic@ionic.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 14/19] kconfig: nconf: stop endless search loops
Date:   Wed,  5 May 2021 12:41:57 -0400
Message-Id: <20210505164203.3464510-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164203.3464510-1-sashal@kernel.org>
References: <20210505164203.3464510-1-sashal@kernel.org>
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
index f7049e288e93..c58a46904861 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -502,8 +502,8 @@ static int get_mext_match(const char *match_str, match_f flag)
 	else if (flag == FIND_NEXT_MATCH_UP)
 		--match_start;
 
+	match_start = (match_start + items_num) % items_num;
 	index = match_start;
-	index = (index + items_num) % items_num;
 	while (true) {
 		char *str = k_menu_items[index].str;
 		if (strcasestr(str, match_str) != 0)
-- 
2.30.2

