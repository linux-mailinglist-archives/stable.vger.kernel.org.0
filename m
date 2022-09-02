Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549A25AAEF1
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiIBMcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiIBMbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5197DD4F2;
        Fri,  2 Sep 2022 05:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB5AB82A9D;
        Fri,  2 Sep 2022 12:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64127C433D7;
        Fri,  2 Sep 2022 12:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121483;
        bh=CROEDo68RWPkTAbO5thz1/SfBjbZ4MSLhLylUDNIiPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgMJTOfMh1vqRaI8Io8PQdoD/JkAlUFyxKb+2yc5gnYCCzPzR/p+U5grrlE4IkfsB
         wOgJgSHLXObvg3tTuULeBtFc3Ym8LQcghmjs4hNn1ovcwAh5+RSHmXEIB0VXGUrrv2
         aGbJKuCw2uxpC6HR1x/Pde7RpojNx+UGdWV+m58I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/56] net: Fix a data-race around sysctl_tstamp_allow_data.
Date:   Fri,  2 Sep 2022 14:18:42 +0200
Message-Id: <20220902121400.952264237@linuxfoundation.org>
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

[ Upstream commit d2154b0afa73c0159b2856f875c6b4fe7cf6a95e ]

While reading sysctl_tstamp_allow_data, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: b245be1f4db1 ("net-timestamp: no-payload only sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c623c129d0ab6..e0be1f8651bbe 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4377,7 +4377,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
-- 
2.35.1



