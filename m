Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C190531C19F
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhBOShl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhBOShj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6856964E26;
        Mon, 15 Feb 2021 18:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414218;
        bh=BNFaJw7x5QqIAvV45WIZ+T4caCNc7lTS5t+FNBVKa64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJiG/R8RxdW84zClqRnnlPe1BAHPjlXC6ANvYY3Lovr/YhEW9lArG+zrV1vY8YqD3
         pHjwgmI3MVcdqyWMimiTdzomEfbiLX2SAO4B0/utE95tRkWOex+40fKWMN/xQBh8XH
         PhNzDyxlxhIpd8biENgV2OhVPbP9S+pQDnQa4G7RhUxAz5M487aQdYg7uVJ7DvEDPX
         xKf6nvH5p8/gNWzZic4481Ua6t1VPAx5rz4VcG6dg0k09MJMIcrJGp3sJcB/5svezd
         mZl4YikbG5BGVLLXOrpg48dtv7PmOuZpERK/p+4uBRq/ZhL8BGfUE2O/g/J+oK7lNw
         s3ZOb9w+CV4gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 5/6] kbuild: fix CONFIG_TRIM_UNUSED_KSYMS build for ppc64
Date:   Mon, 15 Feb 2021 13:36:50 -0500
Message-Id: <20210215183651.122001-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183651.122001-1-sashal@kernel.org>
References: <20210215183651.122001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 29500f15b54b63ad0ea60b58e85144262bd24df2 ]

Stephen Rothwell reported a build error on ppc64 when
CONFIG_TRIM_UNUSED_KSYMS is enabled.

Jessica Yu pointed out the cause of the error with the reference to the
ppc64 ELF ABI:
  "Symbol names with a dot (.) prefix are reserved for holding entry
   point addresses. The value of a symbol named ".FN", if it exists,
   is the entry point of the function "FN".

As it turned out, CONFIG_TRIM_UNUSED_KSYMS has never worked for ppc64,
but this issue has been unnoticed until recently because this option
depends on !UNUSED_SYMBOLS hence is disabled by all{mod,yes}config.
(Then, it was uncovered by another patch removing UNUSED_SYMBOLS.)

Removing the dot prefix in scripts/gen_autoksyms.sh fixes the issue.
Please note it must be done before 'sort -u' because modules have
both ._mcount and _mcount undefined when CONFIG_FUNCTION_TRACER=y.

Link: https://lore.kernel.org/lkml/20210209210843.3af66662@canb.auug.org.au/
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gen_autoksyms.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/gen_autoksyms.sh b/scripts/gen_autoksyms.sh
index 16c0b2ddaa4c9..d54dfba15bf25 100755
--- a/scripts/gen_autoksyms.sh
+++ b/scripts/gen_autoksyms.sh
@@ -43,6 +43,9 @@ EOT
 sed 's/ko$/mod/' $modlist |
 xargs -n1 sed -n -e '2{s/ /\n/g;/^$/!p;}' -- |
 cat - "$ksym_wl" |
+# Remove the dot prefix for ppc64; symbol names with a dot (.) hold entry
+# point addresses.
+sed -e 's/^\.//' |
 sort -u |
 sed -e 's/\(.*\)/#define __KSYM_\1 1/' >> "$output_file"
 
-- 
2.27.0

