Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A47939A834
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhFCROU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhFCRM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DF7361423;
        Thu,  3 Jun 2021 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740227;
        bh=DlRPQKg57hZnvopmZek5Qh2qaefReJ5UVZdEQVMp8F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY9RdR3W+Jro6z/0mVcttqNOgzgKhj5wwbggW3HDGzohrlgbmh72B12KnYY9qiYLx
         qhY6NYKWNvfPn73789ERF0qwav0kkU3p+diMYpHcrNKJmLqyPnSXf+sHPCEkL08F+J
         w+kePZqEkf845lmDZwCDBKUww0O6brWKcXQWuX3DKBauqYR3LOh3IumBoa7p2QDZZa
         oAjFE250xREDbf6TvpEhu/e30ooXLIrMO0RPGv9dX6BRwjR2g1Yh5KvyQhQz7QpIsY
         GSCelYZ/grJ6hQ9iSY28rwfnBa8Brb5oACLSguoRSYrdxytXHxgNUVzybRyEYLELQp
         myv/dF/Mg0qCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 22/23] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
Date:   Thu,  3 Jun 2021 13:09:58 -0400
Message-Id: <20210603170959.3169420-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index 51e975d7631a..8921f17fca42 100644
--- a/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
@@ -389,7 +389,23 @@ sdhc@114000 {
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

