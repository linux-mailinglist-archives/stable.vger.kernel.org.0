Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D853F5AAF15
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbiIBMdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbiIBMbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66FAE1919;
        Fri,  2 Sep 2022 05:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC03FB82A9B;
        Fri,  2 Sep 2022 12:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297AAC433C1;
        Fri,  2 Sep 2022 12:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121610;
        bh=dKNrh2jkJVvrCoEqs/AeEQ2un8Qz/MAYe710h9ewEAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkY4MiywBVNPBObJlJ6nv+uXJrJ1Fzvq0UHuezMa8voMhGW41m3xljbP/AFhCVgK5
         gfb+acNwvk9Uzx81CiFIIGRdBX+6Lsku+qfKq25S97ltMYHn87/1bsMpT8nj+jSOwE
         kQknIkMkPqogtqSQ9yQKBIo/bTO68X0YYJRXjwyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/56] net: Fix a data-race around netdev_budget_usecs.
Date:   Fri,  2 Sep 2022 14:18:46 +0200
Message-Id: <20220902121401.118095124@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit fa45d484c52c73f79db2c23b0cdfc6c6455093ad ]

While reading netdev_budget_usecs, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c93068ea2e4f2..880b096eef8a6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6335,7 +6335,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(netdev_budget_usecs);
+		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
-- 
2.35.1



