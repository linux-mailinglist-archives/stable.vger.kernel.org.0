Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D023A61D4
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhFNKwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhFNKuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1734B6145F;
        Mon, 14 Jun 2021 10:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667111;
        bh=oOZfVwqe4Q2H/WNxZodKKGnp1gY45NtnBA8IR4gLn8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT0Vz6sBJpmJNY2RQ10ZlycJeJoKWgnMxWx1qrFUC3ZxCUU5loVf8qADR4uXAq0wX
         SSDbGwyH6WAxzXZplxs+SHr/BaFWdUHScjzQ9M5x7wE8Kbxec7Hmn08UA5tkzYdpn+
         KC6hfM8zKGfnZAYd4zdWZNjEsg5HjR5Jd1/rK7MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/84] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
Date:   Mon, 14 Jun 2021 12:27:10 +0200
Message-Id: <20210614102647.456764919@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -122,7 +122,15 @@
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



