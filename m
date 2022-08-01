Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E290B586937
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiHAL6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiHAL6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:58:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7E9419A2;
        Mon,  1 Aug 2022 04:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9930612E3;
        Mon,  1 Aug 2022 11:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A28C433C1;
        Mon,  1 Aug 2022 11:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354735;
        bh=v3eMzd9USaj7O5CPtj1Ypzb355onBF7y+Urro/QYSdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enHaUITfRKojnOT1HvUWttU1GdrZkCUypqeLD1DfDlOOT1Iv9MTmajgsXqqPanZeX
         OhbUldg5SXoctRiFNbXhjFOvF38DM6V2QmqQQkoPjy8qNwUTp8yyzK2vNKEGhV9xdE
         FW+xI4FnyIVP6jgk1vquUoy+cuxjKugfgUmKDYHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/65] net: macsec: fix potential resource leak in macsec_add_rxsa() and macsec_add_txsa()
Date:   Mon,  1 Aug 2022 13:46:52 +0200
Message-Id: <20220801114135.176779971@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit c7b205fbbf3cffa374721bb7623f7aa8c46074f1 ]

init_rx_sa() allocates relevant resource for rx_sa->stats and rx_sa->
key.tfm with alloc_percpu() and macsec_alloc_tfm(). When some error
occurs after init_rx_sa() is called in macsec_add_rxsa(), the function
released rx_sa with kfree() without releasing rx_sa->stats and rx_sa->
key.tfm, which will lead to a resource leak.

We should call macsec_rxsa_put() instead of kfree() to decrease the ref
count of rx_sa and release the relevant resource if the refcount is 0.
The same bug exists in macsec_add_txsa() for tx_sa as well. This patch
fixes the above two bugs.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 8d73b72d6179..70c5905a916b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1841,7 +1841,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	kfree(rx_sa);
+	macsec_rxsa_put(rx_sa);
 	rtnl_unlock();
 	return err;
 }
@@ -2084,7 +2084,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 cleanup:
 	secy->operational = was_operational;
-	kfree(tx_sa);
+	macsec_txsa_put(tx_sa);
 	rtnl_unlock();
 	return err;
 }
-- 
2.35.1



