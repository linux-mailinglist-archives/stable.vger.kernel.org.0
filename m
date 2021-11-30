Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEE346387B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244004AbhK3O7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:59:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60770 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbhK3O5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68A12CE1A96;
        Tue, 30 Nov 2021 14:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFDAC53FCD;
        Tue, 30 Nov 2021 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284049;
        bh=78IueaJ5p7Q4E4tBko6RBeuq2uZ720BD9kLmFjYpDXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlGqLlFHaWAjsQA/bHYqLuCjLogC8K546xxR5Q5/rxjw1hJoxjIuUHBxHM29YAUqu
         EGMw1nAJThVpLnzOJNPJy3BiqQKJx9AR7niZlMoW9dS4BZNRVPtQFGu3tPSG6PTIDu
         7I6dCniu8XnaKCSgHLvdONgiso08kgvUwLwBjbjg2ra2xJaXFUWLXsO8o+K4yuyMYh
         8t7A6bBUfSqLhpC4Q/LnoeDGJCj1Cb3LU70aXk2k2zZYBqXaadKT8R94rhZEafT54t
         NLH3SE+5Axjhb4Mg601XmrvabsFtxZ5SelFLSax0m73eXc46tua1D7PbbW+lNwQcSA
         dYajo7Iz8uEBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/9] parisc: Provide an extru_safe() macro to extract unsigned bits
Date:   Tue, 30 Nov 2021 09:53:57 -0500
Message-Id: <20211130145402.947049-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 169d1a4a2adb2c246396c56aa2f9eec3868546f1 ]

The extru instruction leaves the most significant 32 bits of the
target register in an undefined state on PA 2.0 systems.
Provide a macro to safely use extru on 32- and 64-bit machines.

Suggested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/assembly.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/parisc/include/asm/assembly.h b/arch/parisc/include/asm/assembly.h
index b3069fd83468c..a6784745c571e 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -153,6 +153,17 @@
 	extrd,u \r, 63-(\sa), 64-(\sa), \t
 	.endm
 
+	/* Extract unsigned for 32- and 64-bit
+	 * The extru instruction leaves the most significant 32 bits of the
+	 * target register in an undefined state on PA 2.0 systems. */
+	.macro extru_safe r, p, len, t
+#ifdef CONFIG_64BIT
+	extrd,u	\r, 32+(\p), \len, \t
+#else
+	extru	\r, \p, \len, \t
+#endif
+	.endm
+
 	/* load 32-bit 'value' into 'reg' compensating for the ldil
 	 * sign-extension when running in wide mode.
 	 * WARNING!! neither 'value' nor 'reg' can be expressions
-- 
2.33.0

