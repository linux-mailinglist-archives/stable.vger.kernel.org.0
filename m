Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8994638B8
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbhK3PFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244527AbhK3PCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:02:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6D4C0619EF;
        Tue, 30 Nov 2021 06:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E59E3CE1A7B;
        Tue, 30 Nov 2021 14:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6B4C53FC7;
        Tue, 30 Nov 2021 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284006;
        bh=EGDJvL6BOLQxfNAUYSF7urXaPeK+GMK9kP0lBV4i+94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpVyqqotZOEks+V3cSeUBzDdKBrSxc0u8EubRe1abWPV9wiv+07sozpcRTT/3frQW
         i/+vfslYu93c/voqbe7JZI9pzRMKCzaVQ2IjptN6QRXAwTMsNmsKaqYdYA9IEzOhfp
         K3TbzTPYKIZCWjBnpek6TNG1tpmCsWLJcerCqeot3t90rBqfAcQzavOrFeIjhknAk3
         xQCBItNhA7+/GFnvtsV9dC+4T1/JLCJmRXk8nTEduWKifFSeUbMgWdmEuVr+8LqugQ
         hzXjE3jEsmInkxhUm0HFRQTMBOUhjnk02GqHg8J2maHwaCBuyrjOWQO1/F5/qzygGy
         mCwk4TbHM304g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/14] parisc: Provide an extru_safe() macro to extract unsigned bits
Date:   Tue, 30 Nov 2021 09:53:06 -0500
Message-Id: <20211130145317.946676-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
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
index eb83d65153b83..2272cbeb65f22 100644
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

