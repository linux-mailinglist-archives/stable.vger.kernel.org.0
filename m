Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0071334C5CB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhC2IC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhC2IC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D68761974;
        Mon, 29 Mar 2021 08:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004945;
        bh=ORTxPdGNjAuGYhuJCMBUbSzDCD4yWRlwdRYFYikR3ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ie+SLGTQGOQl0m4QV1T3f8nJQJn/g49z/yRFDPbQ1XOCaWvMOOa0nv9AyA3WJkHI/
         cLkaPYtYSRB5aH0fXpdN/qdtVVflRJCNbXNrRYLgULjIfMJicgN/RdfDAqCJUtRO6K
         7glSAMD334MyVfZHpaWS0AyWzkDzGBKTKlxdusyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/53] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Mon, 29 Mar 2021 09:57:42 +0200
Message-Id: <20210329075607.793844332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 155b23e6e53475ca3b8c2a946299b4d4dd6a5a1e ]

RXMAC_BC_FRM_CNT_COUNT added to mp->rx_bcasts twice in a row
in niu_xmac_interrupt(). Remove the second addition.

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index fe5b0ac8c631..5bf47279f9c1 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3948,8 +3948,6 @@ static void niu_xmac_interrupt(struct niu *np)
 		mp->rx_mcasts += RXMAC_MC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
 		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
-	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
-		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST1_CNT_EXP)
 		mp->rx_hist_cnt1 += RXMAC_HIST_CNT1_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST2_CNT_EXP)
-- 
2.30.1



