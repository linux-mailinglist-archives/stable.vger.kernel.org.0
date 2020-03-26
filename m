Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1918194D33
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCZXYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgCZXYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:24:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7926820663;
        Thu, 26 Mar 2020 23:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585265046;
        bh=VfplG4asbBOJ9obO1kL+1KRmnwnGfmgoalGJBfSqDbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1GU7a+dRaEuLRMSBNrsoAtAWTCYvKbxY3SH5x92VBqq/7fk/SH5g8A0VzySkyCH4
         +xtD9ku2PRTN5+ymyR0VncUgde/wCH0MM4xzYtJHBJ0lJpmFPjohO+OsNSXW9tcxiT
         wqfL1wdmk/47d0RhFXjI7+Mf2lA9cuodDG5d4hkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        George Spelvin <lkml@sdf.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 07/28] int128: fix __uint128_t compiler test in Kconfig
Date:   Thu, 26 Mar 2020 19:23:36 -0400
Message-Id: <20200326232357.7516-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326232357.7516-1-sashal@kernel.org>
References: <20200326232357.7516-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3a7c733165a4799fa1beb262fe244bfbcdd1c163 ]

The support for __uint128_t is dependent on the target bit size.

GCC that defaults to the 32-bit can still build the 64-bit kernel
with -m64 flag passed.

However, $(cc-option,-D__SIZEOF_INT128__=0) is evaluated against the
default machine bit, which may not match to the kernel it is building.

Theoretically, this could be evaluated separately for 64BIT/32BIT.

  config CC_HAS_INT128
          bool
          default !$(cc-option,$(m64-flag) -D__SIZEOF_INT128__=0) if 64BIT
          default !$(cc-option,$(m32-flag) -D__SIZEOF_INT128__=0)

I simplified it more because the 32-bit compiler is unlikely to support
__uint128_t.

Fixes: c12d3362a74b ("int128: move __uint128_t compiler test to Kconfig")
Reported-by: George Spelvin <lkml@sdf.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: George Spelvin <lkml@sdf.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 47d40f3990005..74297c392dd49 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -767,8 +767,7 @@ config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	bool
 
 config CC_HAS_INT128
-	def_bool y
-	depends on !$(cc-option,-D__SIZEOF_INT128__=0)
+	def_bool !$(cc-option,$(m64-flag) -D__SIZEOF_INT128__=0) && 64BIT
 
 #
 # For architectures that know their GCC __int128 support is sound
-- 
2.20.1

