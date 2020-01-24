Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576D4147B71
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbgAXJne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:43:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733222AbgAXJnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:33 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9FB20718;
        Fri, 24 Jan 2020 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859012;
        bh=7kMDFLir7unsB5/9d2P8c4ojgAoqS6YRpOXtST5S4dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmLkPIzN8Svhf/cyAgFshZNnCAKuOEGh3saFBCls19IaCdiLsw/lYO4KCIaqDru6a
         swKdV9jIeNfT4cgtui8+MI75mIaveKdmRaL0SxC0KetKMSUxV7rd2lHPTGiONY5Az9
         7rNEfCEg8Ec05kEJyCm+l54s9ylXblnpZBFU5tmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/343] mlxsw: reg: QEEC: Add minimum shaper fields
Date:   Fri, 24 Jan 2020 10:27:20 +0100
Message-Id: <20200124092922.515834350@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 8ab7a4f98a07c..e7974ba064324 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2452,7 +2452,7 @@ static inline void mlxsw_reg_qtct_pack(char *payload, u8 local_port,
  * Configures the ETS elements.
  */
 #define MLXSW_REG_QEEC_ID 0x400D
-#define MLXSW_REG_QEEC_LEN 0x1C
+#define MLXSW_REG_QEEC_LEN 0x20
 
 MLXSW_REG_DEFINE(qeec, MLXSW_REG_QEEC_ID, MLXSW_REG_QEEC_LEN);
 
@@ -2494,6 +2494,15 @@ MLXSW_ITEM32(reg, qeec, element_index, 0x04, 0, 8);
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
@@ -2510,6 +2519,17 @@ enum {
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



