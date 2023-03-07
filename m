Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983F46AF333
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjCGTBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbjCGTBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:01:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EBA1C589
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1273CB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57851C433D2;
        Tue,  7 Mar 2023 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214876;
        bh=eMY9JpNRiXmRbsWEZxavKJpM+sgPfTsdiqK2KeUxxTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pROPo7DCFEGJV2PR7WeGgn9kY98N7aj5jEAWRboec4hhpn9NRMIC7807TABZPa2EY
         4bOoQJx3PrMv6TGgP9ixlEXcxT30ltpg8WmTh0a4RIduNAAHJ13FEb+xwwxBDnYpEE
         j49Zq49DC6KIpkO1WDflBviNp/SmqWp3lTZq4Ll4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/567] wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()
Date:   Tue,  7 Mar 2023 17:56:54 +0100
Message-Id: <20230307165909.270615505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 212fde3fe76e962598ce1d47b97cc78afdfc71b3 ]

The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
Compile tested only.

Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1668684782-47422-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index e5bae62245215..f03fc6f1f8333 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -338,6 +338,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			bphy_err(drvr, "%s: failed to expand headroom\n",
 				 brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
-- 
2.39.2



