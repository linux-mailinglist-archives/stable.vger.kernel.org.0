Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE262B6272
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgKQN2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731400AbgKQN0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A16F2464E;
        Tue, 17 Nov 2020 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619562;
        bh=6Zp+YV6Z2BWDD9deiTge0AlKV+A0u0z1bSS6kiV9ATg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsGyAmIHedgNjKeKgdKPe50wA+zAzv29HAYK4ClQ8O9zA+UvCx34eOI+g0b3DygP5
         LKuiqaPyuvK3pgZh5z8d/IY/TVBJiBgscYtg4VlN8En2o4xqtBnWDt8HsD4xMCG9Pw
         MwYErDq0B2QqeKV22W+pun3XCYPkXWSWdpwYyGrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/151] riscv: Set text_offset correctly for M-Mode
Date:   Tue, 17 Nov 2020 14:05:11 +0100
Message-Id: <20201117122125.360974946@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>

[ Upstream commit 79605f1394261995c2b955c906a5a20fb27cdc84 ]

M-Mode Linux is loaded at the start of RAM, not 2MB later. Perhaps this
should be calculated based on PAGE_OFFSET somehow? Even better would be to
deprecate text_offset and instead introduce something absolute.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/head.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 72f89b7590dd6..344793159b97d 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -26,12 +26,17 @@ ENTRY(_start)
 	/* reserved */
 	.word 0
 	.balign 8
+#ifdef CONFIG_RISCV_M_MODE
+	/* Image load offset (0MB) from start of RAM for M-mode */
+	.dword 0
+#else
 #if __riscv_xlen == 64
 	/* Image load offset(2MB) from start of RAM */
 	.dword 0x200000
 #else
 	/* Image load offset(4MB) from start of RAM */
 	.dword 0x400000
+#endif
 #endif
 	/* Effective size of kernel image */
 	.dword _end - _start
-- 
2.27.0



