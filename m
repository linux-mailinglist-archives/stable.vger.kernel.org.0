Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9734541C01
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382546AbiFGVz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382496AbiFGVvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF22C23CA15;
        Tue,  7 Jun 2022 12:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 355DF618D6;
        Tue,  7 Jun 2022 19:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F08FC385A5;
        Tue,  7 Jun 2022 19:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628934;
        bh=4pjp53QtvT7RumT2yo6vjeHKd4VbrbIfKAoyK/6jk/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbpDuohtqgBCCdvvFOAjc3aiZ12VQLHIjzVz1Jxc+irdcgzEnx1PUHuxaaBiH8BHI
         nsSz9c9UuAXbQcRa59bpMlECadgOiOv+fp1aONWnFqeO9A80Y374edecBoHIGMcJGf
         OPH8WRyBAJK3tp/Yq3SgguwqIHr2K+lUynClQIAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 510/879] net: stmmac: fix out-of-bounds access in a selftest
Date:   Tue,  7 Jun 2022 19:00:28 +0200
Message-Id: <20220607165017.678504550@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fe5c5fc145edcf98a759b895f52b646730eeb7be ]

GCC 12 points out that struct tc_action is smaller than
struct tcf_action:

drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c: In function ‘stmmac_test_rxp’:
drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:1132:21: warning: array subscript ‘struct tcf_gact[0]’ is partly outside array bounds of ‘unsigned char[272]’ [-Warray-bounds]
 1132 |                 gact->tcf_action = TC_ACT_SHOT;
      |                     ^~

Fixes: ccfc639a94f2 ("net: stmmac: selftests: Add a selftest for Flexible RX Parser")
Link: https://lore.kernel.org/r/20220519004305.2109708-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c  | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 9f1759593b94..2fc51dc5eb0b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1084,8 +1084,9 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	unsigned char addr[ETH_ALEN] = {0xde, 0xad, 0xbe, 0xef, 0x00, 0x00};
 	struct tc_cls_u32_offload cls_u32 = { };
 	struct stmmac_packet_attrs attr = { };
-	struct tc_action **actions, *act;
+	struct tc_action **actions;
 	struct tc_u32_sel *sel;
+	struct tcf_gact *gact;
 	struct tcf_exts *exts;
 	int ret, i, nk = 1;
 
@@ -1110,8 +1111,8 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 		goto cleanup_exts;
 	}
 
-	act = kcalloc(nk, sizeof(*act), GFP_KERNEL);
-	if (!act) {
+	gact = kcalloc(nk, sizeof(*gact), GFP_KERNEL);
+	if (!gact) {
 		ret = -ENOMEM;
 		goto cleanup_actions;
 	}
@@ -1126,9 +1127,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	exts->nr_actions = nk;
 	exts->actions = actions;
 	for (i = 0; i < nk; i++) {
-		struct tcf_gact *gact = to_gact(&act[i]);
-
-		actions[i] = &act[i];
+		actions[i] = (struct tc_action *)&gact[i];
 		gact->tcf_action = TC_ACT_SHOT;
 	}
 
@@ -1152,7 +1151,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	stmmac_tc_setup_cls_u32(priv, priv, &cls_u32);
 
 cleanup_act:
-	kfree(act);
+	kfree(gact);
 cleanup_actions:
 	kfree(actions);
 cleanup_exts:
-- 
2.35.1



