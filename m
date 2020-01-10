Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B71C137966
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgAJWIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbgAJWFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0332084D;
        Fri, 10 Jan 2020 22:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693942;
        bh=RNGAbkS0QpRKRe5JyR2CV5SejROUXgzqvXeZT5Sj1KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqm7tVOMPqh68NQ4hfsPZB+CLWZj9MKGLQCueZVk23iVqWfxf3j+5gnE1ik41mV6V
         6eIdvFzBajiivXaobFi7cAMvB8rhEUoJTKuWxOBjhlgmhnCeltqDqyIlxrAoR/kzZ2
         a+2C/UoJjMIOLPM74CD1Cvm4Yllg75ejRO27hhgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/26] kbuild/deb-pkg: annotate libelf-dev dependency as :native
Date:   Fri, 10 Jan 2020 17:05:16 -0500
Message-Id: <20200110220519.28250-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 8ffdc54b6f4cd718a45802e645bb853e3a46a078 ]

Cross compiling the x86 kernel on a non-x86 build machine produces
the following error when CONFIG_UNWINDER_ORC is enabled, regardless
of whether libelf-dev is installed or not.

  dpkg-checkbuilddeps: error: Unmet build dependencies: libelf-dev
  dpkg-buildpackage: warning: build dependencies/conflicts unsatisfied; aborting
  dpkg-buildpackage: warning: (Use -d flag to override.)

Since this is a build time dependency for a build tool, we need to
depend on the native version of libelf-dev so add the appropriate
annotation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkdebian | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index e0750b70453f..786c5ab37d00 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -136,7 +136,7 @@ mkdir -p debian/source/
 echo "1.0" > debian/source/format
 
 echo $debarch > debian/arch
-extra_build_depends=", $(if_enabled_echo CONFIG_UNWINDER_ORC libelf-dev)"
+extra_build_depends=", $(if_enabled_echo CONFIG_UNWINDER_ORC libelf-dev:native)"
 extra_build_depends="$extra_build_depends, $(if_enabled_echo CONFIG_SYSTEM_TRUSTED_KEYRING libssl-dev:native)"
 
 # Generate a simple changelog template
-- 
2.20.1

