Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26D549A309
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366090AbiAXXwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844210AbiAXXII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:08:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB473C09F49F;
        Mon, 24 Jan 2022 13:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A079B81243;
        Mon, 24 Jan 2022 21:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C26C340E5;
        Mon, 24 Jan 2022 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059054;
        bh=TeYp5QSifAzy2E8GygoVq7w2IL6PghiUOAK0zkgnnm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAgi0R2nI4efGaC99IXeg+Mw8j0t7qPkEwPeRI/YLf2Kz3a+sDsoeakCV/8TSh/bo
         XpC8AP5Z85M7YNKqkEPsk3l1l4lcqfpqXLnnfJcASCN5uflEwJokVumlN3pKlhMEz3
         XLI9W5whvSBT9GQ5DG6fExu/cLpqMBC5mhlXPNy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0490/1039] mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support
Date:   Mon, 24 Jan 2022 19:37:59 +0100
Message-Id: <20220124184141.736245824@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 0215dc1529e9a..91ce1c57af005 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1907,6 +1907,10 @@ config SYS_HAS_CPU_MIPS64_R1
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



