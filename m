Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AE410B920
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbfK0UuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbfK0UuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:50:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20EC21774;
        Wed, 27 Nov 2019 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887807;
        bh=pal9hfN4N0D5eIJxzhWWfFKR/tR1Zz4LVav7/9eRo0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8geMdfpwD+ue8EMM6c3rk6xfwbpM69KA6b938hvsVdC9UCeK4jTYEnd3m5musFJG
         icVhlhY+RpItRBa2D0XWIf/VgPC8YgAfLorjjg5N03pBmHkiAYH9UJw4u/ohgmj2fw
         2+vlXFRs0ajOk2ZFWfrT08Qfg0WFdIDjx4thXhYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 103/211] powerpc/xmon: Relax frame size for clang
Date:   Wed, 27 Nov 2019 21:30:36 +0100
Message-Id: <20191127203103.434216230@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 9c87156cce5a63735d1218f0096a65c50a7a32aa ]

When building with clang (8 trunk, 7.0 release) the frame size limit is
hit:

 arch/powerpc/xmon/xmon.c:452:12: warning: stack frame size of 2576
 bytes in function 'xmon_core' [-Wframe-larger-than=]

Some investigation by Naveen indicates this is due to clang saving the
addresses to printf format strings on the stack.

While this issue is investigated, bump up the frame size limit for xmon
when building with clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/252
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index 549e99e71112b..ac5ee067aa512 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -13,6 +13,12 @@ UBSAN_SANITIZE := n
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -mno-sched-epilog,,$(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS)))
 
+ifdef CONFIG_CC_IS_CLANG
+# clang stores addresses on the stack causing the frame size to blow
+# out. See https://github.com/ClangBuiltLinux/linux/issues/252
+KBUILD_CFLAGS += -Wframe-larger-than=4096
+endif
+
 ccflags-$(CONFIG_PPC64) := $(NO_MINIMAL_TOC)
 
 obj-y			+= xmon.o nonstdio.o spr_access.o
-- 
2.20.1



