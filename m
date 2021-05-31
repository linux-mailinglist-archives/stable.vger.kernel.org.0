Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5331395CB6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhEaNgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231629AbhEaNdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 779266143B;
        Mon, 31 May 2021 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467470;
        bh=tQZdtYbWLdg5SswCUN0BLKrwEcQO7/7BTQOA25kVGX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PcanPdL+ghM51iPoNiBY+Nng/venKJ/aIzy/vd/ZNrs0ry+lK4XhTya+AciNALLPE
         +wQ/PBAJOaGP6wdB88eH1n8TeeVnN6c/M4fDXSGaDZzuP6m9N+WfEeRfSUUPM6Pi74
         z7bB2QNjbhcPJZSHiW10cNZ+PGnkCcL3nGEbrnjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Du Cheng <ducheng2@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/116] net: caif: remove BUG_ON(dev == NULL) in caif_xmit
Date:   Mon, 31 May 2021 15:14:14 +0200
Message-Id: <20210531130642.799243355@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit 65a67792e3416f7c5d7daa47d99334cbb19a7449 ]

The condition of dev == NULL is impossible in caif_xmit(), hence it is
for the removal.

Explanation:
The static caif_xmit() is only called upon via a function pointer
`ndo_start_xmit` defined in include/linux/netdevice.h:
```
struct net_device_ops {
    ...
    netdev_tx_t     (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev);
    ...
}
```

The exhausive list of call points are:
```
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
    dev->netdev_ops->ndo_start_xmit(skb, dev);
    ^                                    ^

drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
    struct opa_vnic_adapter *adapter = opa_vnic_priv(netdev);
			     ^                       ^
    return adapter->rn_ops->ndo_start_xmit(skb, netdev); // adapter would crash first
	   ^                                    ^

drivers/usb/gadget/function/f_ncm.c
    ncm->netdev->netdev_ops->ndo_start_xmit(NULL, ncm->netdev);
	      ^                                   ^

include/linux/netdevice.h
static inline netdev_tx_t __netdev_start_xmit(...
{
    return ops->ndo_start_xmit(skb, dev);
				    ^
}

    const struct net_device_ops *ops = dev->netdev_ops;
				       ^
    rc = __netdev_start_xmit(ops, skb, dev, more);
				       ^
```

In each of the enumerated scenarios, it is impossible for the NULL-valued dev to
reach the caif_xmit() without crashing the kernel earlier, therefore `BUG_ON(dev ==
NULL)` is rather useless, hence the removal.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-20-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index a0f954f36c09..94d5ce9419ca 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -279,7 +279,6 @@ static int caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-	BUG_ON(dev == NULL);
 	ser = netdev_priv(dev);
 
 	/* Send flow off once, on high water mark */
-- 
2.30.2



