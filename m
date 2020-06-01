Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980351EA91F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgFAR6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgFAR6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B002420776;
        Mon,  1 Jun 2020 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034302;
        bh=sndQWg3R5DaAv3cGcLylgkaOjHQwf9bj1vLnR95t198=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fh5ArfV0/zvRZz897FPy/B1KzsBWFlcOjvGlJ8NeHwP1zPgAwV+ok/w9xrAPUx+xv
         m8xZwnHLLgvB46/10gfYbsV/8Ghv5WOcVzrfizqDKvQJhCHIuDoudlB05P3S2nF9sm
         FWOXWSkUethufbXrfZQmAVFZcIsmLYEffPi4tqE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Romain Perier <romain.perier@collabora.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 31/61] ARM: dts: imx: Correct B850v3 clock assignment
Date:   Mon,  1 Jun 2020 19:53:38 +0200
Message-Id: <20200601174017.555295599@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martyn Welch <martyn.welch@collabora.co.uk>

[ Upstream commit 1d0c7bb20c083a6e810d2142545b5606f8131080 ]

The IPU that drives HDMI must have its pre_sel set to pll2_pfd_396m
to avoid stepping on the LVDS output's toes, as the PLL can't be clocked
to the pixel clock and to the LVDS serial clock (3.5*pixel clock) at the
same time.

As we are using ipu1_di0 and ipu2_di0, ensure both are switched to
to pll2_pfd2_396m to avoid issues. The LDB driver will switch the
required IPU to ldb_di1 when it uses it to drive LVDS.

Signed-off-by: Martyn Welch <martyn.welch@collabora.co.uk>
Signed-off-by: Romain Perier <romain.perier@collabora.com>
Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-b850v3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6q-b850v3.dts b/arch/arm/boot/dts/imx6q-b850v3.dts
index 167f7446722a..e5e9a16155d9 100644
--- a/arch/arm/boot/dts/imx6q-b850v3.dts
+++ b/arch/arm/boot/dts/imx6q-b850v3.dts
@@ -57,7 +57,7 @@
 	assigned-clocks = <&clks IMX6QDL_CLK_LDB_DI0_SEL>,
 			  <&clks IMX6QDL_CLK_LDB_DI1_SEL>,
 			  <&clks IMX6QDL_CLK_IPU1_DI0_PRE_SEL>,
-			  <&clks IMX6QDL_CLK_IPU1_DI1_PRE_SEL>;
+			  <&clks IMX6QDL_CLK_IPU2_DI0_PRE_SEL>;
 	assigned-clock-parents = <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
 				 <&clks IMX6QDL_CLK_PLL5_VIDEO_DIV>,
 				 <&clks IMX6QDL_CLK_PLL2_PFD2_396M>,
-- 
2.25.1



