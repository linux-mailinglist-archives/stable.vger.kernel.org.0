Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD9C463742
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhK3Owg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242565AbhK3Ovr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BA41B81A1D;
        Tue, 30 Nov 2021 14:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023CFC53FC7;
        Tue, 30 Nov 2021 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283705;
        bh=vE312v6223elY83DNKZK/9DVrz8d8dbSesJ+1sYfWeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJZwpcrscb7fh+/0COiCQzl8XW/2vU4CsS3uyo76iCpLluP/ZYMICbehEdH0dQWM5
         5ByUhUNopw0Y4S08H/W1jJ3hs0Q8S7zm6Hpj2JyHXUzMoIHAaUc6Afsx3tbOg41puM
         tBpwWqcAxhsOp0qBeADO9gI5fqaCGCZRsmrW/l9mBwPEoAoKGaPXB60HSh5E8cZYJj
         ffCz5ixpVFrIhK+JvshwbjyiLxHqLKS2nrg1Yl09ADl/yCpeyvjQXHv0GW+NGxPr5D
         xKgwl+IKjlAeVRZGZG6Rv6zzByUKxCphKv12ZoF7b83fadmr4j/Q/Fn4YWAtd+kGHE
         3ELV3+4tf85fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/68] parisc: Provide an extru_safe() macro to extract unsigned bits
Date:   Tue, 30 Nov 2021 09:46:23 -0500
Message-Id: <20211130144707.944580-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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

