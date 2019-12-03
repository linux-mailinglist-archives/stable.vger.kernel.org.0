Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DF5111CC9
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfLCWrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbfLCWr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 226F720656;
        Tue,  3 Dec 2019 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413247;
        bh=rBaaCepDaC+PYJzZ8NE3MPbHgZYe5c/CjDWf7Ogf0ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScTxJy+FQ3M60vlYK5rbrIzijh36PDokeHP71wS9J+T6DYdUkszVe0dNhN+ydaBHB
         CBXyJ3KWPDD851TEtNMMhG4D/QTm1ENtipJ1bopsTs6i7Wu5Wn9tUYglYTK1dnt/PL
         pa1/5MuRNRexubm09Ptucbr9jQD9gPF3q0wkXmVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/321] ARM: dts: imx31: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:02 +0100
Message-Id: <20191203223430.075178975@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 013d37e4707e24c7b9bc3fc55aeda55ce9c2b262 ]

Boards based on imx31 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx31.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Tested-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx31-bug.dts  | 1 +
 arch/arm/boot/dts/imx31-lite.dts | 1 +
 arch/arm/boot/dts/imx31.dtsi     | 2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx31-bug.dts b/arch/arm/boot/dts/imx31-bug.dts
index 6ee4ff8e4e8f0..9eb960cc02cc5 100644
--- a/arch/arm/boot/dts/imx31-bug.dts
+++ b/arch/arm/boot/dts/imx31-bug.dts
@@ -17,6 +17,7 @@
 	compatible = "buglabs,imx31-bug", "fsl,imx31";
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x8000000>; /* 128M */
 	};
 };
diff --git a/arch/arm/boot/dts/imx31-lite.dts b/arch/arm/boot/dts/imx31-lite.dts
index db52ddccabc33..d17abdfb6330c 100644
--- a/arch/arm/boot/dts/imx31-lite.dts
+++ b/arch/arm/boot/dts/imx31-lite.dts
@@ -18,6 +18,7 @@
 	};
 
 	memory@80000000 {
+		device_type = "memory";
 		reg = <0x80000000 0x8000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx31.dtsi b/arch/arm/boot/dts/imx31.dtsi
index ca1419ca303c3..2fc64d2c7c88e 100644
--- a/arch/arm/boot/dts/imx31.dtsi
+++ b/arch/arm/boot/dts/imx31.dtsi
@@ -10,10 +10,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		gpio0 = &gpio1;
-- 
2.20.1



