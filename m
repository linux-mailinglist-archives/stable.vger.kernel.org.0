Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA751A79B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355319AbiEDRGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356301AbiEDRFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D42450B38;
        Wed,  4 May 2022 09:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC9A6B82792;
        Wed,  4 May 2022 16:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B48DC385B1;
        Wed,  4 May 2022 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683240;
        bh=SNx83Pbjpg0ZcHfND6i5kAbdpaRsicsaY11CcJYsxrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQOTU3yiqAwjDfSOOJGBpZIe/0dNWRqGS+gqrdXzcKSB7F5DCqvJYEFjbtLZRmz13
         DoV+NptLRA+rWfInli9Rj9YZOjV10rHJ+2rctrXhhYGxPgMmew2YNUn8Sw5NJPWly+
         LrLLNNVQl+irVwnonR/PhcdOG3CsJkB2ou31/6c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyacan <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/177] net/smc: sync err code when tcp connection was refused
Date:   Wed,  4 May 2022 18:44:50 +0200
Message-Id: <20220504153101.812740917@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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
index 499058248bdb..fb801c249d92 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1223,6 +1223,8 @@ static void smc_connect_work(struct work_struct *work)
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



