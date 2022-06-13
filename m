Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED002549714
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbiFMOQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383030AbiFMOPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4816E9C2C7;
        Mon, 13 Jun 2022 04:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAFB8612D0;
        Mon, 13 Jun 2022 11:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C27C34114;
        Mon, 13 Jun 2022 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120566;
        bh=fk0snry+InHU+B4/QPetFWBQtBuKmh2RmoCROynAung=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TisOdVl3B1ivfciQE07nlor//UL0IQ3A9h5z9/v/ckOqNnF50hPER18D7baMH3Sim
         yOm7YRWvOiVb/QDqq7IaJmyo/kQEKCrkhdIbO5M+LImIY6m9JhICkVOJmqxUDOes2J
         hyyk0bx6ehCUwuvlWuJrX9a27kKMHPszF54yqSYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 079/298] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable
Date:   Mon, 13 Jun 2022 12:09:33 +0200
Message-Id: <20220613094927.342258382@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index b9fe31834354..4bc6b16669f3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1973,6 +1973,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	ini->smcrv2.ib_dev_v2 = NULL;
 	ini->check_smcrv2 = false;
 }
 
-- 
2.35.1



