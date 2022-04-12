Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ACD4FD951
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377648AbiDLHvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359266AbiDLHmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CD82CE17;
        Tue, 12 Apr 2022 00:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C78CB81B60;
        Tue, 12 Apr 2022 07:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B428CC385A1;
        Tue, 12 Apr 2022 07:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748091;
        bh=a4WlgdswZu7LbTJK3BT3VYBsUoQBdktmcSJKsA6vEkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6qx3eOvwN/AT4Pi6j7362RR+kWjFZmyUkoTNiXsTwMabYNUwMmu3FiDF4jwQa4Jj
         mHvxzqNnAkuEYLlgScckru9J1/0Px8Xf/OcFv5hdT2S0ubu7G/KiAHazxTVWVf/y2K
         NuKJPwOECn8sshW5uD6C1AUV0kYU6FcxzgPEfccE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 315/343] net/smc: send directly on setting TCP_NODELAY
Date:   Tue, 12 Apr 2022 08:32:13 +0200
Message-Id: <20220412063000.414743238@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dust Li <dust.li@linux.alibaba.com>

commit b70a5cc045197aad9c159042621baf3c015f6cc7 upstream.

In commit ea785a1a573b("net/smc: Send directly when
TCP_CORK is cleared"), we don't use delayed work
to implement cork.

This patch use the same algorithm, removes the
delayed work when setting TCP_NODELAY and send
directly in setsockopt(). This also makes the
TCP_NODELAY the same as TCP.

Cc: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2625,8 +2625,8 @@ static int smc_setsockopt(struct socket
 		    sk->sk_state != SMC_CLOSED) {
 			if (val) {
 				SMC_STAT_INC(smc, ndly_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;


