Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327614CF84D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbiCGJwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240581AbiCGJvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:51:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4D475C32;
        Mon,  7 Mar 2022 01:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B34ACB80E70;
        Mon,  7 Mar 2022 09:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1533FC36AE7;
        Mon,  7 Mar 2022 09:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646289;
        bh=CuVv0srCJLASUG7O3QLyufLAvEapLieoDVMlDzAxUHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCQCqnuBWzP7+a+JvrmRlcQuF2b89CnKcUZDDK7/l+MFRLBdPY7HU5t4jjZHLfwl2
         97cSFPcsCimdvRuTNI+Oj269jG0nA1nsJC6N9BbcpFH5ioaODUlk0NO22tXsUU1yrN
         cgMr96K4J4LKGv9+CkoDSoqYxwof1AejGGj1WuAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 195/262] mptcp: Correctly set DATA_FIN timeout when number of retransmits is large
Date:   Mon,  7 Mar 2022 10:18:59 +0100
Message-Id: <20220307091708.093390682@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

commit 877d11f0332cd2160e19e3313e262754c321fa36 upstream.

Syzkaller with UBSAN uncovered a scenario where a large number of
DATA_FIN retransmits caused a shift-out-of-bounds in the DATA_FIN
timeout calculation:

================================================================================
UBSAN: shift-out-of-bounds in net/mptcp/protocol.c:470:29
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 1 PID: 13059 Comm: kworker/1:0 Not tainted 5.17.0-rc2-00630-g5fbf21c90c60 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events mptcp_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
 __ubsan_handle_shift_out_of_bounds.cold+0xb2/0x20e lib/ubsan.c:330
 mptcp_set_datafin_timeout net/mptcp/protocol.c:470 [inline]
 __mptcp_retrans.cold+0x72/0x77 net/mptcp/protocol.c:2445
 mptcp_worker+0x58a/0xa70 net/mptcp/protocol.c:2528
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2307
 worker_thread+0x95/0xe10 kernel/workqueue.c:2454
 kthread+0x2f4/0x3b0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
================================================================================

This change limits the maximum timeout by limiting the size of the
shift, which keeps all intermediate values in-bounds.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/259
Fixes: 6477dd39e62c ("mptcp: Retransmit DATA_FIN")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -406,9 +406,12 @@ static bool mptcp_pending_data_fin(struc
 static void mptcp_set_datafin_timeout(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 retransmits;
 
-	mptcp_sk(sk)->timer_ival = min(TCP_RTO_MAX,
-				       TCP_RTO_MIN << icsk->icsk_retransmits);
+	retransmits = min_t(u32, icsk->icsk_retransmits,
+			    ilog2(TCP_RTO_MAX / TCP_RTO_MIN));
+
+	mptcp_sk(sk)->timer_ival = TCP_RTO_MIN << retransmits;
 }
 
 static void __mptcp_set_timeout(struct sock *sk, long tout)


