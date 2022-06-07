Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3C5412F6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357429AbiFGTzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358728AbiFGTxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B6A17A86;
        Tue,  7 Jun 2022 11:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23826B82349;
        Tue,  7 Jun 2022 18:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BABC385A5;
        Tue,  7 Jun 2022 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626134;
        bh=V+p0Th3xWGbUtPtgSLGdfLKHai+s7Y4QJdrTov6I7sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxyzWXtHly3uBQY6QwafIZIcqOIgDMQpJbRhqLpiq0u5qPn/ZzYSMInmtbq2ElOQJ
         yCXZyGeh6kvr4n409gMh5nB1DvuSLpeuOh+qKl5RKmlsSA6KDBTZrbsG+WvVuJtj6N
         GMtQOeDtk9/jlHVGS5sFknefxERLKUcs2XiszQM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 253/772] mptcp: optimize release_cb for the common case
Date:   Tue,  7 Jun 2022 18:57:25 +0200
Message-Id: <20220607164956.480643936@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 014c9d88f947..7e8083d6f033 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3088,15 +3088,17 @@ static void mptcp_release_cb(struct sock *sk)
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



