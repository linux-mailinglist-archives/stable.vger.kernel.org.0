Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4301439A8F8
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhFCRTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhFCRRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:17:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7CB600D3;
        Thu,  3 Jun 2021 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740294;
        bh=LlFPovvGoLlrINgljP3dDSQqB1UiS3h0/RIhUuNscvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfnKtAYdGnlw8DdvkQyO2J0gpLT+BKr2ijTjz3eiSl8cBXnbruRX2KrNuEU3ain5k
         pFyu6XC/YNttNwWVuerib7pxCBowASNYyHLH0TAQSfRh9iePzlGvPvUiog02Zv+npe
         FsQXttM2MeQRsFuAyGA/sfceRq/V/uk3Ks0bZEt1Vpz/apwaCeZhOP4uM3euPTuWNv
         slTKwdwIKNsKYCYy0Xe6Ydjsn65Qsk8N4C8DiJC4yQyN8xjMiIy/KeG9x1+O8fU8Cy
         h0NcrbCRiQahblkygGIhGvqv9NMaRxRDUUBCRQzgUiK2noWeu6fdzpwuX26luyNiGM
         E9si/ioLTDUuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 15/15] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
Date:   Thu,  3 Jun 2021 13:11:14 -0400
Message-Id: <20210603171114.3170086-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 19ae697a1e4edf1d755b413e3aa38da65e2db23b ]

The i2c controllers on the P1010 have an erratum where the documented
scheme for i2c bus recovery will not work (A-004447). A different
mechanism is needed which is documented in the P1010 Chip Errata Rev L.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi b/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
index af12ead88c5f..404f570ebe23 100644
--- a/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
@@ -122,7 +122,15 @@ memory-controller@2000 {
 	};
 
 /include/ "pq3-i2c-0.dtsi"
+	i2c@3000 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "pq3-i2c-1.dtsi"
+	i2c@3100 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "pq3-duart-0.dtsi"
 /include/ "pq3-espi-0.dtsi"
 	spi0: spi@7000 {
-- 
2.30.2

