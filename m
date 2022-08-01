Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DBC586996
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiHAMEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiHAMD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:03:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B5E564D0;
        Mon,  1 Aug 2022 04:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 380F7CE13B7;
        Mon,  1 Aug 2022 11:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523DCC433C1;
        Mon,  1 Aug 2022 11:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354844;
        bh=ziqicCsea5B75YRiC2OEkfLuiwaFogjBcZw/uSfQRaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLQxaosEvqvHqKXyrXkPPSOCVvc+smuq+DroSsWk7Br5iN2wXtddOYnc7RBZKfo79
         WdAL5cSAzIAR2VTuRYT3i3RnmUeD5SmUJxAzIujDrtC/DEfVDq6iaEcflpqBVi6YRl
         jWxmUk5XkSyoCPG2rpb4PRnuJ42tjZGg6In835BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/69] tcp: Fix a data-race around sysctl_tcp_invalid_ratelimit.
Date:   Mon,  1 Aug 2022 13:47:03 +0200
Message-Id: <20220801114136.061639478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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

[ Upstream commit 2afdbe7b8de84c28e219073a6661080e1b3ded48 ]

While reading sysctl_tcp_invalid_ratelimit, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 032ee4236954 ("tcp: helpers to mitigate ACK loops by rate-limiting out-of-window dupacks")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b925c766f1d2..018be3f346e6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3574,7 +3574,8 @@ static bool __tcp_oow_rate_limited(struct net *net, int mib_idx,
 	if (*last_oow_ack_time) {
 		s32 elapsed = (s32)(tcp_jiffies32 - *last_oow_ack_time);
 
-		if (0 <= elapsed && elapsed < net->ipv4.sysctl_tcp_invalid_ratelimit) {
+		if (0 <= elapsed &&
+		    elapsed < READ_ONCE(net->ipv4.sysctl_tcp_invalid_ratelimit)) {
 			NET_INC_STATS(net, mib_idx);
 			return true;	/* rate-limited: don't send yet! */
 		}
-- 
2.35.1



