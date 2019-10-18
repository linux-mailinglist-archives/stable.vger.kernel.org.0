Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1344ADD339
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392864AbfJRWQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387615AbfJRWIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB7B22459;
        Fri, 18 Oct 2019 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436495;
        bh=lcRJMau4MilgjA1G5AsVvBldze0ky+F5z1BAy1+tpLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOog/SHyF2DZUbNgKscrCQe5L1ThAsSEB4Tcx9iGVkQX61W2QusUNmKQcveenjxju
         qoDJqRC1QW7Ni0f3VmcaB0u3IcpDrZGFpD01aqLTO2SBf9TwEqqp+RGXdoAwlcp7kL
         qS1WpWaDNJmyzEsU3z+WJlkbqnggMCHMfXaQ3U6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Christian Kujau <lists@nerdbynature.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexander Kapshuk <alexander.kapshuk@gmail.com>,
        Genki Sky <sky@genki.is>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 09/56] scripts/setlocalversion: Improve -dirty check with git-status --no-optional-locks
Date:   Fri, 18 Oct 2019 18:07:06 -0400
Message-Id: <20191018220753.10002-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit ff64dd4857303dd5550faed9fd598ac90f0f2238 ]

git-diff-index does not refresh the index for you, so using it for a
"-dirty" check can give misleading results. Commit 6147b1cf19651
("scripts/setlocalversion: git: Make -dirty check more robust") tried to
fix this by switching to git-status, but it overlooked the fact that
git-status also writes to the .git directory of the source tree, which
is definitely not kosher for an out-of-tree (O=) build. That is getting
reverted.

Fortunately, git-status now supports avoiding writing to the index via
the --no-optional-locks flag, as of git 2.14. It still calculates an
up-to-date index, but it avoids writing it out to the .git directory.

So, let's retry the solution from commit 6147b1cf19651 using this new
flag first, and if it fails, we assume this is an older version of git
and just use the old git-diff-index method.

It's hairy to get the 'grep -vq' (inverted matching) correct by stashing
the output of git-status (you have to be careful about the difference
betwen "empty stdin" and "blank line on stdin"), so just pipe the output
directly to grep and use a regex that's good enough for both the
git-status and git-diff-index version.

Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Suggested-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Genki Sky <sky@genki.is>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/setlocalversion | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 71f39410691b6..365b3c2b8f431 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -73,8 +73,16 @@ scm_version()
 			printf -- '-svn%s' "`git svn find-rev $head`"
 		fi
 
-		# Check for uncommitted changes
-		if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
+		# Check for uncommitted changes.
+		# First, with git-status, but --no-optional-locks is only
+		# supported in git >= 2.14, so fall back to git-diff-index if
+		# it fails. Note that git-diff-index does not refresh the
+		# index, so it may give misleading results. See
+		# git-update-index(1), git-diff-index(1), and git-status(1).
+		if {
+			git --no-optional-locks status -uno --porcelain 2>/dev/null ||
+			git diff-index --name-only HEAD
+		} | grep -qvE '^(.. )?scripts/package'; then
 			printf '%s' -dirty
 		fi
 
-- 
2.20.1

