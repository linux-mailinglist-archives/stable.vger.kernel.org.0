Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3E314F25
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfEFOfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfEFOfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB589204EC;
        Mon,  6 May 2019 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153342;
        bh=9zeHQlPijgcf6JRRmHXC/9ChAO8zIEKZhkj2hr+EehI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oy7tBKZTztXOeWLoWUbfgsgkGlOmiLYtCEjFxvf0AlM9UYMVor7MgUzX2x55L0OXw
         HE6ctd9tWcc7nYVYaGPd/1BvalYJuz3FgK0lYprTKA0QWAEsYWIPPM5weG4VRxqfn8
         7S+VBPNAWcJaw+Ic3nQTYVexiq5v6F5ZAr2u1aBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 053/122] net: stmmac: dont overwrite discard_frame status
Date:   Mon,  6 May 2019 16:31:51 +0200
Message-Id: <20190506143059.681026572@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1b746ce8b397e58f9e40ce5c63b7198de6930482 ]

If we have error bits set, the discard_frame status will get overwritten
by checksum bit checks, which might set the status back to good one.
Fix by checking the COE status only if the frame is good.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index e8855e6adb48..c42ef6c729c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -231,9 +231,10 @@ static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 	 * It doesn't match with the information reported into the databook.
 	 * At any rate, we need to understand if the CSUM hw computation is ok
 	 * and report this info to the upper layers. */
-	ret = enh_desc_coe_rdes0(!!(rdes0 & RDES0_IPC_CSUM_ERROR),
-				 !!(rdes0 & RDES0_FRAME_TYPE),
-				 !!(rdes0 & ERDES0_RX_MAC_ADDR));
+	if (likely(ret == good_frame))
+		ret = enh_desc_coe_rdes0(!!(rdes0 & RDES0_IPC_CSUM_ERROR),
+					 !!(rdes0 & RDES0_FRAME_TYPE),
+					 !!(rdes0 & ERDES0_RX_MAC_ADDR));
 
 	if (unlikely(rdes0 & RDES0_DRIBBLING))
 		x->dribbling_bit++;
-- 
2.20.1



