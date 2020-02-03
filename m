Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D49150C1E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgBCQdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730598AbgBCQdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:31 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977132051A;
        Mon,  3 Feb 2020 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747611;
        bh=PC4ZT9U2x9qg5fsi7hIoUtVwsFQ/+dxYmuyK9xgD0L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQQkQz9VCykK0/K6o0DP1e+kgZMaWiY3j3tbQFXiBN3nRwiVgXJ5mK+sHYd3CCIOg
         3ADyXGcxRY+VFFobiJY4fvt6zObiPAcNJXugp1PlqiNIeEqRm5XaSrDYUS++5sYAP3
         bRznhprp7E7w363+n2Ogy4ITtr5Rz0TsRXMtIBA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/70] net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
Date:   Mon,  3 Feb 2020 16:20:19 +0000
Message-Id: <20200203161921.809685891@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

[ Upstream commit 457bfc0a4bf531487ecc3cf82ec728a5e114fb1e ]

As the only 10G PHY interface type defined at the moment the code
was developed was XGMII, although the PHY interface mode used was
not XGMII, XGMII was used in the code to denote 10G. This patch
renames the 10G interface mode to remove the ambiguity.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 41c6fa200e746..e1901874c19f0 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -110,7 +110,7 @@ do {									\
 /* Interface Mode Register (IF_MODE) */
 
 #define IF_MODE_MASK		0x00000003 /* 30-31 Mask on i/f mode bits */
-#define IF_MODE_XGMII		0x00000000 /* 30-31 XGMII (10G) interface */
+#define IF_MODE_10G		0x00000000 /* 30-31 10G interface */
 #define IF_MODE_GMII		0x00000002 /* 30-31 GMII (1G) interface */
 #define IF_MODE_RGMII		0x00000004
 #define IF_MODE_RGMII_AUTO	0x00008000
@@ -440,7 +440,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	tmp = 0;
 	switch (phy_if) {
 	case PHY_INTERFACE_MODE_XGMII:
-		tmp |= IF_MODE_XGMII;
+		tmp |= IF_MODE_10G;
 		break;
 	default:
 		tmp |= IF_MODE_GMII;
-- 
2.20.1



