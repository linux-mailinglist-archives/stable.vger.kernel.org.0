Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3137C5B741D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiIMPOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiIMPME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:12:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D07A642F2;
        Tue, 13 Sep 2022 07:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B94F6614D8;
        Tue, 13 Sep 2022 14:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D6EC433D6;
        Tue, 13 Sep 2022 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079145;
        bh=UsLo/m/9Zwu++JQfRrBlmETDoRxcxmLV5YPwt9W2c1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxT0j+vHilSCKyiSsC9zIclrecmF6auVParM4IC+Vcsv5pMzg79tvwstfThD6WYGB
         WlI3STCeEnhg5J4VwR8spMG8naXid0SyQWQnMGmb03TXk12qx5IeoV0FNcUeN6zmZs
         vRQuF3aC3xTQTAbWJ20952rsfsj7S6WzRDoRX5eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yacan Liu <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/108] net/smc: Remove redundant refcount increase
Date:   Tue, 13 Sep 2022 16:05:51 +0200
Message-Id: <20220913140354.470992200@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yacan Liu <liuyacan@corp.netease.com>

[ Upstream commit a8424a9b4522a3ab9f32175ad6d848739079071f ]

For passive connections, the refcount increment has been done in
smc_clcsock_accept()-->smc_sock_alloc().

Fixes: 3b2dec2603d5 ("net/smc: restructure client and server code in af_smc")
Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220830152314.838736-1-liuyacan@corp.netease.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 394491692a078..5d696b7fb47e1 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1093,7 +1093,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
-	sk_refcnt_debug_inc(newsmcsk);
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 
-- 
2.35.1



