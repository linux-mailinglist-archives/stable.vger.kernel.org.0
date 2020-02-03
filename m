Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F32150B5D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgBCQ07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbgBCQ06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:26:58 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410B22080C;
        Mon,  3 Feb 2020 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747217;
        bh=dIgn9BpgV/kckPUrTnXc0lNhAzQYi3gMrHXcc5KGI4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INzapQiZpuSqetS+d6Pf9XKi1SGPQyLfXFtGV9cyaVrEqimHtYdDwKVa0VN+63Eh2
         U74Gd1mOUwrfytGibGm75CSXz9cNXXRoXUUiXr8iERoH19C8HtPeG/IhvuK5qJvIFy
         YgzALU5gOc2RvIA9J3jbvOLsfQAyi/Bhb6opOiY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 61/68] net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
Date:   Mon,  3 Feb 2020 16:19:57 +0000
Message-Id: <20200203161914.935592886@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
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
index 21dd5579130e6..c30994a09a7c2 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -109,7 +109,7 @@ do {									\
 /* Interface Mode Register (IF_MODE) */
 
 #define IF_MODE_MASK		0x00000003 /* 30-31 Mask on i/f mode bits */
-#define IF_MODE_XGMII		0x00000000 /* 30-31 XGMII (10G) interface */
+#define IF_MODE_10G		0x00000000 /* 30-31 10G interface */
 #define IF_MODE_GMII		0x00000002 /* 30-31 GMII (1G) interface */
 #define IF_MODE_RGMII		0x00000004
 #define IF_MODE_RGMII_AUTO	0x00008000
@@ -438,7 +438,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
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



