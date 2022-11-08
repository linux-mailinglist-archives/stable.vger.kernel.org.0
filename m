Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0E3621559
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiKHOKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiKHOKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:10:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3402177203
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C593F615B4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5004C43140;
        Tue,  8 Nov 2022 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916644;
        bh=jzscLdeMqaHACOzskwtUQzW+RXuJWiVnnCb3Sse+Vv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Urz0ytlSkLfDULWDQNtl46zKZXsKpL7/94WufIbivj8LXogWcJmsyEI8Rx+KlpOhp
         8T+79JJuVjwvIWQScJNEmlxCq/fyWumlFCUtuIDzGFn0++Pfl1cAwzMAcEdieDGVyL
         idmr73auXaWFKUpCor4cGwA8vTp/HRW0eUZckzYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/197] net/smc: Fix possible leaked pernet namespace in smc_init()
Date:   Tue,  8 Nov 2022 14:38:16 +0100
Message-Id: <20221108133357.464655778@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 62ff373da2534534c55debe6c724c7fe14adb97f ]

In smc_init(), register_pernet_subsys(&smc_net_stat_ops) is called
without any error handling.
If it fails, registering of &smc_net_ops won't be reverted.
And if smc_nl_init() fails, &smc_net_stat_ops itself won't be reverted.

This leaves wild ops in subsystem linkedlist and when another module
tries to call register_pernet_operations() it triggers page fault:

BUG: unable to handle page fault for address: fffffbfff81b964c
RIP: 0010:register_pernet_operations+0x1b9/0x5f0
Call Trace:
  <TASK>
  register_pernet_subsys+0x29/0x40
  ebtables_init+0x58/0x1000 [ebtables]
  ...

Fixes: 194730a9beb5 ("net/smc: Make SMC statistics network namespace aware")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Link: https://lore.kernel.org/r/20221101093722.127223-1-chenzhongjin@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 0939cc3b915a..58ff5f33b370 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3380,14 +3380,14 @@ static int __init smc_init(void)
 
 	rc = register_pernet_subsys(&smc_net_stat_ops);
 	if (rc)
-		return rc;
+		goto out_pernet_subsys;
 
 	smc_ism_init();
 	smc_clc_init();
 
 	rc = smc_nl_init();
 	if (rc)
-		goto out_pernet_subsys;
+		goto out_pernet_subsys_stat;
 
 	rc = smc_pnet_init();
 	if (rc)
@@ -3480,6 +3480,8 @@ static int __init smc_init(void)
 	smc_pnet_exit();
 out_nl:
 	smc_nl_exit();
+out_pernet_subsys_stat:
+	unregister_pernet_subsys(&smc_net_stat_ops);
 out_pernet_subsys:
 	unregister_pernet_subsys(&smc_net_ops);
 
-- 
2.35.1



