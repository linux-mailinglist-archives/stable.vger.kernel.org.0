Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E394638B1
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbhK3PFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244274AbhK3PAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:00:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29443C08E8AB;
        Tue, 30 Nov 2021 06:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC3EB81A46;
        Tue, 30 Nov 2021 14:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73BDC53FC1;
        Tue, 30 Nov 2021 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283977;
        bh=ntHuwoODWvSFgSKfMhijI4fsVG4ii0OIJc9wZ2LY3s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsu3kp9biAz2TkLhaCsCTmNRdx5WaIaU3DoKuLmnx18QGRNlREBbUj/FCwHMf8KEM
         B0QIrzAxLbaTr+3x/NFjFuBr1BA7WTnX0qLVEb6BXUxdwLf9TiE1VDUhrPkbR+Fdp/
         MyHios5VbChLLt9EJwdKtrdmc/vBKI72/yxQ5wBwDzf5MDs3sH1oVKKuTCFzOZLyuH
         NpAcT5kJ1fsHf4PJZ690zu/ZJZW4vHWWj3lv1g+NMybDErjscJ8YCprhnvHggOgj8U
         RMTXZpkxOhRrTyqfP1ogV5LeAqqT+1F3B42KDrJFS+7YF5lEA067krlSHIa+f+mJDt
         reII/S9aokaig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/17] parisc: Provide an extru_safe() macro to extract unsigned bits
Date:   Tue, 30 Nov 2021 09:52:31 -0500
Message-Id: <20211130145243.946407-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 6f30fa5bdaedf..b32d212c5e6eb 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -155,6 +155,17 @@
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

