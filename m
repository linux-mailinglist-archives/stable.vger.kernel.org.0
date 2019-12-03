Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6921111C7B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfLCWoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfLCWo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6388820803;
        Tue,  3 Dec 2019 22:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413068;
        bh=0m1Avh+7iCfA8efKpYg84A8LNUnhwyMVsTgLBhap1ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r00BbFkF2HJenufzHOKByUnc/OUvK2Ng5nTtkP2cXh7DeRR+W9oOVoNzfQo4ipFMx
         Qj7wZTVpyKyR+UADQ9TPt6Lf9F4GFFE+S2CeOjZtuMUb5xwAWbqiBJNsjC4FAwopkz
         pxjG4JWSbFl0s1pwiiAV5J5S2Ae+6MoaYm8csPcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 085/135] net: stmmac: xgmac: bitrev32 returns u32
Date:   Tue,  3 Dec 2019 23:35:25 +0100
Message-Id: <20191203213034.318173781@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 3d00e45d498fd5347cea653ef494c56731b651e0 ]

The bitrev32 function returns an u32 var, not an int. Fix it.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 46d74f407aab6..91d7dec2540a1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -361,7 +361,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 		value |= XGMAC_FILTER_HMC;
 
 		netdev_for_each_mc_addr(ha, dev) {
-			int nr = (bitrev32(~crc32_le(~0, ha->addr, 6)) >>
+			u32 nr = (bitrev32(~crc32_le(~0, ha->addr, 6)) >>
 					(32 - mcbitslog2));
 			mc_filter[nr >> 5] |= (1 << (nr & 0x1F));
 		}
-- 
2.20.1



