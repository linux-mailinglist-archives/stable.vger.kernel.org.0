Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4703039A81F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFCRNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232681AbhFCRME (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C2D61424;
        Thu,  3 Jun 2021 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740198;
        bh=fe6+/LiFiMnPngT/JpTOFadQOWUmdRGhSDMYamPmmdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMOgrI5q2PLO1OPTu3m3a1q7k45le38J/sf/gdki3RLZG6YofRZjZAaJpTVTCmvVm
         EW8CdbxtAMUkz85QWaEN8kmQQdr9R1TKp09u92CNdkPZ2sM/dO/QlkIMrOic9e0KmL
         B6qAyhnKm1sRjVgDo8RffkkHdPJJh96/UGw0ZtXf/i211M1xf9DrZIOe/fyS1vs6P1
         b0AYJlYNQKyt6X8V2vzqsavMnBZvzMDOlU/zFAcWE+o+/p7aSfrjlabuV8Io2Cs/6K
         XRdfHrCX7y5Eba3nltxTIPHgoU1Q6pPVXh5ZGvktb4ShNB9S8Wi7AI4DvGw4+XiFpZ
         49wVYPPBEByrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 31/31] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
Date:   Thu,  3 Jun 2021 13:09:19 -0400
Message-Id: <20210603170919.3169112-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
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
index 1b4aafc1f6a2..9716a0484ecf 100644
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

