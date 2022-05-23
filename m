Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F32E531A82
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiEWRbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241749AbiEWR1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3196762A2;
        Mon, 23 May 2022 10:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80EC2B81205;
        Mon, 23 May 2022 17:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D4C385A9;
        Mon, 23 May 2022 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326523;
        bh=rvSzg4byCwgWMomkfs8o838Z56L/SF9292ftwShD6Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcunDlAuwNoGdecGABmO1jGCI2UzjLMRFvDbP250M0KijUi1RSXyP87cMGID2gzkQ
         JARiasrIlVqdYefHGYYqq4ADgyAdvoCJtSZsSDFhJG2EGbOE/azg/hop46Ut8K7Aqc
         8lUUy6DW+swOwPVAMwoCez8kyN3uPP2sQV7Yc1QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/132] net: systemport: Fix an error handling path in bcm_sysport_probe()
Date:   Mon, 23 May 2022 19:04:49 +0200
Message-Id: <20220523165836.357952461@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ef6b1cd11962aec21c58d137006ab122dbc8d6fd ]

if devm_clk_get_optional() fails, we still need to go through the error
handling path.

Add the missing goto.

Fixes: 6328a126896ea ("net: systemport: Manage Wake-on-LAN clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0877b3d7f88c..ae541a9d1eee 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2585,8 +2585,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 		device_set_wakeup_capable(&pdev->dev, 1);
 
 	priv->wol_clk = devm_clk_get_optional(&pdev->dev, "sw_sysportwol");
-	if (IS_ERR(priv->wol_clk))
-		return PTR_ERR(priv->wol_clk);
+	if (IS_ERR(priv->wol_clk)) {
+		ret = PTR_ERR(priv->wol_clk);
+		goto err_deregister_fixed_link;
+	}
 
 	/* Set the needed headroom once and for all */
 	BUILD_BUG_ON(sizeof(struct bcm_tsb) != 8);
-- 
2.35.1



