Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA054993B2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386130AbiAXUfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54866 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384832AbiAXUai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF73614E2;
        Mon, 24 Jan 2022 20:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7502BC340E5;
        Mon, 24 Jan 2022 20:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056236;
        bh=mZ3TmLwV+XX3SCnqWrn6HwwnB01kskCiDLYtCvbS3mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9YtnGrElkQ8nw/Hd0OrHxsMIDzGrBf/ZAZbqryCBJaqOD/mW6HFkqx8yj2s9AEGg
         najxm0Xx0Yv+Gy31PJpT+P8SW74VSYqvtssYAgUsMXCdDktX3BRmaTFV5K++M4nomO
         XcnvNX+voqlAUyihNolsaEn+GOphGgImgk84/Kd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/846] mips: add SYS_HAS_CPU_MIPS64_R5 config for MIPS Release 5 support
Date:   Mon, 24 Jan 2022 19:38:53 +0100
Message-Id: <20220124184115.331045317@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 23654ccdbfb12..0200ebb7a0144 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1993,6 +1993,10 @@ config SYS_HAS_CPU_MIPS64_R1
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



