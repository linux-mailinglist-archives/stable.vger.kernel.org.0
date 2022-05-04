Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5EE51A8D1
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354805AbiEDRNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355684AbiEDRKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACF44B1CC;
        Wed,  4 May 2022 09:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 143F5B8279C;
        Wed,  4 May 2022 16:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A503CC385AA;
        Wed,  4 May 2022 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683439;
        bh=jhyR9RXkZ2+e+QzykSGU0mZlLp+bE0xng8lr5Et+poA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnEXA8VMlggDPCvuDPbtSwVidtmbbFNd4nGs7/l5ZySA1sxU2f814dlG6Yc+rOZ1W
         gd+Q05wSyrtspIOtagQCrlM/G/sgzz/6OciMc7fuxFWJWPmxR3253pKlrhkUl41WZA
         RijnNYpod6o0iH1pJsLspm7lrtnnoda/b78Sv5s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 119/225] net/smc: sync err code when tcp connection was refused
Date:   Wed,  4 May 2022 18:45:57 +0200
Message-Id: <20220504153121.118828571@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

[ Upstream commit 4e2e65e2e56c6ceb4ea1719360080c0af083229e ]

In the current implementation, when TCP initiates a connection
to an unavailable [ip,port], ECONNREFUSED will be stored in the
TCP socket, but SMC will not. However, some apps (like curl) use
getsockopt(,,SO_ERROR,,) to get the error information, which makes
them miss the error message and behave strangely.

Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 68cd110722a4..fd9d9cfd0f3d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1357,6 +1357,8 @@ static void smc_connect_work(struct work_struct *work)
 		smc->sk.sk_state = SMC_CLOSED;
 		if (rc == -EPIPE || rc == -EAGAIN)
 			smc->sk.sk_err = EPIPE;
+		else if (rc == -ECONNREFUSED)
+			smc->sk.sk_err = ECONNREFUSED;
 		else if (signal_pending(current))
 			smc->sk.sk_err = -sock_intr_errno(timeo);
 		sock_put(&smc->sk); /* passive closing */
-- 
2.35.1



