Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062406C16EF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjCTPKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjCTPJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BB1303FD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8DB5B80EC4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288CC433A0;
        Mon, 20 Mar 2023 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324681;
        bh=SFBggJYkVHnCEZcZfLMB/8VKkg2NrKqNkLzN9FgAHNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1/ehR3qhbI6qLL36xzmxjqe62GEDsD7j3k3gZ54AYniv1c1tRJB8xlP/b75sw0F8
         u2uDisMDv10xEYdgU3BCdE/WEbUFnUzlTbe8cbIqL+YYeQ0LqTd+jk6Kx0lZff+rja
         nUKglGInLdNIlezCRjEbgcSGpvQTgD14qUv2LTTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/115] ipvlan: Make skb->skb_iif track skb->dev for l3s mode
Date:   Mon, 20 Mar 2023 15:53:48 +0100
Message-Id: <20230320145450.076104568@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 59a0b022aa249e3f5735d93de0849341722c4754 ]

For l3s mode, skb->dev is set to ipvlan interface in ipvlan_nf_input():
  skb->dev = addr->master->dev
but, skb->skb_iif remain unchanged, this will cause socket lookup failed
if a target socket is bound to a interface, like the following example:

  ip link add ipvlan0 link eth0 type ipvlan mode l3s
  ip addr add dev ipvlan0 192.168.124.111/24
  ip link set ipvlan0 up

  ping -c 1 -I ipvlan0 8.8.8.8
  100% packet loss

This is because there is no match sk in __raw_v4_lookup() as sk->sk_bound_dev_if != dif(skb->skb_iif).
Fix this by make skb->skb_iif track skb->dev in ipvlan_nf_input().

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/29865b1f-6db7-c07a-de89-949d3721ea30@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f5..71712ea25403d 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;
 
 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
-- 
2.39.2



