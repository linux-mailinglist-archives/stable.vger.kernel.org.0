Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6B44638DC
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbhK3PGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbhK3O5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6727CC0698C2;
        Tue, 30 Nov 2021 06:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E85CB81A53;
        Tue, 30 Nov 2021 14:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032A8C53FCF;
        Tue, 30 Nov 2021 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283864;
        bh=vE312v6223elY83DNKZK/9DVrz8d8dbSesJ+1sYfWeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCWtlgOyC8f4aMro4j4pFzZ77Ynz2D4YPgxXZx4dXhVyCde9LfEru/tlnthmLGPSt
         L+rkKBzZeXMwtsrLTT3EOucKncWLVFaxNmpT5Il5dbEV7q6tX2fPaPAcgVZ3UU9o08
         Jm3NPBsEjJThOaY6zUmDgPS7bl0MOmwEnnObvJ/lUm5EmaGGMUXODlsRm6SAd02oKB
         s0zql3sjATqtGrALK7feqgv0L/BLSTUZwGDR8cW/VbBGwvy937RgswbptBTwEP8KkQ
         VeIIvoQ2TTWWzS4ImA9ddWkBdmhoad98X8rMCWv7i8hDe8rDSROIAHta/uF4qZAZQo
         wxvCTcO9+zHWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/43] parisc: Provide an extru_safe() macro to extract unsigned bits
Date:   Tue, 30 Nov 2021 09:49:54 -0500
Message-Id: <20211130145022.945517-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index a39250cb7dfcf..0c95030017e8f 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -135,6 +135,17 @@
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

