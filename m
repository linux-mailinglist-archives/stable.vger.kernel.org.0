Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145E26159BC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKBDR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKBDQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:16:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA3E23E9E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8165B8206F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F2C433D6;
        Wed,  2 Nov 2022 03:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359007;
        bh=HAq7WNkgyq4T5KmI1MAHg3YNXO9bZbCQdtwvRP5KjA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud4xl1bSu5SSikTbT+JjAM3kEjiY+ykq1V6HbWmkaumVCWCBZHLWklZ3O5TtZOXq8
         pAq1EbgrXROt/x3Cm+NN/kk/b/s8lrQQSiXi98bhxG1AkFRvvSeCxXDuv7IQis7gfs
         rFVmm1R7J/IjCBdRkzD/AbWcUVRGccku5pjhP6iU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Neil Spring <ntspring@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/91] tcp: fix indefinite deferral of RTO with SACK reneging
Date:   Wed,  2 Nov 2022 03:33:43 +0100
Message-Id: <20221102022056.733993816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 3d2af9cce3133b3bc596a9d065c6f9d93419ccfb ]

This commit fixes a bug that can cause a TCP data sender to repeatedly
defer RTOs when encountering SACK reneging.

The bug is that when we're in fast recovery in a scenario with SACK
reneging, every time we get an ACK we call tcp_check_sack_reneging()
and it can note the apparent SACK reneging and rearm the RTO timer for
srtt/2 into the future. In some SACK reneging scenarios that can
happen repeatedly until the receive window fills up, at which point
the sender can't send any more, the ACKs stop arriving, and the RTO
fires at srtt/2 after the last ACK. But that can take far too long
(O(10 secs)), since the connection is stuck in fast recovery with a
low cwnd that cannot grow beyond ssthresh, even if more bandwidth is
available.

This fix changes the logic in tcp_check_sack_reneging() to only rearm
the RTO timer if data is cumulatively ACKed, indicating forward
progress. This avoids this kind of nearly infinite loop of RTO timer
re-arming. In addition, this meets the goals of
tcp_check_sack_reneging() in handling Windows TCP behavior that looks
temporarily like SACK reneging but is not really.

Many thanks to Jakub Kicinski and Neil Spring, who reported this issue
and provided critical packet traces that enabled root-causing this
issue. Also, many thanks to Jakub Kicinski for testing this fix.

Fixes: 5ae344c949e7 ("tcp: reduce spurious retransmits due to transient SACK reneging")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Neil Spring <ntspring@fb.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Tested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20221021170821.1093930-1-ncardwell.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 377cba9b124d..541758cd0b81 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2175,7 +2175,8 @@ void tcp_enter_loss(struct sock *sk)
  */
 static bool tcp_check_sack_reneging(struct sock *sk, int flag)
 {
-	if (flag & FLAG_SACK_RENEGING) {
+	if (flag & FLAG_SACK_RENEGING &&
+	    flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
-- 
2.35.1



