Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F322254975D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiFMM51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355430AbiFMM4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F4C12A82;
        Mon, 13 Jun 2022 04:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2D4460EF1;
        Mon, 13 Jun 2022 11:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA48C34114;
        Mon, 13 Jun 2022 11:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119020;
        bh=isPy1lEIEV/Yb9k1s123x9G4HSbBUjDuaX5eNnHUFno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5Q9dJ26GPgHVgIJQymEyTcTIbLr8AqogbsRaQt5iz35pgBbZghTTHIGmG2T0Q5wQ
         tW/DersjtnzCNRtwM25Oku93QjdUngSjrLX3KRA+wZReRe9iW1GIvpXbSDAN86Mxf7
         LkumfxCxnTXQGo3HC+NixSYumZMAtvymFHxz3cuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/247] net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"
Date:   Mon, 13 Jun 2022 12:09:47 +0200
Message-Id: <20220613094925.533641933@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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
index 84c8a4374fdd..5d180d24cbf1 100644
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



