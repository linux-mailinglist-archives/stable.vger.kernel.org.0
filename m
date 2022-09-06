Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E895AE9E3
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbiIFNg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240725AbiIFNfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9267647A;
        Tue,  6 Sep 2022 06:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B06AB8162F;
        Tue,  6 Sep 2022 13:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6361C433C1;
        Tue,  6 Sep 2022 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471250;
        bh=DN65y0+/J8uvp6T4PDh7gjmmWeRoYezdsHkqbInMSDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vr9m17lMsGtBL9Rfe6XcWTQDRqJDI+chUtJ9Xx5svjGSRgOuIMl+0HgtLMjB2+VSR
         F8A/RSlgcxrxfHAWi/jDBHI6DBf3wG3jyUpKK5HjVyqyru89orvmXW5zCzEJ8wfLXa
         tao8HSqEd9JiVVvnDhcB7RyYyvFJajdCCgXFmni4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yacan Liu <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/80] net/smc: Remove redundant refcount increase
Date:   Tue,  6 Sep 2022 15:30:17 +0200
Message-Id: <20220906132817.801471342@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
index 5d7710dd95145..41cbc7c89c9d2 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1325,7 +1325,6 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
 {
 	struct sock *newsmcsk = &new_smc->sk;
 
-	sk_refcnt_debug_inc(newsmcsk);
 	if (newsmcsk->sk_state == SMC_INIT)
 		newsmcsk->sk_state = SMC_ACTIVE;
 
-- 
2.35.1



