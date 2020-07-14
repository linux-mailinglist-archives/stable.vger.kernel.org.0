Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0C21FA30
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgGNSuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729728AbgGNSuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EADE208C3;
        Tue, 14 Jul 2020 18:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752621;
        bh=tdynT2JV7a0+gxRc6IFSgh5pZhbM6pNqj5JJ3tzCOCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b873GxQdZ0zJBe44dzwG6bDftHftplueN2/cx+oJ2xUbpB1C75NMqh2JRSVY1TTzv
         tdvlqCk3D2k9pCWRTT9KpgWurAqUftdI79GCLvdG1Wd6i6i3C43BU7a//AMd1Kjh9J
         Djny2vjiwCxJ0sI5eFJeU/Nx/9hHhXwFkHvME/Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/109] net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy
Date:   Tue, 14 Jul 2020 20:43:20 +0200
Message-Id: <20200714184106.347160297@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 ]

The older SoCs like Armada XP support a 2500BaseX mode in the datasheets
referred to as DR-SGMII (Double rated SGMII) or HS-SGMII (High Speed
SGMII). This is an upclocked 1000BaseX mode, thus
PHY_INTERFACE_MODE_2500BASEX is the appropriate mode define for it.
adding support for it merely means writing the correct magic value into
the MVNETA_SERDES_CFG register.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b0599b205b36e..9799253948281 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -108,6 +108,7 @@
 #define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
 #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
+#define      MVNETA_HSGMII_SERDES_PROTO		 0x1107
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -3199,6 +3200,11 @@ static int mvneta_config_interface(struct mvneta_port *pp,
 			mvreg_write(pp, MVNETA_SERDES_CFG,
 				    MVNETA_SGMII_SERDES_PROTO);
 			break;
+
+		case PHY_INTERFACE_MODE_2500BASEX:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_HSGMII_SERDES_PROTO);
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.25.1



