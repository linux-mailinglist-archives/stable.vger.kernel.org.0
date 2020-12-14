Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92162D9DAB
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440449AbgLNR2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440427AbgLNR2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:28:45 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?N=C3=A9meth=20M=C3=A1rton?= <nm127@freemail.hu>,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Scott Wood <oss@buserror.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/36] powerpc: Drop -me200 addition to build flags
Date:   Mon, 14 Dec 2020 18:27:51 +0100
Message-Id: <20201214172543.675253980@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit e02152ba2810f7c88cb54e71cda096268dfa9241 ]

Currently a build with CONFIG_E200=y will fail with:

  Error: invalid switch -me200
  Error: unrecognized option -me200

Upstream binutils has never supported an -me200 option. Presumably it
was supported at some point by either a fork or Freescale internal
binutils.

We can't support code that we can't even build test, so drop the
addition of -me200 to the build flags, so we can at least build with
CONFIG_E200=y.

Reported-by: Németh Márton <nm127@freemail.hu>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Scott Wood <oss@buserror.net>
Link: https://lore.kernel.org/r/20201116120913.165317-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 37ac731a556b8..9f73fb6b1cc91 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -250,7 +250,6 @@ KBUILD_CFLAGS		+= $(call cc-option,-mno-string)
 
 cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
 cpu-as-$(CONFIG_ALTIVEC)	+= $(call as-option,-Wa$(comma)-maltivec)
-cpu-as-$(CONFIG_E200)		+= -Wa,-me200
 cpu-as-$(CONFIG_E500)		+= -Wa,-me500
 
 # When using '-many -mpower4' gas will first try and find a matching power4
-- 
2.27.0



