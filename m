Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E2F4F2E75
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiDEI02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A76D888DF;
        Tue,  5 Apr 2022 01:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BC6CB81B90;
        Tue,  5 Apr 2022 08:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71146C385A0;
        Tue,  5 Apr 2022 08:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146277;
        bh=pfUa9LayJvonNRTRyNr0npSc/ylo332Q3BdAw9/BZgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq5+Lu5szxEPbrDx83fb1C2GFBLa0qVmcE/H/23nK212B2F1hHm3oVcM1+4lA3MXQ
         h7AcJAz78AYKmUFUE62ihdUWyC4/aekOX0fuLu93RHXiTiwnBNEM6Hvk45MXfYZFBL
         MqAFL4RqdyH3FzHhXok4cSyks+aTvkOwKGeZYLbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0705/1126] tipc: fix the timer expires after interval 100ms
Date:   Tue,  5 Apr 2022 09:24:12 +0200
Message-Id: <20220405070428.297227258@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 6a7d8cff4a3301087dd139293e9bddcf63827282 ]

In the timer callback function tipc_sk_timeout(), we're trying to
reschedule another timeout to retransmit a setup request if destination
link is congested. But we use the incorrect timeout value
(msecs_to_jiffies(100)) instead of (jiffies + msecs_to_jiffies(100)),
so that the timer expires immediately, it's irrelevant for original
description.

In this commit we correct the timeout value in sk_reset_timer()

Fixes: 6787927475e5 ("tipc: buffer overflow handling in listener socket")
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Link: https://lore.kernel.org/r/20220321042229.314288-1-hoang.h.le@dektech.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 7545321c3440..17f8c523e33b 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2852,7 +2852,8 @@ static void tipc_sk_retry_connect(struct sock *sk, struct sk_buff_head *list)
 
 	/* Try again later if dest link is congested */
 	if (tsk->cong_link_cnt) {
-		sk_reset_timer(sk, &sk->sk_timer, msecs_to_jiffies(100));
+		sk_reset_timer(sk, &sk->sk_timer,
+			       jiffies + msecs_to_jiffies(100));
 		return;
 	}
 	/* Prepare SYN for retransmit */
-- 
2.34.1



