Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD47345C439
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351814AbhKXNqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343711AbhKXNor (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C706330E;
        Wed, 24 Nov 2021 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758799;
        bh=H1gsNci/UOVbT5g2XWATohYVD9ANo/pEuVcBnvx+Q4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUC21TbbSf15lhHMFe7qfaZB7lZy6uvC1ppebclVMBuLNauR6cu6V9ecG1JELHRib
         1BCBJk9BnVIijJ83kHUrT3oL/TS+RyU4E9pEgf0omOcjkh+efajmZYUdIR7ez1L3E7
         GkQ5pCD8taynDEpBbz3SGXSLiX08kOQdzsCWvttc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <kuldeep.singh@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/279] arm64: dts: ls1012a: Add serial alias for ls1012a-rdb
Date:   Wed, 24 Nov 2021 12:55:20 +0100
Message-Id: <20211124115719.885684567@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



