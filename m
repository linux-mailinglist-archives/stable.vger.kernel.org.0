Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B7060A747
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiJXMsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiJXMpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3E11CFD3;
        Mon, 24 Oct 2022 05:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987EB612BB;
        Mon, 24 Oct 2022 12:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75BEC433C1;
        Mon, 24 Oct 2022 12:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613298;
        bh=Nlr3whkKSXmBdqljoxTbdkcPVBXygdd7SJC2WUfTS7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPT7XOp5Kx0FCjiLeTtF4grtwhlZrNeULLDXK+3KexK7VL4XB46ASekto2jvRQ4Hu
         /ptMeCOp1LyIch7Ok4nRrddaabgt9QoxJ3+9BRsq3uV1t0GE7QqkPwEUwGqTFlz4Xe
         VZitWP/vs8ed5qRJUNvXy8vwkwG3ktBmFtrac3IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+78c55c7bc6f66e53dce2@syzkaller.appspotmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/255] net: rds: dont hold sock lock when cancelling work from rds_tcp_reset_callbacks()
Date:   Mon, 24 Oct 2022 13:29:53 +0200
Message-Id: <20221024113005.267727463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index d55d81b01d37..bfb8d4d6a994 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -176,10 +176,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
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



