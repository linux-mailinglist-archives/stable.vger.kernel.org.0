Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B337E5869AA
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiHAMFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiHAMEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:04:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64D758B61;
        Mon,  1 Aug 2022 04:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D6AEB8117D;
        Mon,  1 Aug 2022 11:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76252C433C1;
        Mon,  1 Aug 2022 11:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354866;
        bh=GhmHgnQuSSZFRH6+PxWJAB/jWxMQMeFLSElGzZXSxMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhY5PdSsxOWktjz9/6yl9cROPlohuhMPWdWOn8NeQqhVOlf8OBEG4rmZPpKlEObfM
         eRhytN03wV56hYtmWrVB9V7AQ9mzEi1dQajnh/kGeV1e9nTSxexGT/eg929aIQQo07
         ucZhW74Nv/CgGNDBqUSqu/UVgks+jGmk4y2kLehE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frantisek Sumsal <fsumsal@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/69] macsec: fix NULL deref in macsec_add_rxsa
Date:   Mon,  1 Aug 2022 13:47:05 +0200
Message-Id: <20220801114136.135923920@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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
index e53b40359fd1..f72d4380374d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1751,7 +1751,8 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
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



