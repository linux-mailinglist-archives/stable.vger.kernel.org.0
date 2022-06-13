Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F3D548BCD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352532AbiFMLSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353663AbiFMLQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F84838BDA;
        Mon, 13 Jun 2022 03:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C035BB80EAC;
        Mon, 13 Jun 2022 10:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F280C34114;
        Mon, 13 Jun 2022 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116727;
        bh=nKTfZeuLrKxdwEf0gmHdzEbNZIZRCIXzPoBOQmXgezQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oM/4zx8QCZMSmjpnsChN2JxW+JSb6AKW5jhzwZLAuL4hbJgfMTo/usiQ7i/efkiHi
         hC5gnbFDiN5VBECGWvf2DXnSRJoShFLKobrg+hNm0AeJdIwo7etfNKyGqsg1DUiXjD
         wJOX3jTjPdGruODPcYH2m3hTfDz5RlBkLsWrb1xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/411] net/smc: postpone sk_refcnt increment in connect()
Date:   Mon, 13 Jun 2022 12:07:08 +0200
Message-Id: <20220613094933.311476944@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 75c1edf23b95a9c66923d9269d8e86e4dbde151f ]

Same trigger condition as commit 86434744. When setsockopt runs
in parallel to a connect(), and switch the socket into fallback
mode. Then the sk_refcnt is incremented in smc_connect(), but
its state stay in SMC_INIT (NOT SMC_ACTIVE). This cause the
corresponding sk_refcnt decrement in __smc_release() will not be
performed.

Fixes: 86434744fedf ("net/smc: add fallback check to connect()")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a5a8cca46bd5..394491692a07 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -877,9 +877,9 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	if (rc && rc != -EINPROGRESS)
 		goto out;
 
-	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (smc->use_fallback)
 		goto out;
+	sock_hold(&smc->sk); /* sock put in passive closing */
 	if (flags & O_NONBLOCK) {
 		if (schedule_work(&smc->connect_work))
 			smc->connect_nonblock = 1;
-- 
2.35.1



