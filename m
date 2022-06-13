Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193555494FB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377763AbiFMNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378911AbiFMNjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0F0793A4;
        Mon, 13 Jun 2022 04:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 072CA61243;
        Mon, 13 Jun 2022 11:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130E0C3411E;
        Mon, 13 Jun 2022 11:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119697;
        bh=rrdUq0+U2ydsV3HuaJAwxcFjpuqb+aKuO/e9fbI9Kmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhWMC1qNHTsfVHC5NH/vQUQti5pgkTfUWvhlNb/P/NoW7d43GDMI2ODXectv9AJn6
         xw9X1jgVA4EwhsHsP2DAZXiCrvNEDT9eztToQgy7lNxfZ7sS9Xf0RXfBSdg6vcZIao
         cSWVDoILXPD7//8KjmM3R0wR7Tt+66zT/R22J0/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 089/339] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable
Date:   Mon, 13 Jun 2022 12:08:34 +0200
Message-Id: <20220613094929.215867138@linuxfoundation.org>
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

From: liuyacan <liuyacan@corp.netease.com>

[ Upstream commit b3b1a17538d3ef6a9667b2271216fd16d7678ab5 ]

In the process of checking whether RDMAv2 is available, the current
implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
smc buf desc and register rmb, but the latter may fail. In this case,
the pointer should be reset.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
Link: https://lore.kernel.org/r/20220525085408.812273-1-liuyacan@corp.netease.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 45a24d24210f..540b32d86d9b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2136,6 +2136,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	ini->smcrv2.ib_dev_v2 = NULL;
 	ini->check_smcrv2 = false;
 }
 
-- 
2.35.1



