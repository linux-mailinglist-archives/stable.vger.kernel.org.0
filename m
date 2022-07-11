Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE99756FBB4
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiGKJet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiGKJdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5BE7AC0B;
        Mon, 11 Jul 2022 02:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26DE2B80E74;
        Mon, 11 Jul 2022 09:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EE8C34115;
        Mon, 11 Jul 2022 09:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531080;
        bh=XpgknY7GZkaapSMyf+HiPgrIBtIyDVXS7/RWFf/2jKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGvbGKaxMAGNSCVJiKHJAsXwRM3LhjOvHNw0H1s5iCDufrmfMJvB4tE/Qiofg51xO
         bfRI1m9Z2OK52aQGMLQl0AZYsbqmWtpFE3TF2VxGOAxgL+KeNwNX2pder2zycy+313
         NlAo0sz+8d3mSepSXhC3vAWbqTrNJDZlH0YzANZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 090/112] mptcp: Avoid acquiring PM lock for subflow priority changes
Date:   Mon, 11 Jul 2022 11:07:30 +0200
Message-Id: <20220711090552.125703382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

[ Upstream commit c21b50d5912b68c4414c60ef5b30416c103f9fd8 ]

The in-kernel path manager code for changing subflow flags acquired both
the msk socket lock and the PM lock when possibly changing the "backup"
and "fullmesh" flags. mptcp_pm_nl_mp_prio_send_ack() does not access
anything protected by the PM lock, and it must release and reacquire
the PM lock.

By pushing the PM lock to where it is needed in mptcp_pm_nl_fullmesh(),
the lock is only acquired when the fullmesh flag is changed and the
backup flag code no longer has to release and reacquire the PM lock. The
change in locking context requires the MIB update to be modified - move
that to a better location instead.

This change also makes it possible to call
mptcp_pm_nl_mp_prio_send_ack() for the userspace PM commands without
manipulating the in-kernel PM lock.

Fixes: 0f9f696a502e ("mptcp: add set_flags command in PM netlink")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c    | 3 +++
 net/mptcp/pm_netlink.c | 8 ++------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b548cec86c9d..48e34b81fa1c 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1538,6 +1538,9 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
 				      TCPOLEN_MPTCP_PRIO,
 				      opts->backup, TCPOPT_NOP);
+
+		MPTCP_INC_STATS(sock_net((const struct sock *)tp),
+				MPTCP_MIB_MPPRIOTX);
 	}
 
 mp_capable_done:
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e3dcc5501579..88077ea02ed3 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -720,7 +720,6 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info local;
 
 		local_address((struct sock_common *)ssk, &local);
@@ -732,12 +731,9 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		subflow->backup = bkup;
 		subflow->send_mp_prio = 1;
 		subflow->request_bkup = bkup;
-		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPPRIOTX);
 
-		spin_unlock_bh(&msk->pm.lock);
 		pr_debug("send ack for mp_prio");
 		mptcp_subflow_send_ack(ssk);
-		spin_lock_bh(&msk->pm.lock);
 
 		return 0;
 	}
@@ -1769,8 +1765,10 @@ static void mptcp_pm_nl_fullmesh(struct mptcp_sock *msk,
 
 	list.ids[list.nr++] = addr->id;
 
+	spin_lock_bh(&msk->pm.lock);
 	mptcp_pm_nl_rm_subflow_received(msk, &list);
 	mptcp_pm_create_subflow_or_signal_addr(msk);
+	spin_unlock_bh(&msk->pm.lock);
 }
 
 static int mptcp_nl_set_flags(struct net *net,
@@ -1788,12 +1786,10 @@ static int mptcp_nl_set_flags(struct net *net,
 			goto next;
 
 		lock_sock(sk);
-		spin_lock_bh(&msk->pm.lock);
 		if (changed & MPTCP_PM_ADDR_FLAG_BACKUP)
 			ret = mptcp_pm_nl_mp_prio_send_ack(msk, addr, bkup);
 		if (changed & MPTCP_PM_ADDR_FLAG_FULLMESH)
 			mptcp_pm_nl_fullmesh(msk, addr);
-		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 
 next:
-- 
2.35.1



