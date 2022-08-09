Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B4358DDA0
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbiHISDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiHISCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9F42611E;
        Tue,  9 Aug 2022 11:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB986102F;
        Tue,  9 Aug 2022 18:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C969BC433C1;
        Tue,  9 Aug 2022 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068088;
        bh=yf73s1TIN7k8z2scu/2o/hJJ1mGHcwXT5PU9UwGww/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGXjXWCGdwsWq4DlmytcsJgXYw2pk8CSYBNnrIRbhWeoYDR1s04velHW5SqiyKL/d
         m6fopfCmMbfc1p7bDYD/teqkw5qL/j1aESN4Mv/Vqaqy7PuphvSRmTCkXEC30Fv43u
         cnRTVp8/RVyPxU1U5O7EQ7R1Ai3xA0apNQp8nEa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/32] tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
Date:   Tue,  9 Aug 2022 20:00:01 +0200
Message-Id: <20220809175513.421710176@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit db3815a2fa691da145cfbe834584f31ad75df9ff upstream.

While reading sysctl_tcp_challenge_ack_limit, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 282f23c6ee34 ("tcp: implement RFC 5961 3.2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3468,7 +3468,7 @@ static void tcp_send_challenge_ack(struc
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;


