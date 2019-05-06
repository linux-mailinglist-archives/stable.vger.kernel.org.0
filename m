Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB8B14EFE
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfEFOhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727291AbfEFOhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47F49206A3;
        Mon,  6 May 2019 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153421;
        bh=rLDf/z599L+TxF1cg/rwNNt0iqybU0xScUBZmXOil6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5VXfRvNZhuykYh2ikc+ZKwpZ+Or7MkpIKsUMTQLlxKYW1Ry+EckhJGaP5tj+j/RM
         AQYHKyqFohPRKfrHgO/iCYtJlawVvxnL8yub5GlvkTDdMLfmAY7rhPtqXBqVNbml9d
         4pFkqfumNpbLizuQZvUpcdnq5ScDPjIaWotN1rh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 042/122] i40e: fix WoL support check
Date:   Mon,  6 May 2019 16:31:40 +0200
Message-Id: <20190506143058.693436013@linuxfoundation.org>
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

[ Upstream commit f669d24f3dd00beab452c0fc9257f6a942ffca9b ]

The current check for WoL on i40e is broken. Code comment says only
magic packet is supported, so only check for that.

Fixes: 540a152da762 (i40e/ixgbe/igb: fail on new WoL flag setting WAKE_MAGICSECURE)

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index a6bc7847346b..5d544e661445 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2378,8 +2378,7 @@ static int i40e_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 		return -EOPNOTSUPP;
 
 	/* only magic packet is supported */
-	if (wol->wolopts && (wol->wolopts != WAKE_MAGIC)
-			  | (wol->wolopts != WAKE_FILTER))
+	if (wol->wolopts & ~WAKE_MAGIC)
 		return -EOPNOTSUPP;
 
 	/* is this a new value? */
-- 
2.20.1



