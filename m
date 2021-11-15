Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68039451EC1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355302AbhKPAhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233927AbhKOTZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D75A636E8;
        Mon, 15 Nov 2021 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003207;
        bh=+BpwhUrWnbHsNbJmARB0Vpvyq2ctRnMyVHYKPS6nqe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF+QQGRiQpsZMaX05kvw2Wi1j7Id2qUVtnSvdVCgPs1G5jhiENw+V/YRPo3O1Km6V
         Zj5TuzyCRv1CECAygmw57TgAt/O4RbDxp0c9KIwAq5aXArSlgaI2MjvCz81KO2FUHT
         TGBgLQ1rTr7q//vjjS6FzeUGPO4IXUTz9zRGozeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manoj Malviya <manojmalviya@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 843/917] cxgb4: fix eeprom len when diagnostics not implemented
Date:   Mon, 15 Nov 2021 18:05:38 +0100
Message-Id: <20211115165457.625544438@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 4ca110bf8d9b31a60f8f8ff6706ea147d38ad97c ]

Ensure diagnostics monitoring support is implemented for the SFF 8472
compliant port module and set the correct length for ethtool port
module eeprom read.

Fixes: f56ec6766dcf ("cxgb4: Add support for ethtool i2c dump")
Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 7 +++++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h         | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 5903bdb78916f..129352bbe1143 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2015,12 +2015,15 @@ static int cxgb4_get_module_info(struct net_device *dev,
 		if (ret)
 			return ret;
 
-		if (!sff8472_comp || (sff_diag_type & 4)) {
+		if (!sff8472_comp || (sff_diag_type & SFP_DIAG_ADDRMODE)) {
 			modinfo->type = ETH_MODULE_SFF_8079;
 			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8472;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+			if (sff_diag_type & SFP_DIAG_IMPLEMENTED)
+				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+			else
+				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
 		}
 		break;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
index 002fc62ea7262..63bc956d20376 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
@@ -293,6 +293,8 @@ enum {
 #define I2C_PAGE_SIZE		0x100
 #define SFP_DIAG_TYPE_ADDR	0x5c
 #define SFP_DIAG_TYPE_LEN	0x1
+#define SFP_DIAG_ADDRMODE	BIT(2)
+#define SFP_DIAG_IMPLEMENTED	BIT(6)
 #define SFF_8472_COMP_ADDR	0x5e
 #define SFF_8472_COMP_LEN	0x1
 #define SFF_REV_ADDR		0x1
-- 
2.33.0



