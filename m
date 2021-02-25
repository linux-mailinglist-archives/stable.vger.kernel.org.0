Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AE324D78
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhBYKBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233743AbhBYJ7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:59:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB3F64F1C;
        Thu, 25 Feb 2021 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246908;
        bh=BNFaJw7x5QqIAvV45WIZ+T4caCNc7lTS5t+FNBVKa64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wd5nRUo5kTv9r8gJ1WToLRkbEcZ8jGd0NM8BOzZ+kBOZXPLybe3+TDKjj4VkpoNls
         M/3BMVey8igysu61Tpgz9uw7OmnSTlKQIxihXaMyqNFCooDh0mlWe9a5CS+NaLKadQ
         4Z9w8iM2tLOjtVDhG9J0MRnLwqVHZbkvvlIIPNGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/23] kbuild: fix CONFIG_TRIM_UNUSED_KSYMS build for ppc64
Date:   Thu, 25 Feb 2021 10:53:53 +0100
Message-Id: <20210225092517.578415148@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



