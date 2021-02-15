Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3794F31BCE7
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhBOPhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhBOPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CAA64DB1;
        Mon, 15 Feb 2021 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403087;
        bh=Y3lm0UJOooi/cZh1vHuUz8TAPZVc/grlGeUxI5mXckM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0HwbE8J4bzsevz3hMGkfVBaa6qavwmvtHkyM5fww/Y6blJYDZR5uNPE02US7xTjD
         CUv6MFkHVZeffzwNZe9m1ymamnawXlidhfw1JQHn2E1aeg5P57wpzXdsy8bTmT0tfZ
         VyY5cqftWbJRLrJxvcCAHFYdO/Oc7Eecdncx61sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/104] kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc
Date:   Mon, 15 Feb 2021 16:26:35 +0100
Message-Id: <20210215152720.193592547@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



