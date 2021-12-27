Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D52480075
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbhL0Pq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbhL0Pov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D09AC061394;
        Mon, 27 Dec 2021 07:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26EDDB810AA;
        Mon, 27 Dec 2021 15:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E348C36AE7;
        Mon, 27 Dec 2021 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619725;
        bh=DkNuUNGZZx6lawxNgzw1fIpCUw5deA3fzlpAajcxNaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D50Gqg5KaVjr2PRhuSE0UONASom/dtXkpbXeuXw8H7vDjijFUWj6mqRpkyxcUXChu
         dXhP5v2duaCQ6rq1AIf9EjUmf6Q4CKqPnS+DrLYjgArJnwTfUge3VuGHeG7OpTR+AY
         KLK20bG8AIr1q/7X+cJwKT0GshhquVP92ozlv8KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/128] net: stmmac: ptp: fix potentially overflowing expression
Date:   Mon, 27 Dec 2021 16:30:21 +0100
Message-Id: <20211227151333.053881654@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit eccffcf4657ab9a148faaa0eb354d2a091caf552 ]

Convert the u32 variable to type u64 in a context where expression of
type u64 is required to avoid potential overflow.

Fixes: e9e3720002f6 ("net: stmmac: ptp: update tas basetime after ptp adjust")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Link: https://lore.kernel.org/r/20211223073928.37371-1-xiaoliang.yang_1@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 580cc035536bd..be9b58b2abf9b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -102,7 +102,7 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 		time.tv_nsec = priv->plat->est->btr_reserve[0];
 		time.tv_sec = priv->plat->est->btr_reserve[1];
 		basetime = timespec64_to_ktime(time);
-		cycle_time = priv->plat->est->ctr[1] * NSEC_PER_SEC +
+		cycle_time = (u64)priv->plat->est->ctr[1] * NSEC_PER_SEC +
 			     priv->plat->est->ctr[0];
 		time = stmmac_calc_tas_basetime(basetime,
 						current_time_ns,
-- 
2.34.1



