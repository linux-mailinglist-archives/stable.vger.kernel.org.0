Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2E4406281
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhIJApc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhIJAVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35E16611BD;
        Fri, 10 Sep 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233208;
        bh=RJdQ3nWsLAttBVJlilmncsfi80Cb5z8YuY9PlJ87iI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McWyW0V8e70uG/isVHZlG7NPW1XwxjM3nOPZ7vwE6faAm9ah2hWGE5WEsyV81DHjM
         wepU/j5kYWGR1YYlhopzi9N4aYjDwA3URax0DKQSfFZdC2XwbIDnyDIuEgwTysp83A
         s3AyxKhszauC921d3M+Jth2tM8Ke4v85C3iL8+Ks4Bi3foSKOABTkkXIcQWB4BDHYw
         Y1huf6pVT4TT4IDxKsprt4/hwfHDKQVLjtz7arnz0SjUp5ucmq1fhqlI0FhQSLT86e
         DFATT/OICYaKVYA8L1ByR1nfMU2Jwr1g4iU9hu5q7pEtokFPvw8wEbA44+VIOIFBBs
         FiAlZV1y/8OYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 77/88] x86/build/vdso: fix missing FORCE for *.so build rule
Date:   Thu,  9 Sep 2021 20:18:09 -0400
Message-Id: <20210910001820.174272-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 55a6d00ed0c1b4d20d7966d00fda6848d776658d ]

Add FORCE so that if_changed can detect the command line change.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 05c4abc2fdfd..a2dddcc189f6 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -131,7 +131,7 @@ $(obj)/%-x32.o: $(obj)/%.o FORCE
 targets += vdsox32.lds $(vobjx32s-y)
 
 $(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
-$(obj)/%.so: $(obj)/%.so.dbg
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
 $(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
-- 
2.30.2

