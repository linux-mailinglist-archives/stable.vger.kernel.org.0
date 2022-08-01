Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC061586A53
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiHAMO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiHAMOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:14:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B9648CAD;
        Mon,  1 Aug 2022 04:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE89DB81171;
        Mon,  1 Aug 2022 11:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15405C433D6;
        Mon,  1 Aug 2022 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355072;
        bh=Pjt9arz70V3SkAfZi0jUYYdS/BqTVgwJMR24cK/ZAFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooQ7hbvh+3VeMbAT08BakWYozKOFLZA+ZzMAm7Vw0jrbZkMTJOpT81mtzrpufGDmo
         S7v6DK39+Rb7H5vdvRWSOUDl8LGs4/fOZHucpugOJ11P67CAP7EmMSe4CtfX+XQN2x
         FSi0Ov7ETXZkswysX3PdagCuBlIEWGbxfJyLGSyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frantisek Sumsal <fsumsal@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 52/88] macsec: fix NULL deref in macsec_add_rxsa
Date:   Mon,  1 Aug 2022 13:47:06 +0200
Message-Id: <20220801114140.404494468@linuxfoundation.org>
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

[ Upstream commit f46040eeaf2e523a4096199fd93a11e794818009 ]

Commit 48ef50fa866a added a test on tb_sa[MACSEC_SA_ATTR_PN], but
nothing guarantees that it's not NULL at this point. The same code was
added to macsec_add_txsa, but there it's not a problem because
validate_add_txsa checks that the MACSEC_SA_ATTR_PN attribute is
present.

Note: it's not possible to reproduce with iproute, because iproute
doesn't allow creating an SA without specifying the PN.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208315
Reported-by: Frantisek Sumsal <fsumsal@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 817577e713d7..769a1eca6bd8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1753,7 +1753,8 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+	if (tb_sa[MACSEC_SA_ATTR_PN] &&
+	    nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
 		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
 			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
 		rtnl_unlock();
-- 
2.35.1



