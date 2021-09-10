Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCD94061B6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbhIJAna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhIJATL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E083C6023D;
        Fri, 10 Sep 2021 00:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233081;
        bh=ypqKSHZ36CPvnxbKIx0n2jHq9oNB9hziHUDJE9ERxmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unwas7XUBHN3sxqVcWdSFijXV7oe9DZ+2SJQrjEzjqgn1Zz6WdZbRvq9hLB9X/TQf
         beFirvj7Zgz0GETok/ksMerhHWRTrBQpSG6r/qoa1Y+uR7FedoJX/du785ACbgm6xz
         qQYuts+z7WbTZ5jRM9dojAeYK7wE30YbI1+1m5/nl0c1pozMlpSwioe/eut0OrM1KW
         T5jzP7ziYMOn1ow05Cg3Qp5QtQwWSON77iLsnX/r+dv4hMnwsmkA3S3BBVy7tBtg1E
         CxIHDHivMTD3yQ2iT9zFQTD/Z47WFoXARz8fGvNltBmPim0+6ivDtcPmQhO6iLpB2p
         bNhLWIjMnauRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ariel Marcovitch <arielmarcovitch@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 89/99] checkkconfigsymbols.py: Fix the '--ignore' option
Date:   Thu,  9 Sep 2021 20:15:48 -0400
Message-Id: <20210910001558.173296-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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
index 1548f9ce4682..b9b0f15e5880 100755
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

