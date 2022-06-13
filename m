Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F02E548EAE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355589AbiFMMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359154AbiFMM36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:29:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F885AEC2;
        Mon, 13 Jun 2022 04:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46506B80D31;
        Mon, 13 Jun 2022 11:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3009C34114;
        Mon, 13 Jun 2022 11:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118394;
        bh=6ctdFOTWDtWmLHAu5eKElqupwIGGX+DBvI+WG+W+HCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSKfA3ssSiuZyL8tlEH6jFjocTGh1cFIOXgQJTICt8x5UAnw8H0UYCO0ujohf0eF+
         5EAgTaOnHgvJco4uthDjUQhcbyTjjpTJv7ZaKYncG4l/TAgHp1PX2zyC+F144+sRKb
         wdzvR39qek5A8cfHdfRXwVpGrqXQ2K/1rewhuPTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/172] net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
Date:   Mon, 13 Jun 2022 12:10:20 +0200
Message-Id: <20220613094904.794022578@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit e225c9a5a74b12e9ef8516f30a3db2c7eb866ee1 ]

"struct smc_cdc_tx_pend **" can not directly convert
to "struct smc_wr_tx_pend_priv *".

Fixes: 2bced6aefa3d ("net/smc: put slot when connection is killed")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 0c490cdde6a4..94503f36b9a6 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -72,7 +72,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 		/* abnormal termination */
 		if (!rc)
 			smc_wr_tx_put_slot(link,
-					   (struct smc_wr_tx_pend_priv *)pend);
+					   (struct smc_wr_tx_pend_priv *)(*pend));
 		rc = -EPIPE;
 	}
 	return rc;
-- 
2.35.1



