Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366F94B47ED
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiBNJki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:40:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244456AbiBNJkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909EEBF5E;
        Mon, 14 Feb 2022 01:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEBEB60F87;
        Mon, 14 Feb 2022 09:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA184C340F0;
        Mon, 14 Feb 2022 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831345;
        bh=v8lP6EEDA/v9fJnTYb2UloIEPhnQ0fkNOq4kTJaU4l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKXmSLK7CF2dw0jnqI7T+PUC1lUOh/a5pjIM3NQearqG2umxcfUg4/qDtzSlScx/h
         VkWSN3B6oeu8r+QC10z4J2KuyZ13YxoAMACf8nvGkTrAvUlRRncSKtRSFa4uLsMcSg
         0Il+H+H5g7s+sIW+EkvYbOCJx57IuU0u7a4wSn8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/71] net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
Date:   Mon, 14 Feb 2022 10:25:52 +0100
Message-Id: <20220214092452.826836877@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 9e0db41e7a0b6f1271cbcfb16dbf5b8641b4e440 ]

When readl_poll_timeout() timeout, we'd better directly use its return
value.

Before this patch:
[    2.145528] dwmac-sun8i: probe of 4500000.ethernet failed with error -14

After this patch:
[    2.138520] dwmac-sun8i: probe of 4500000.ethernet failed with error -110

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 2f6258ca95155..7c73d296b940d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -718,7 +718,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
-- 
2.34.1



