Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1846739A76B
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhFCRLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232151AbhFCRLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3AC61406;
        Thu,  3 Jun 2021 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740156;
        bh=9WxW4QTmRWs0rCdYI7UOG3Yi5cPw0dSS6Du7NcDGoz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2dbQBZJ30QChEbkwPkWTBEkU/hlARZ8+xJFeSh0iz0z76jmC1ZoZB6cn1u5XJvua
         yclVdbqyar5jdCRO0jVNEVFzGLCpQ/0Q/OngMR+IakJdWrnfe+agZ3eKlUaeZM/T3Y
         RON+o2hm7Z6SYuutZs3S0962yfcs4lKbK7sCjNSKlzfBRYf5vCKLX22jT2J305klXi
         trSKUtSK5BAWJqxnMsQ2NWExZdSs2wyPcjJ2xR0HaXEa2oNdKcdvcS/k+84Ez/AVSj
         seslVwXxauBtCwTsrNf5+yTu0vLeqm2GOpAWjndfdRFbmybytwnuOHwVkBGi4axRCZ
         6+DYOAjbnKlkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 38/39] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Date:   Thu,  3 Jun 2021 13:08:28 -0400
Message-Id: <20210603170829.3168708-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -371,7 +371,23 @@ sdhc@114000 {
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

