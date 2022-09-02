Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020115AB225
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiIBNwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiIBNvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6BAC12E1;
        Fri,  2 Sep 2022 06:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A55F9B829B6;
        Fri,  2 Sep 2022 12:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC9C433D6;
        Fri,  2 Sep 2022 12:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121776;
        bh=gdQ/KPd8CRekFKLKlOAVuXZbutNkpThhu5T6EwGvljg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeDybXvKbhG4/IKgYCw0SxZp925A7hDJOvLGaR1tDIsukLZNkK7PVeAaWpv3424cv
         Nb3nfI0ZLPhZoXp1dlLu/MfTv/Xcq6fFf/l8Iyaya3AqjMJ1nhnrQP+lFgGfBWyTWh
         hgKcw2J+22BSynalx88FhpzeefW2HixjKyfPgyIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/77] net: Fix a data-race around sysctl_net_busy_poll.
Date:   Fri,  2 Sep 2022 14:18:39 +0200
Message-Id: <20220902121404.640131055@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c42b7cddea47503411bfb5f2f93a4154aaffa2d9 ]

While reading sysctl_net_busy_poll, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 060212928670 ("net: add low latency socket poll")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 9899b9af7f22f..16258c0c7319e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -31,7 +31,7 @@ extern unsigned int sysctl_net_busy_poll __read_mostly;
 
 static inline bool net_busy_loop_on(void)
 {
-	return sysctl_net_busy_poll;
+	return READ_ONCE(sysctl_net_busy_poll);
 }
 
 static inline bool sk_can_busy_loop(const struct sock *sk)
-- 
2.35.1



