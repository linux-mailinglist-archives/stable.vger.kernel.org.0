Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D8334C596
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhC2IBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhC2IBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B833361969;
        Mon, 29 Mar 2021 08:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004871;
        bh=SIHhCZxrnfKiMp4P1TEUPAcpCiMriRCZ0H/FHgexX0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZInX6XDpEaNrGZ9J1NlO5XBCrumlQ1qGt+WLYMellAZBLT/AjU19eZkkuY6uaguA7
         grZHLel6NmZE6kfu98u4r6d4Adr9+lOSUbCNVh6hAQMsNTMV02zZhGvmJLJKk8LaL5
         9f5JufmCK5sWnvvRp3pAlDYNryyatV4GxqmvKVkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/33] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Mon, 29 Mar 2021 09:57:51 +0200
Message-Id: <20210329075605.490105787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
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
index 85f3a2c0d4dd..cc3b025ab7a7 100644
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



