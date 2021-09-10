Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCAF4063A7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhIJAsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234850AbhIJAYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A475610A3;
        Fri, 10 Sep 2021 00:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233413;
        bh=Wq+KxzoJaZWcB5H0ty7GAaFpACHkgEoqy/aaFZr/dUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO3oR6xU7qHidhVO63TMsnWsGcV+L5xcLFzMpktFMinaxVbrmEZHHgSmLRoUWv0Ln
         Y1D7M5/TWONRsmlGplVcxI8YKcSxFCYSb3bvRixypEK1gA/sbtIhN0STHj3gaHFd6V
         vJYTHXGAyvcsUtyOadJPbsL+V4WP2v8imdxvQlliHE+M+q653PYtuy0MsbFq0NF8DW
         xLK3AZO2Rp5GORx0pi09InFFMS6qGUMXjrPwm2Iulj3AA+lsJKrSR+6l6KPBOqd1gt
         JZYGo1JOvpvG78vU8QliiOygoXFng1q7SueHpXUljSw9AV1mDr+CbLw9x4rwbIGEeD
         H7mbggjOvHQ5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ariel Marcovitch <arielmarcovitch@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 17/19] checkkconfigsymbols.py: Fix the '--ignore' option
Date:   Thu,  9 Sep 2021 20:23:07 -0400
Message-Id: <20210910002309.176412-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Marcovitch <arielmarcovitch@gmail.com>

[ Upstream commit 1439ebd2ce77242400518d4e6a1e85bebcd8084f ]

It seems like the implementation of the --ignore option is broken.

In check_symbols_helper, when going through the list of files, a file is
added to the list of source files to check if it matches the ignore
pattern. Instead, as stated in the comment below this condition, the
file should be added if it doesn't match the pattern.

This means that when providing an ignore pattern, the only files that
will be checked will be the ones we want the ignore, in addition to the
Kconfig files that don't match the pattern (the check in
parse_kconfig_files is done right)

Signed-off-by: Ariel Marcovitch <arielmarcovitch@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkkconfigsymbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
index 8cd16c65d3c5..bbf5fc30472c 100755
--- a/scripts/checkkconfigsymbols.py
+++ b/scripts/checkkconfigsymbols.py
@@ -329,7 +329,7 @@ def check_symbols_helper(pool, ignore):
         if REGEX_FILE_KCONFIG.match(gitfile):
             kconfig_files.append(gitfile)
         else:
-            if ignore and not re.match(ignore, gitfile):
+            if ignore and re.match(ignore, gitfile):
                 continue
             # add source files that do not match the ignore pattern
             source_files.append(gitfile)
-- 
2.30.2

