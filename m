Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301581455C4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgAVNZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgAVNZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:01 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51532467B;
        Wed, 22 Jan 2020 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699500;
        bh=ikhNzRPjtLv6agTCVjiSdi6VCJA/GFt+zgLfGnJjqAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcV46VuyQRWD4FHI14s7H6jx7rS4/eYqRoH8PD3bBtOGsm8hITQilDrUS2dgFSCNR
         M7KHdlpAUCbEpv5gkIXQHA29of1mFfnWOcjZi9rfnlx32U7rgL/qooNYJ6rtnDRSFE
         x/4d7q6XXlP6H0SBnsfvSXaodqLbG9CWu6iai7Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 165/222] net: stmmac: selftests: Mark as fail when received VLAN ID != expected
Date:   Wed, 22 Jan 2020 10:29:11 +0100
Message-Id: <20200122092845.527092902@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit d39b68e5a736afa67d2e9cfb158efdd237d99dbd upstream.

When the VLAN ID does not match the expected one it means filter failed
in HW. Fix it.

Fixes: 94e18382003c ("net: stmmac: selftests: Add selftest for VLAN TX Offload")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -853,8 +853,12 @@ static int stmmac_test_vlan_validate(str
 	if (tpriv->vlan_id) {
 		if (skb->vlan_proto != htons(proto))
 			goto out;
-		if (skb->vlan_tci != tpriv->vlan_id)
+		if (skb->vlan_tci != tpriv->vlan_id) {
+			/* Means filter did not work. */
+			tpriv->ok = false;
+			complete(&tpriv->comp);
 			goto out;
+		}
 	}
 
 	ehdr = (struct ethhdr *)skb_mac_header(skb);


