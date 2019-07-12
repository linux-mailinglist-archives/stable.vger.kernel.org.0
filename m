Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1A66ECE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfGLMXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfGLMXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:23:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 280D4216B7;
        Fri, 12 Jul 2019 12:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934217;
        bh=KtfOMNDaztyScdx2qCq38qKTgBN/3xPrtu+fGdpSiNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UogXBr0H7J9yW6QlfZrFHnd2EUo/bn8z4ROU6ddX6RoMjLmUXy7/o8a+Oyxn1JWbJ
         MCUYnpqlptryjW2GwFKN8st2tcqx+ZFC0wHo0xDhzQmcEsFhfwvVpdQjCOouedyAYw
         UXncOOPF7ZuvQZHtmzND4XLt+anTrywG5Vawm/CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/91] bnx2x: Check if transceiver implements DDM before access
Date:   Fri, 12 Jul 2019 14:18:50 +0200
Message-Id: <20190712121624.133925772@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cf18cecca911c0db96b868072665347efe6df46f ]

Some transceivers may comply with SFF-8472 even though they do not
implement the Digital Diagnostic Monitoring (DDM) interface described in
the spec. The existence of such area is specified by the 6th bit of byte
92, set to 1 if implemented.

Currently, without checking this bit, bnx2x fails trying to read sfp
module's EEPROM with the follow message:

ethtool -m enP5p1s0f1
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it is assumed
to exist the DDM data.

This issue was noticed using a Mellanox Passive DAC PN 01FT738. The EEPROM
data was confirmed by Mellanox as correct and similar to other Passive
DACs from other manufacturers.

Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index a4a90b6cdb46..c428b0655c26 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -1581,7 +1581,8 @@ static int bnx2x_get_module_info(struct net_device *dev,
 	}
 
 	if (!sff8472_comp ||
-	    (diag_type & SFP_EEPROM_DIAG_ADDR_CHANGE_REQ)) {
+	    (diag_type & SFP_EEPROM_DIAG_ADDR_CHANGE_REQ) ||
+	    !(diag_type & SFP_EEPROM_DDM_IMPLEMENTED)) {
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 	} else {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
index b7d251108c19..7115f5025664 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h
@@ -62,6 +62,7 @@
 #define SFP_EEPROM_DIAG_TYPE_ADDR		0x5c
 #define SFP_EEPROM_DIAG_TYPE_SIZE		1
 #define SFP_EEPROM_DIAG_ADDR_CHANGE_REQ		(1<<2)
+#define SFP_EEPROM_DDM_IMPLEMENTED		(1<<6)
 #define SFP_EEPROM_SFF_8472_COMP_ADDR		0x5e
 #define SFP_EEPROM_SFF_8472_COMP_SIZE		1
 
-- 
2.20.1



