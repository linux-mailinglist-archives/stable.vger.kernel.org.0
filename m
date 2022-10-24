Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0257660B9A0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiJXUQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiJXUO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:14:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70148EACB9;
        Mon, 24 Oct 2022 11:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7C320CE1346;
        Mon, 24 Oct 2022 11:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5814BC433D6;
        Mon, 24 Oct 2022 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612173;
        bh=ksz5cn29JcW54iRPWf1XJ2b6P5WFBFylJ5K12NnaA9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuBqj0G2CvBZRt00SeSicYs1PUYHRDqK53BxqrP6kjfQLgE03wlIHYCJ2nsLbyfDv
         lzzMwf+SdrhTZLQVo/OcePc8BIuAdUuMeCooBgD650r7pdVmlMp5S1EsaP0RBPmIi5
         k2uGAnf9cZsGeAKjNh/ehCPgnKwUVd5KZXbbAqbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/210] net: rds: dont hold sock lock when cancelling work from rds_tcp_reset_callbacks()
Date:   Mon, 24 Oct 2022 13:30:13 +0200
Message-Id: <20221024113000.140983339@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit a91b750fd6629354460282bbf5146c01b05c4859 ]

syzbot is reporting lockdep warning at rds_tcp_reset_callbacks() [1], for
commit ac3615e7f3cffe2a ("RDS: TCP: Reduce code duplication in
rds_tcp_reset_callbacks()") added cancel_delayed_work_sync() into a section
protected by lock_sock() without realizing that rds_send_xmit() might call
lock_sock().

We don't need to protect cancel_delayed_work_sync() using lock_sock(), for
even if rds_{send,recv}_worker() re-queued this work while __flush_work()
 from cancel_delayed_work_sync() was waiting for this work to complete,
retried rds_{send,recv}_worker() is no-op due to the absence of RDS_CONN_UP
bit.

Link: https://syzkaller.appspot.com/bug?extid=78c55c7bc6f66e53dce2 [1]
Reported-by: syzbot <syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com>
Co-developed-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com>
Fixes: ac3615e7f3cffe2a ("RDS: TCP: Reduce code duplication in rds_tcp_reset_callbacks()")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 55bae71bf339..ae4901933e6d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -162,10 +162,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 */
 	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
 	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
-	lock_sock(osock->sk);
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
 	cancel_delayed_work_sync(&cp->cp_recv_w);
+	lock_sock(osock->sk);
 	if (tc->t_tinc) {
 		rds_inc_put(&tc->t_tinc->ti_inc);
 		tc->t_tinc = NULL;
-- 
2.35.1



