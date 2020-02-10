Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237E015764C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgBJMuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgBJMoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:05 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E4B20838;
        Mon, 10 Feb 2020 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338645;
        bh=4RxWrXFSQdTkrR1juUCh6siioEpSe+Z6z4xFwcI79j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps6U8YtNpbq0iQI0yxc+JMkh0jJ5jZH5xOjUWc/jYdQ6ljg3n+B660MsL/PT+N+OD
         wcqK7ygMTAGO3rZIGN0TF8Gl0+Edl+7YsHv9eB89TRx43VRG+nByOtg+cqzKK6zROt
         eydd2zmmgMFyyFb1y33jBNRQHmbDzHQlzNqRghfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Tan, Tee Min" <tee.min.tan@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 330/367] net: stmmac: fix incorrect GMAC_VLAN_TAG register writting in GMAC4+
Date:   Mon, 10 Feb 2020 04:34:03 -0800
Message-Id: <20200210122453.332494552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tan, Tee Min" <tee.min.tan@intel.com>

[ Upstream commit 9eeeb3c9de4e3aeaa2bec097162f09305dd9f4c3 ]

It should always do a read of current value of GMAC_VLAN_TAG instead of
directly overwriting the register value.

Fixes: c1be0022df0d ("net: stmmac: Add VLAN HASH filtering support in GMAC4+")
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -736,11 +736,14 @@ static void dwmac4_update_vlan_hash(stru
 				    __le16 perfect_match, bool is_double)
 {
 	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
 
 	writel(hash, ioaddr + GMAC_VLAN_HASH_TABLE);
 
+	value = readl(ioaddr + GMAC_VLAN_TAG);
+
 	if (hash) {
-		u32 value = GMAC_VLAN_VTHM | GMAC_VLAN_ETV;
+		value |= GMAC_VLAN_VTHM | GMAC_VLAN_ETV;
 		if (is_double) {
 			value |= GMAC_VLAN_EDVLP;
 			value |= GMAC_VLAN_ESVL;
@@ -759,8 +762,6 @@ static void dwmac4_update_vlan_hash(stru
 
 		writel(value | perfect_match, ioaddr + GMAC_VLAN_TAG);
 	} else {
-		u32 value = readl(ioaddr + GMAC_VLAN_TAG);
-
 		value &= ~(GMAC_VLAN_VTHM | GMAC_VLAN_ETV);
 		value &= ~(GMAC_VLAN_EDVLP | GMAC_VLAN_ESVL);
 		value &= ~GMAC_VLAN_DOVLTC;


