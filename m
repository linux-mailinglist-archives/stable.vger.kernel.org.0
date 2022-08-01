Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF675868F8
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiHALzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiHALyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:54:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E633E765;
        Mon,  1 Aug 2022 04:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F10B8116D;
        Mon,  1 Aug 2022 11:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C83C433C1;
        Mon,  1 Aug 2022 11:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354657;
        bh=fccSz834zV3hpRoaHeJs1Um/CBE6M8nxqixFWsZs9f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7L50dtIcJuYrf2TrMPGPjQHaEg7XvrF6x5cmUoB8NxklAyqVmuFwAR533ZmEmOc1
         uIsBZJABPilmH1Bj1b9Sw5vbx6ISmHvHwWf+jowvBLV4/9hVfQr1quowAHBPoYkes1
         +Kaci+ub6NZfZJXg5wappnBxlMJUvwdKCRuVr7Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/65] macsec: fix error message in macsec_add_rxsa and _txsa
Date:   Mon,  1 Aug 2022 13:46:49 +0200
Message-Id: <20220801114135.048046088@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 3240eac4ff20e51b87600dbd586ed814daf313db ]

The expected length is MACSEC_SALT_LEN, not MACSEC_SA_ATTR_SALT.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0b53c7cadd87..c2d8bcda2503 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1767,7 +1767,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2009,7 +2009,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
-- 
2.35.1



