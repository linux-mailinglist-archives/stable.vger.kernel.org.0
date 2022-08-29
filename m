Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885435A48A5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiH2LN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiH2LMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532B16554A;
        Mon, 29 Aug 2022 04:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3DE9611F4;
        Mon, 29 Aug 2022 11:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86C4C433C1;
        Mon, 29 Aug 2022 11:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771344;
        bh=e6jU/oDtwcagn6dm5aEppzvyyz5CM20HP0DYHvgaJ9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIxUk7ndpFVlODfJrkWZQnI1WvF2Ro4DE59/5/Kk54gOfta1BjY0b6EEamrIIn6w2
         Sik9mpHmf3tZ9w8aHJaT1wGn+DeramaNkSCGteLL0W5HSNCqI/ZkGjT+n6DZg3O+SH
         Rb42IpAmXFXzysD85HVCmMC6kgBEF7NVq4OjlnXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/86] net: Fix a data-race around sysctl_tstamp_allow_data.
Date:   Mon, 29 Aug 2022 12:59:19 +0200
Message-Id: <20220829105758.708346127@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index 48b6438f2a3d9..635cabcf8794f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4691,7 +4691,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
-- 
2.35.1



