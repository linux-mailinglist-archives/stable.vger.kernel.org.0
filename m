Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57CA49953B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392466AbiAXUvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390180AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0351C0617BE;
        Mon, 24 Jan 2022 11:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9095461012;
        Mon, 24 Jan 2022 19:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D7AC340E5;
        Mon, 24 Jan 2022 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054087;
        bh=xQDm7FZPXcXZlrZTnKkz6kxd0O0POjHE1l9GdUOFf8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsHhuGoZqcsWkJRtw6P+BOIGo4cCJSHuxwLx/npvS4z2xH02Jt1OJ+fZQ853VXALa
         OBx3MxDFdVL9KAFODtW2MXjGpq9BM+fvzE/maNLN0C5khxFI2JLg6jklVTjNpVgoGr
         F1dkJQ6UV8EzRyNUnAcJzJ5L6UvJbLhvL4uvVzR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/563] mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support
Date:   Mon, 24 Jan 2022 19:40:39 +0100
Message-Id: <20220124184033.921285032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit fd4eb90b164442cb1e9909f7845e12a0835ac699 ]

Commit ab7c01fdc3cf ("mips: Add MIPS Release 5 support") adds the two
configs CPU_MIPS32_R5 and CPU_MIPS64_R5, which depend on the corresponding
SYS_HAS_CPU_MIPS32_R5 and SYS_HAS_CPU_MIPS64_R5, respectively.

The config SYS_HAS_CPU_MIPS32_R5 was already introduced with commit
c5b367835cfc ("MIPS: Add support for XPA."); the config
SYS_HAS_CPU_MIPS64_R5, however, was never introduced.

Hence, ./scripts/checkkconfigsymbols.py warns:

  SYS_HAS_CPU_MIPS64_R5
  Referencing files: arch/mips/Kconfig, arch/mips/include/asm/cpu-type.h

Add the definition for config SYS_HAS_CPU_MIPS64_R5 under the assumption
that SYS_HAS_CPU_MIPS64_R5 follows the same pattern as the existing
SYS_HAS_CPU_MIPS32_R5 and SYS_HAS_CPU_MIPS64_R6.

Fixes: ab7c01fdc3cf ("mips: Add MIPS Release 5 support")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 23d756fe0fd6c..db8fe5d7a2377 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1985,6 +1985,10 @@ config SYS_HAS_CPU_MIPS64_R1
 config SYS_HAS_CPU_MIPS64_R2
 	bool
 
+config SYS_HAS_CPU_MIPS64_R5
+	bool
+	select ARCH_HAS_SYNC_DMA_FOR_CPU if DMA_NONCOHERENT
+
 config SYS_HAS_CPU_MIPS64_R6
 	bool
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if DMA_NONCOHERENT
-- 
2.34.1



