Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F2D7F2EF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406037AbfHBJwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406031AbfHBJwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:52:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AABC206A2;
        Fri,  2 Aug 2019 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739553;
        bh=51dwQdeJ27vzn3osMTwYOUqm5QismICrmB7ZLxWYF00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0b4C7qBpjxTJhYQjqVwr3UekZUPz/ULaNbsxKDjuFqPECcJ3ZvLolupQXNB1ul+Wu
         EIyhNijXwHNd24yvXRuJHChwFDsIPxG+xl17ColP+vs8lD6o0UpQDQVDktq34g+QI1
         TwLOSM14lxn/eSM8qNGXzIvWb+DKJumJb7rS5Uh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 196/223] sh: prevent warnings when using iounmap
Date:   Fri,  2 Aug 2019 11:37:01 +0200
Message-Id: <20190802092249.948469172@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 733f0025f0fb43e382b84db0930ae502099b7e62 ]

When building drm/exynos for sh, as part of an allmodconfig build, the
following warning triggered:

  exynos7_drm_decon.c: In function `decon_remove':
  exynos7_drm_decon.c:769:24: warning: unused variable `ctx'
    struct decon_context *ctx = dev_get_drvdata(&pdev->dev);

The ctx variable is only used as argument to iounmap().

In sh - allmodconfig CONFIG_MMU is not defined
so it ended up in:

\#define __iounmap(addr)	do { } while (0)
\#define iounmap		__iounmap

Fix the warning by introducing a static inline function for iounmap.

This is similar to several other architectures.

Link: http://lkml.kernel.org/r/20190622114208.24427-1-sam@ravnborg.org
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/io.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 3280a6bfa503..b2592c3864ad 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -370,7 +370,11 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 
 #define ioremap_nocache	ioremap
 #define ioremap_uc	ioremap
-#define iounmap		__iounmap
+
+static inline void iounmap(void __iomem *addr)
+{
+	__iounmap(addr);
+}
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
-- 
2.20.1



