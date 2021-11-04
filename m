Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8065E4454AA
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhKDOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231551AbhKDOQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB47611C3;
        Thu,  4 Nov 2021 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035243;
        bh=51239L7RY6fg4D0wm0osJw4D3Ii2tDhhoW4QhjjEqko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxKSGx+AaLibCn+7hKg3EMs+KFwszKTgfgqr/7eWSJCNyQInrcQxY9Q5uPr8ilHgc
         9cRsFH/GyYnpSFvaRhrAoZEYeKJ0E7DUpuOdgaKvBaC+zIzwGCNi3p1dX6u8MMzjEE
         IwY5ZjNPpZA5KwmyluN1r3UwZiALCMgb67e9l27k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Adam Ford <aford173@gmail.com>
Subject: [PATCH 5.15 06/12] Revert "soc: imx: gpcv2: move reset assert after requesting domain power up"
Date:   Thu,  4 Nov 2021 15:12:32 +0100
Message-Id: <20211104141159.760087002@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 2b2f106eb55276a60a89ac27a52d0d738b57a546 upstream.

This reverts commit a77ebdd9f553. It turns out that the VPU domain has no
different requirements, even though the downstream ATF implementation seems
to suggest otherwise. Powering on the domain with the reset asserted works
fine. As the changed sequence has caused sporadic issues with the GPU
domains, just revert the change to go back to the working sequence.

Cc: <stable@vger.kernel.org> # 5.14
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx8mm-beacon
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/imx/gpcv2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -244,6 +244,8 @@ static int imx_pgc_power_up(struct gener
 		goto out_regulator_disable;
 	}
 
+	reset_control_assert(domain->reset);
+
 	if (domain->bits.pxx) {
 		/* request the domain to power up */
 		regmap_update_bits(domain->regmap, GPC_PU_PGC_SW_PUP_REQ,
@@ -266,8 +268,6 @@ static int imx_pgc_power_up(struct gener
 				  GPC_PGC_CTRL_PCR);
 	}
 
-	reset_control_assert(domain->reset);
-
 	/* delay for reset to propagate */
 	udelay(5);
 


