Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F8B540BEA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345923AbiFGScn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351673AbiFGSaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C10E17B85D;
        Tue,  7 Jun 2022 10:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 038D7617A8;
        Tue,  7 Jun 2022 17:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142E0C34115;
        Tue,  7 Jun 2022 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624537;
        bh=2YrUAPy0Va4065/bPQ5aKGCMCndYYbCob222IpPQICg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lai+P6vhoodwBtEqsq4qWjx4l+t+05hPf34LBpS+0sE/pcKdss8FTw9Rj868/4Wyz
         mpupBF9uu4SHC9gqbVufMxaxXolI9zpA/avfMILcgLL1fhS8zNtcbzbA/l59lNdOwb
         MFv3HCr9Ds4a4Hl/eS7VW9L5G0rhbrqiK+/RzEqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/667] net: stmmac: selftests: Use kcalloc() instead of kzalloc()
Date:   Tue,  7 Jun 2022 19:00:29 +0200
Message-Id: <20220607164945.670784826@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 36371876e000012ae4440fcf3097c2f0ed0f83e7 ]

Use 2-factor multiplication argument form kcalloc() instead
of kzalloc().

Link: https://github.com/KSPP/linux/issues/162
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20211006180944.GA913477@embeddedor
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 0462dcc93e53..e649a3e6a529 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1104,13 +1104,13 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 		goto cleanup_sel;
 	}
 
-	actions = kzalloc(nk * sizeof(*actions), GFP_KERNEL);
+	actions = kcalloc(nk, sizeof(*actions), GFP_KERNEL);
 	if (!actions) {
 		ret = -ENOMEM;
 		goto cleanup_exts;
 	}
 
-	act = kzalloc(nk * sizeof(*act), GFP_KERNEL);
+	act = kcalloc(nk, sizeof(*act), GFP_KERNEL);
 	if (!act) {
 		ret = -ENOMEM;
 		goto cleanup_actions;
-- 
2.35.1



