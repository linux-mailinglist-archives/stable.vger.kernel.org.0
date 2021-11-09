Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3A44B5A4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbhKIWWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245704AbhKIWUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD21C61221;
        Tue,  9 Nov 2021 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496270;
        bh=H1gsNci/UOVbT5g2XWATohYVD9ANo/pEuVcBnvx+Q4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSON+se3Xo52aKiJBu8hQvgius8cOownuWFuS42pulPMe/Oa0IBdeqm6jnC/aLvlv
         ryQCuAvY8F988dZt8Q3SEGv0cyjw5ne8VGLVxOQCbxXKl6iVnP1NB8z3AyGXfC91es
         n1iIIw/UlKvc77y93SZe++zRaF+QQ6QptoN88Fi3HoGh5YfiN8q8Y2ov7qRrtWhhVL
         OekwwcIGkyTD9T48xVZSryfIk5YnxocQ0HyfJDOlzFJsp9untnRzOkAqZMFiv7H0gN
         DIoq4U4gSQPyG/qhfyyF7XkB4Hhj5sqP310tbcQIu693es1+dNCXIs/sTQ3i4nqUev
         CI1dFSWU//oUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuldeep Singh <kuldeep.singh@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 34/82] arm64: dts: ls1012a: Add serial alias for ls1012a-rdb
Date:   Tue,  9 Nov 2021 17:15:52 -0500
Message-Id: <20211109221641.1233217-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuldeep Singh <kuldeep.singh@nxp.com>

[ Upstream commit 7f31ae6e01da140e34d6513815253e811019f016 ]

U-boot atempts to read serial alias value for ls1012a-rdb but couldn't
do so as it is not initialised and thus, FDT_ERR_NOTFOUND error is
reported while booting linux.

Loading fdt from FIT Image at a0000000 ...
   Description:  ls1012ardb-dtb
     Type:         Flat Device Tree
     Data Start:   0xab111474
     Data Size:    11285 Bytes = 11 KiB
     Architecture: AArch64
     Load Address: 0x90000000
   Loading fdt from 0xab111474 to 0x90000000
   Booting using the fdt blob at 0x90000000
   Uncompressing Kernel Image
   Loading Device Tree to 000000008fffa000, end 000000008ffffc14 ... OK
WARNING: fdt_fixup_stdout: could not read serial0 alias: FDT_ERR_NOTFOUND
NOTICE:  RNG: INSTANTIATED

Starting kernel ...

Fix the above error by specifying serial value to duart.

Signed-off-by: Kuldeep Singh <kuldeep.singh@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts
index 79f155dedb2d0..e662677a6e28f 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts
@@ -15,6 +15,7 @@
 	compatible = "fsl,ls1012a-rdb", "fsl,ls1012a";
 
 	aliases {
+		serial0 = &duart0;
 		mmc0 = &esdhc0;
 		mmc1 = &esdhc1;
 	};
-- 
2.33.0

