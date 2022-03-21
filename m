Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6082B4E292C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344786AbiCUOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348591AbiCUOBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:01:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073559AE6F;
        Mon, 21 Mar 2022 06:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8700B816D9;
        Mon, 21 Mar 2022 13:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39791C340E8;
        Mon, 21 Mar 2022 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871151;
        bh=y8A8duvnQBc5gtrsNqlLqi4iN3RL7tqC4SsOZNQfcrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o46Ee6V/VFJgIlCoDcJRQUa8UX1LswfFcCMDVzh3WnNBFnxHxDlCFRTu+hVjsriAx
         nzKIbKt5nhN2zSsK9b7N7dDIXLgcQs2WcdF6Doiba43a5AVjpxLuxy4SVv0iqQqpi0
         4Z9k8T9C1ek5Bz/rsE0gJgLnBSQ/wxQKR1ZZR1bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/30] esp6: fix check on ipv6_skip_exthdrs return value
Date:   Mon, 21 Mar 2022 14:52:36 +0100
Message-Id: <20220321133219.832569425@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 4db4075f92af2b28f415fc979ab626e6b37d67b6 ]

Commit 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
introduced an incorrect check, which leads to all ESP packets over
either TCPv6 or UDPv6 encapsulation being dropped. In this particular
case, offset is negative, since skb->data points to the ESP header in
the following chain of headers, while skb->network_header points to
the IPv6 header:

    IPv6 | ext | ... | ext | UDP | ESP | ...

That doesn't seem to be a problem, especially considering that if we
reach esp6_input_done2, we're guaranteed to have a full set of headers
available (otherwise the packet would have been dropped earlier in the
stack). However, it means that the return value will (intentionally)
be negative. We can make the test more specific, as the expected
return value of ipv6_skip_exthdr will be the (negated) size of either
a UDP header, or a TCP header with possible options.

In the future, we should probably either make ipv6_skip_exthdr
explicitly accept negative offsets (and adjust its return value for
error cases), or make ipv6_skip_exthdr only take non-negative
offsets (and audit all callers).

Fixes: 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/esp6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index fc8acb15dcfb..5ce8b6c344b8 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -808,8 +808,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
-
-		if (offset < 0) {
+		if (offset == -1) {
 			err = -EINVAL;
 			goto out;
 		}
-- 
2.34.1



