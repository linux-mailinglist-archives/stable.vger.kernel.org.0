Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF26586870
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiHALsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiHALsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:48:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF9D3718A;
        Mon,  1 Aug 2022 04:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06497B8116B;
        Mon,  1 Aug 2022 11:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521E7C433C1;
        Mon,  1 Aug 2022 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354486;
        bh=5jsYKvFithK8eTXHWGltLi44W3zkQVTfFRkqq2VC5c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzR+FNHfJt72BRrJ0oSDNYyEOK0/IQu3UenVItKOBZdxYoUHeVfL2X6c5FJWYiMlA
         lzpDBAP8u958Y9PzaSBRftXdbxgzJgIpb9+XzbSbioLPMsIWnPq0GUlpDTzf7BkerI
         V9olSd6ZKTnaAf4V3TzZPToS8JG1bH7P9HIHGIB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 13/34] tcp: Fix a data-race around sysctl_tcp_challenge_ack_limit.
Date:   Mon,  1 Aug 2022 13:46:53 +0200
Message-Id: <20220801114128.544074282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -3484,7 +3484,7 @@ static void tcp_send_challenge_ack(struc
 	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != challenge_timestamp) {
-		u32 ack_limit = net->ipv4.sysctl_tcp_challenge_ack_limit;
+		u32 ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 		u32 half = (ack_limit + 1) >> 1;
 
 		challenge_timestamp = now;


