Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C97615764A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBJMuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbgBJMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AB1320873;
        Mon, 10 Feb 2020 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338645;
        bh=8qFy2P9Vypn24UZq8VITnvCyAMf7Rm5CIXUCo9bYzcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqv5B1NKK2MkaobL4++aWEe+ZOz7PDHR11ZqkIK6nreFeNxibwS9D0ZvbvXGg9kA8
         9XYKF5yXjETiwYgUPi3EYve2UQEwtRayKzM2TI3z4C6Gx3RzRJncg/svW8DTGZt/hi
         j+RPFck+9jMMpv0PPaMgq6A7DsAcE/00pyO6FhG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Verma, Aashish" <aashishx.verma@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 332/367] net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter
Date:   Mon, 10 Feb 2020 04:34:05 -0800
Message-Id: <20200210122453.473303179@linuxfoundation.org>
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

From: "Verma, Aashish" <aashishx.verma@intel.com>

[ Upstream commit 2ba31cd93784b61813226d259fd94a221ecd9d61 ]

Without checking for IFF_MULTICAST flag, it is wrong to assume multicast
filtering is always enabled. By checking against IFF_MULTICAST, now
the driver behaves correctly when the multicast support is toggled by below
command:-
  ip link set <devname> multicast off|on

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Verma, Aashish <aashishx.verma@intel.com>
Tested-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -420,7 +420,7 @@ static void dwmac4_set_filter(struct mac
 		value |= GMAC_PACKET_FILTER_PM;
 		/* Set all the bits of the HASH tab */
 		memset(mc_filter, 0xff, sizeof(mc_filter));
-	} else if (!netdev_mc_empty(dev)) {
+	} else if (!netdev_mc_empty(dev) && (dev->flags & IFF_MULTICAST)) {
 		struct netdev_hw_addr *ha;
 
 		/* Hash filter for multicast */


