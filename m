Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A183114BAAA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgA1OPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbgA1OPG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3979924681;
        Tue, 28 Jan 2020 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220905;
        bh=1m+lCTM68vTe/EhceDD5nTkHNlOHn75Gidd+5DqJr1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/mDC+ciaBXG8jY6uMCa5GYSUZ8krIJzChZioaLhh2U4AHcrucX/8eCMQMOnesgEV
         fHg/fu/DL37FmFnZVcLhVczbE6EFdDL/bjk+uad66h/fXJwBqQ4rYYUBxgLjJC0MnB
         W/U3GXsfX2NZIjrNDP7zyHp2ECsVGP3MuCchjq+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 011/271] mlxsw: reg: QEEC: Add minimum shaper fields
Date:   Tue, 28 Jan 2020 15:02:40 +0100
Message-Id: <20200128135853.266292286@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 8b931821aa04823e2e5df0ae93937baabbd23286 ]

Add QEEC.mise (minimum shaper enable) and QEEC.min_shaper_rate to enable
configuration of minimum shaper.

Increase the QEEC length to 0x20 as well: that's the length that the
register has had for a long time now, but with the configurations that
mlxsw typically exercises, the firmware tolerated 0x1C-sized packets.
With mise=true however, FW rejects packets unless they have the full
required length.

Fixes: b9b7cee40579 ("mlxsw: reg: Add QoS ETS Element Configuration register")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b2a745b579fd1..fdc69218c8cac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1873,7 +1873,7 @@ static inline void mlxsw_reg_qtct_pack(char *payload, u8 local_port,
  * Configures the ETS elements.
  */
 #define MLXSW_REG_QEEC_ID 0x400D
-#define MLXSW_REG_QEEC_LEN 0x1C
+#define MLXSW_REG_QEEC_LEN 0x20
 
 static const struct mlxsw_reg_info mlxsw_reg_qeec = {
 	.id = MLXSW_REG_QEEC_ID,
@@ -1918,6 +1918,15 @@ MLXSW_ITEM32(reg, qeec, element_index, 0x04, 0, 8);
  */
 MLXSW_ITEM32(reg, qeec, next_element_index, 0x08, 0, 8);
 
+/* reg_qeec_mise
+ * Min shaper configuration enable. Enables configuration of the min
+ * shaper on this ETS element
+ * 0 - Disable
+ * 1 - Enable
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, mise, 0x0C, 31, 1);
+
 enum {
 	MLXSW_REG_QEEC_BYTES_MODE,
 	MLXSW_REG_QEEC_PACKETS_MODE,
@@ -1934,6 +1943,17 @@ enum {
  */
 MLXSW_ITEM32(reg, qeec, pb, 0x0C, 28, 1);
 
+/* The smallest permitted min shaper rate. */
+#define MLXSW_REG_QEEC_MIS_MIN	200000		/* Kbps */
+
+/* reg_qeec_min_shaper_rate
+ * Min shaper information rate.
+ * For CPU port, can only be configured for port hierarchy.
+ * When in bytes mode, value is specified in units of 1000bps.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, qeec, min_shaper_rate, 0x0C, 0, 28);
+
 /* reg_qeec_mase
  * Max shaper configuration enable. Enables configuration of the max
  * shaper on this ETS element.
-- 
2.20.1



