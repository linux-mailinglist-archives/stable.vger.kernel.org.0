Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9855EEF6B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfKDV6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388715AbfKDV6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:04 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA1C720650;
        Mon,  4 Nov 2019 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904682;
        bh=lcRJMau4MilgjA1G5AsVvBldze0ky+F5z1BAy1+tpLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zg1UH2YWhqmAcrzyXUxC1UfLSLnWUcMCiOJqlvmRMlVSY8HdXhVGaAOUo50CzTaxE
         VMAzeNB+CuFZwTE2URuBxp16pqxFUoqNsIuumKxT71su6AlXCHMI+VyCxtXc91f2Ta
         P0dY4ubXpXpKhyp9x1+L2DIgcDjlOIzN9Uzm/jig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Kujau <lists@nerdbynature.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexander Kapshuk <alexander.kapshuk@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Genki Sky <sky@genki.is>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/149] scripts/setlocalversion: Improve -dirty check with git-status --no-optional-locks
Date:   Mon,  4 Nov 2019 22:43:44 +0100
Message-Id: <20191104212137.936035680@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



