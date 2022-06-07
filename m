Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D41454195B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbiFGVVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381542AbiFGVRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF8A14CDC4;
        Tue,  7 Jun 2022 11:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B99FD61787;
        Tue,  7 Jun 2022 18:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADD9C385A2;
        Tue,  7 Jun 2022 18:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628347;
        bh=zHarHNHf1vwJOO2GNoR2a6HsIMrQOlbPbQSMOyTCg1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AshWlgGPIUa22IAuXDmqaFYeF4v23+JpLsHRnKSpLqX9GBgVRdVavNky7C3+6bOMk
         M/NnvWlZJdRLnEzM2bKkSzhZuWbWjsQ2ssk5FrxaCFsulOLCa0WT5q7bCGa0ewyNVw
         suxUayMx3qW4rz4e/tDFiwoJnkOM8r4ubWmG7ZTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 297/879] mptcp: optimize release_cb for the common case
Date:   Tue,  7 Jun 2022 18:56:55 +0200
Message-Id: <20220607165011.467418026@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 65a569b03ca832ebc93ce45a7466137e2bb62254 ]

The mptcp release callback checks several flags in atomic
context, but only MPTCP_CLEAN_UNA can be up frequently.

Reorganize the code to avoid multiple conditionals in the
most common scenarios.

Additional clarify a related comment.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0cbea3b6d0a4..2a9335ce5df1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3092,15 +3092,17 @@ static void mptcp_release_cb(struct sock *sk)
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
 
-	/* be sure to set the current sk state before tacking actions
-	 * depending on sk_state
-	 */
-	if (__test_and_clear_bit(MPTCP_CONNECTED, &msk->cb_flags))
-		__mptcp_set_connected(sk);
 	if (__test_and_clear_bit(MPTCP_CLEAN_UNA, &msk->cb_flags))
 		__mptcp_clean_una_wakeup(sk);
-	if (__test_and_clear_bit(MPTCP_ERROR_REPORT, &msk->cb_flags))
-		__mptcp_error_report(sk);
+	if (unlikely(&msk->cb_flags)) {
+		/* be sure to set the current sk state before tacking actions
+		 * depending on sk_state, that is processing MPTCP_ERROR_REPORT
+		 */
+		if (__test_and_clear_bit(MPTCP_CONNECTED, &msk->cb_flags))
+			__mptcp_set_connected(sk);
+		if (__test_and_clear_bit(MPTCP_ERROR_REPORT, &msk->cb_flags))
+			__mptcp_error_report(sk);
+	}
 
 	__mptcp_update_rmem(sk);
 }
-- 
2.35.1



