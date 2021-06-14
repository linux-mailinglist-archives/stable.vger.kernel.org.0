Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2263A62E0
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhFNLF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233958AbhFNLDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7AA6191B;
        Mon, 14 Jun 2021 10:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667468;
        bh=oOZfVwqe4Q2H/WNxZodKKGnp1gY45NtnBA8IR4gLn8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWNoL/fI+nnYoZ9vXeOSJ/YNMSOR6QajuCc8RtFN1rnwvZkKnFI/7EI4SQ4QB3N1x
         ll9aXHvoZR8AzKmqzWO1XTweMLpLQ5f5mj+vuQseHnl+gKgNgB9d9JnoCywkw/HuPk
         bPh6Qa0Q27nIhPonsi+aB98ZBDnach+0QHI3zCLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/131] powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
Date:   Mon, 14 Jun 2021 12:26:41 +0200
Message-Id: <20210614102654.381052221@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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



