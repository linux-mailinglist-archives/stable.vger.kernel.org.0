Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0361D586A56
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiHAMPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiHAMOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:14:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A077A48;
        Mon,  1 Aug 2022 04:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67AA8B8117A;
        Mon,  1 Aug 2022 11:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F02C433D7;
        Mon,  1 Aug 2022 11:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355075;
        bh=Rw/7w+b4/HttnljXh90geiflsimlF4zzYeRoJGJY7zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cg9y0fGLb3svhvtFbqa7vnDgmg1WoMWR0r6xZqb2FyI7kIgeRGHLfJKqtt8fAj1vM
         ++5LiRiPqlGZjzFlemj4arZ3mTVmfsKz85g74aKR1jIG/oRRlBkeukzuVfbL3rsFhD
         0YNrhnAVXtuNswQGUsj04QS6adRXediP9G77ctWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 53/88] macsec: fix error message in macsec_add_rxsa and _txsa
Date:   Mon,  1 Aug 2022 13:47:07 +0200
Message-Id: <20220801114140.452947608@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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
index 769a1eca6bd8..634452d3ecc5 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1770,7 +1770,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2012,7 +2012,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
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



