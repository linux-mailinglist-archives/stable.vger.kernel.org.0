Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A64548DED
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378447AbiFMNle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379122AbiFMNjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B797A459;
        Mon, 13 Jun 2022 04:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E457CE1166;
        Mon, 13 Jun 2022 11:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656F0C34114;
        Mon, 13 Jun 2022 11:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119724;
        bh=PmQMdKKBRYPR+mOWp4FAdxocodqjDfYNXP6WYmpUaM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbck0VwTsN9QiZkyKiOeixyaRW0CgvMDxkRBN24YYo37zjy9meUXb4Opw+90ICa2m
         ncph0UNfFBSYrWakDHG4KROxa5eUpc8OmCRPyB8JV7eOalUff3ZS7Khl4Y/GDJ/wfO
         aoE4AbbPBxwP7wLjCoPqBM33CcAVetnYrDNEGRNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 109/339] net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
Date:   Mon, 13 Jun 2022 12:08:54 +0200
Message-Id: <20220613094929.816820580@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index 5c731f27996e..53f63bfbaf5f 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -82,7 +82,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
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



