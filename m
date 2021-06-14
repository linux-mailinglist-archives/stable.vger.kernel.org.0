Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1A3A6397
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhFNLPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234940AbhFNLMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F40C61457;
        Mon, 14 Jun 2021 10:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667705;
        bh=J7r/lrRoLtgpXhPKTHPUodPNJJKZXvNW2z4QxIPjKlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTtLLaPnLfu3GUsdlgNPtqHQy4Fc+YI3HA5Zh4aUoykGTnFVz1gUhs2N50FTWgGP2
         08dZSnJwXIRTxuMmrn4HqMJS8gDDKHCa8mjVCEVH4o6Eyh7vWgLvrkzA+jEAFsBjDR
         1QEudsWDQJiV0YWq796P1npvnAyoKH36SJX2RWxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 043/173] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Date:   Mon, 14 Jun 2021 12:26:15 +0200
Message-Id: <20210614102659.597453984@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 7adc7b225cddcfd0f346d10144fd7a3d3d9f9ea7 ]

The i2c controllers on the P2040/P2041 have an erratum where the
documented scheme for i2c bus recovery will not work (A-004447). A
different mechanism is needed which is documented in the P2040 Chip
Errata Rev Q (latest available at the time of writing).

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
index 872e4485dc3f..ddc018d42252 100644
--- a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
@@ -371,7 +371,23 @@
 	};
 
 /include/ "qoriq-i2c-0.dtsi"
+	i2c@118000 {
+		fsl,i2c-erratum-a004447;
+	};
+
+	i2c@118100 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "qoriq-i2c-1.dtsi"
+	i2c@119000 {
+		fsl,i2c-erratum-a004447;
+	};
+
+	i2c@119100 {
+		fsl,i2c-erratum-a004447;
+	};
+
 /include/ "qoriq-duart-0.dtsi"
 /include/ "qoriq-duart-1.dtsi"
 /include/ "qoriq-gpio-0.dtsi"
-- 
2.30.2



