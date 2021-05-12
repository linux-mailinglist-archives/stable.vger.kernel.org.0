Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E6437C9BF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhELQVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239992AbhELQQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB99461C7F;
        Wed, 12 May 2021 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834190;
        bh=pao1q8aqRRg+UiIHzMhFmfPeOr0hwXsgyP+d7wZLbIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzLzCnPvWWNs89+0zu5338wRlR214qsRVyaamkGRHyElfihTSznuuhNHb+O7TsywQ
         /73HY4FRK8RxCHd2qCeo7DnmnTFHw4eozP7IruHrcxlzzAzYAqQ4Pbx3UwPVlz6aVX
         WubH9kEBMcwcXVxet8dG/Oe0TxcvF6JkoGxFnC/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 409/601] powerpc/prom: Mark identical_pvr_fixup as __init
Date:   Wed, 12 May 2021 16:48:06 +0200
Message-Id: <20210512144841.301183446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 1ef1dd9c7ed27b080445e1576e8a05957e0e4dfc ]

If identical_pvr_fixup() is not inlined, there are two modpost warnings:

WARNING: modpost: vmlinux.o(.text+0x54e8): Section mismatch in reference
from the function identical_pvr_fixup() to the function
.init.text:of_get_flat_dt_prop()
The function identical_pvr_fixup() references
the function __init of_get_flat_dt_prop().
This is often because identical_pvr_fixup lacks a __init
annotation or the annotation of of_get_flat_dt_prop is wrong.

WARNING: modpost: vmlinux.o(.text+0x551c): Section mismatch in reference
from the function identical_pvr_fixup() to the function
.init.text:identify_cpu()
The function identical_pvr_fixup() references
the function __init identify_cpu().
This is often because identical_pvr_fixup lacks a __init
annotation or the annotation of identify_cpu is wrong.

identical_pvr_fixup() calls two functions marked as __init and is only
called by a function marked as __init so it should be marked as __init
as well. At the same time, remove the inline keywork as it is not
necessary to inline this function. The compiler is still free to do so
if it feels it is worthwhile since commit 889b3c1245de ("compiler:
remove CONFIG_OPTIMIZE_INLINING entirely").

Fixes: 14b3d926a22b ("[POWERPC] 4xx: update 440EP(x)/440GR(x) identical PVR issue workaround")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1316
Link: https://lore.kernel.org/r/20210302200829.2680663-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index ae3c41730367..a7ebaa208416 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -267,7 +267,7 @@ static struct feature_property {
 };
 
 #if defined(CONFIG_44x) && defined(CONFIG_PPC_FPU)
-static inline void identical_pvr_fixup(unsigned long node)
+static __init void identical_pvr_fixup(unsigned long node)
 {
 	unsigned int pvr;
 	const char *model = of_get_flat_dt_prop(node, "model", NULL);
-- 
2.30.2



