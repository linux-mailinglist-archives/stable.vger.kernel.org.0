Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE493261AB2
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbgIHSiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731325AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA902404F;
        Tue,  8 Sep 2020 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580101;
        bh=X+pkzHAY+45DpjnBBnmun/XbamZy5ZEupPKNeiUbPqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZ5vSft4YlAR5RskaKNShZKuZ/zQ0Eoisxw+9nTLplzyWcSCF6jOr8hYxYQX20ccj
         I/DEawDCl8JCLM0zoYu9cctAGPRyKv+G9CjxtGHNlFd989uLuzPQVMyULZI3E/I4lG
         KERXZVH9M/Dny/GzIb/lYRuoei1PR0huKb7au6LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/88] bnxt_en: Dont query FW when netif_running() is false.
Date:   Tue,  8 Sep 2020 17:25:32 +0200
Message-Id: <20200908152222.628631668@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit c1c2d77408022a398a1a7c51cf20488c922629de ]

In rare conditions like two stage OS installation, the
ethtool's get_channels function may be called when the
device is in D3 state, leading to uncorrectable PCI error.
Check netif_running() first before making any query to FW
which involves writing to BAR.

Fixes: db4723b3cd2d ("bnxt_en: Check max_tx_scheduler_inputs value from firmware.")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 63730e449e088..14fe4f9f24b88 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -471,7 +471,7 @@ static void bnxt_get_channels(struct net_device *dev,
 	int max_tx_sch_inputs;
 
 	/* Get the most up-to-date max_tx_sch_inputs. */
-	if (BNXT_NEW_RM(bp))
+	if (netif_running(dev) && BNXT_NEW_RM(bp))
 		bnxt_hwrm_func_resc_qcaps(bp, false);
 	max_tx_sch_inputs = hw_resc->max_tx_sch_inputs;
 
-- 
2.25.1



