Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB86DF61
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfGSEBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbfGSEBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CA321897;
        Fri, 19 Jul 2019 04:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508911;
        bh=K0GG2IuOpfdaRilolTBGAevqgH7EWAGqWYnh0hI0YHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qD7XomS3y+lkehS9jDSpKAIf0EfAs482F1D+HjFk80RuStRy13uts98B6uqZbLUMX
         8AXjmZ86n+Bh8EfwxWVixNcY7+vGjE4UZvdkV9nHWtA8lszuofOpeNFoA/1fTuvICw
         7taqovTh9LM2ulQTPWHHHFXaCzBIHDBnPRIPk+VE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 154/171] sh: prevent warnings when using iounmap
Date:   Thu, 18 Jul 2019 23:56:25 -0400
Message-Id: <20190719035643.14300-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

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
index c28e37a344ad..ac0561960c52 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -369,7 +369,11 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 
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

