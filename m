Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368C94D821C
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbiCNMAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240107AbiCNL7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225A633A33;
        Mon, 14 Mar 2022 04:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE57B80D96;
        Mon, 14 Mar 2022 11:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB0FC340EC;
        Mon, 14 Mar 2022 11:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259082;
        bh=zM52QmamlO07OtFPsQ54yDz6UNTX5mxublU6FRQhfC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhYzTmf8TykqV4xHMqy5812jKnZAWEU9hXovDi6RoEVOR9FzOZqJVLUT9JG5QNM8p
         SGQtj2tZSWlVTz+SF2GjzlAQD6LpXyzV5TSdkaseE9C1MUzNqrOzoeBYRDYVu2SWvH
         IvJnrHD3abcVSVY87Jhu29ZZKgGi0tvz8TlKtU44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/43] net: ethernet: ti: cpts: Handle error for clk_enable
Date:   Mon, 14 Mar 2022 12:53:20 +0100
Message-Id: <20220314112734.680962759@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6babfc6e6fab068018c36e8f6605184b8c0b349d ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 26cfe3f7ed8d..453ad1247288 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -454,7 +454,9 @@ int cpts_register(struct cpts *cpts)
 	for (i = 0; i < CPTS_MAX_EVENTS; i++)
 		list_add(&cpts->pool_data[i].list, &cpts->pool);
 
-	clk_enable(cpts->refclk);
+	err = clk_enable(cpts->refclk);
+	if (err)
+		return err;
 
 	cpts_write32(cpts, CPTS_EN, control);
 	cpts_write32(cpts, TS_PEND_EN, int_enable);
-- 
2.34.1



