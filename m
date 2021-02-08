Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F43137C4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhBHPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232315AbhBHPXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A333064F18;
        Mon,  8 Feb 2021 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797275;
        bh=WrbqghjL5aeZuL5WtrSMi6I7ncdWtDPCBD7Uf5j0j6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZQx0SH88ANQdKXUSLP7f1lPixBPTYiidFMDmTenbO0euTou3PSf0WoVpK1l2GfvO
         b/MRbCItzZNaERQZ3f5IIL6qP0UhrpV0m9ZAzZj80JnlgNODDKMURHVBt6hvRRQd+g
         9rthigqG63zcgKU7DTOqHkpzBzQpil+kSWRMqL6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mark Wielaard <mark@klomp.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/120] kbuild: fix duplicated flags in DEBUG_CFLAGS
Date:   Mon,  8 Feb 2021 16:00:39 +0100
Message-Id: <20210208145820.500780978@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 315da87c0f99a4741a639782d59dae44878199f5 ]

Sedat Dilek noticed duplicated flags in DEBUG_CFLAGS when building
deb-pkg with CONFIG_DEBUG_INFO. For example, 'make CC=clang bindeb-pkg'
reproduces the issue.

Kbuild recurses to the top Makefile for some targets such as package
builds.

With commit 121c5d08d53c ("kbuild: Only add -fno-var-tracking-assignments
for old GCC versions") applied, DEBUG_CFLAGS is now reset only when
CONFIG_CC_IS_GCC=y.

Fix it to reset DEBUG_CFLAGS all the time.

Fixes: 121c5d08d53c ("kbuild: Only add -fno-var-tracking-assignments for old GCC versions")
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Mark Wielaard <mark@klomp.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index bb3770be9779d..535696d39f452 100644
--- a/Makefile
+++ b/Makefile
@@ -812,10 +812,12 @@ KBUILD_CFLAGS	+= -ftrivial-auto-var-init=zero
 KBUILD_CFLAGS	+= -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
 endif
 
+DEBUG_CFLAGS	:=
+
 # Workaround for GCC versions < 5.0
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61801
 ifdef CONFIG_CC_IS_GCC
-DEBUG_CFLAGS	:= $(call cc-ifversion, -lt, 0500, $(call cc-option, -fno-var-tracking-assignments))
+DEBUG_CFLAGS	+= $(call cc-ifversion, -lt, 0500, $(call cc-option, -fno-var-tracking-assignments))
 endif
 
 ifdef CONFIG_DEBUG_INFO
-- 
2.27.0



