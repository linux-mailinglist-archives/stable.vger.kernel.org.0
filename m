Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC62313C12
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhBHSA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235115AbhBHR7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 12:59:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 380DB64EA4;
        Mon,  8 Feb 2021 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807096;
        bh=Y3lm0UJOooi/cZh1vHuUz8TAPZVc/grlGeUxI5mXckM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyMt8woTvEIDD7i63vOz2/FvPmX5gdF2d2Oa9/tf/DFuUSZGDfRyp24Qxh4CuHllD
         pzfeLhZT+U+6RJdEXtwIa+C3cWYjHDWlKYtLxAjfDZNubrNrx/uHPEPukk6rqoWTeo
         tj8aq+D/DqWZixzPFLB/4munB/jM5IazV2geZSCoR5zUDlzxxaHR4FS+O2vxVjWjC1
         dUTm9HYYt1yIN+slR3xb/9LmdX10p17/avoMUPY09467ItrriEbyYo+7qGMiRwIjBs
         SP9VfS+y7WP6BbEVpzmu+kVj7kFawuMTJHuUd+0Blbt+QLYr2/Z9lcmuCD7v9XCzjl
         zBHPfxwBzjzEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 07/36] kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc
Date:   Mon,  8 Feb 2021 12:57:37 -0500
Message-Id: <20210208175806.2091668-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f4c3b83b75b91c5059726cb91e3165cc01764ce7 ]

With commit 1e860048c53e ("gcc-plugins: simplify GCC plugin-dev
capability test") applied, this hunk can be way simplified because
now scripts/gcc-plugins/Kconfig only checks plugin-version.h

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dummy-tools/gcc | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/scripts/dummy-tools/gcc b/scripts/dummy-tools/gcc
index 33487e99d83e5..5c113cad56017 100755
--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -75,16 +75,12 @@ if arg_contain -S "$@"; then
 	fi
 fi
 
-# For scripts/gcc-plugin.sh
+# To set GCC_PLUGINS
 if arg_contain -print-file-name=plugin "$@"; then
 	plugin_dir=$(mktemp -d)
 
-	sed -n 's/.*#include "\(.*\)"/\1/p' $(dirname $0)/../gcc-plugins/gcc-common.h |
-	while read header
-	do
-		mkdir -p $plugin_dir/include/$(dirname $header)
-		touch $plugin_dir/include/$header
-	done
+	mkdir -p $plugin_dir/include
+	touch $plugin_dir/include/plugin-version.h
 
 	echo $plugin_dir
 	exit 0
-- 
2.27.0

