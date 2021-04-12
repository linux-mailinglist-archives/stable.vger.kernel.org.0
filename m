Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E422C35BE55
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhDLI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239089AbhDLIzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A546109E;
        Mon, 12 Apr 2021 08:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217725;
        bh=FUqgFfApoGjRxHq/MukDYLovoyFVuuo1SNIBrRck7qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbjWqJqfMc+avSIkBRolZhxFXu59FLBc/FrMrFuTLFZybVFAcs0hudLs0PCz/4ojn
         CS7H2gF4heW6Qda4yd2E/KEXBAVQUdKYsDVlfp9vKszd95xVblZf/3jQQnFzAoJ9Zl
         VHONvlzVAlFGqw5n4vnNK3qQcXfNSX5eVw6QvYxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/188] cxgb4: avoid collecting SGE_QBASE regs during traffic
Date:   Mon, 12 Apr 2021 10:40:36 +0200
Message-Id: <20210412084017.710740793@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 1bfb3dea965ff9f6226fd1709338f227363b6061 ]

Accessing SGE_QBASE_MAP[0-3] and SGE_QBASE_INDEX registers can lead
to SGE missing doorbells under heavy traffic. So, only collect them
when adapter is idle. Also update the regdump range to skip collecting
these registers.

Fixes: 80a95a80d358 ("cxgb4: collect SGE PF/VF queue map")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 23 +++++++++++++++----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  3 ++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index 75474f810249..c5b0e725b238 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1794,11 +1794,25 @@ int cudbg_collect_sge_indirect(struct cudbg_init *pdbg_init,
 	struct cudbg_buffer temp_buff = { 0 };
 	struct sge_qbase_reg_field *sge_qbase;
 	struct ireg_buf *ch_sge_dbg;
+	u8 padap_running = 0;
 	int i, rc;
+	u32 size;
 
-	rc = cudbg_get_buff(pdbg_init, dbg_buff,
-			    sizeof(*ch_sge_dbg) * 2 + sizeof(*sge_qbase),
-			    &temp_buff);
+	/* Accessing SGE_QBASE_MAP[0-3] and SGE_QBASE_INDEX regs can
+	 * lead to SGE missing doorbells under heavy traffic. So, only
+	 * collect them when adapter is idle.
+	 */
+	for_each_port(padap, i) {
+		padap_running = netif_running(padap->port[i]);
+		if (padap_running)
+			break;
+	}
+
+	size = sizeof(*ch_sge_dbg) * 2;
+	if (!padap_running)
+		size += sizeof(*sge_qbase);
+
+	rc = cudbg_get_buff(pdbg_init, dbg_buff, size, &temp_buff);
 	if (rc)
 		return rc;
 
@@ -1820,7 +1834,8 @@ int cudbg_collect_sge_indirect(struct cudbg_init *pdbg_init,
 		ch_sge_dbg++;
 	}
 
-	if (CHELSIO_CHIP_VERSION(padap->params.chip) > CHELSIO_T5) {
+	if (CHELSIO_CHIP_VERSION(padap->params.chip) > CHELSIO_T5 &&
+	    !padap_running) {
 		sge_qbase = (struct sge_qbase_reg_field *)ch_sge_dbg;
 		/* 1 addr reg SGE_QBASE_INDEX and 4 data reg
 		 * SGE_QBASE_MAP[0-3]
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 98d01a7497ec..581670dced6e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2090,7 +2090,8 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 		0x1190, 0x1194,
 		0x11a0, 0x11a4,
 		0x11b0, 0x11b4,
-		0x11fc, 0x1274,
+		0x11fc, 0x123c,
+		0x1254, 0x1274,
 		0x1280, 0x133c,
 		0x1800, 0x18fc,
 		0x3000, 0x302c,
-- 
2.30.2



