Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9407D53178A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbiEWRdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241119AbiEWR0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074B62BFE;
        Mon, 23 May 2022 10:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA4ECB811FE;
        Mon, 23 May 2022 17:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426FBC385A9;
        Mon, 23 May 2022 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326484;
        bh=0iVyKruOZKZjO3IhGdC9lrTMP16QOLq3mphVI4fNs+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dom9oQCmldkjKRsjZJdtbQSYXdPssJbQFAek8mhP+AdHCgoluzNgcKtun4yvV1WNo
         gwmGyJKZXJItavWpwU3/5u58ZL5GARh7sQwD4C+MgdLBG5pX+UkjQ+/CKu2YGupiZB
         r/5YcwTVZMXsjQzu3HryugU/V9dCp1rdiGDxa1Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/132] mptcp: change the parameter of __mptcp_make_csum
Date:   Mon, 23 May 2022 19:05:04 +0200
Message-Id: <20220523165839.111088948@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit c312ee219100e86143a1d3cc10b367bc43a0e0b8 ]

This patch changed the type of the last parameter of __mptcp_make_csum()
from __sum16 to __wsum. And export this function in protocol.h.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 8 ++++----
 net/mptcp/protocol.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e515ba9ccb5d..d158f53d3bc3 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1214,7 +1214,7 @@ static void mptcp_set_rwin(const struct tcp_sock *tp)
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
-static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum16 sum)
+u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 {
 	struct csum_pseudo_header header;
 	__wsum csum;
@@ -1229,14 +1229,14 @@ static u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __sum1
 	header.data_len = htons(data_len);
 	header.csum = 0;
 
-	csum = csum_partial(&header, sizeof(header), ~csum_unfold(sum));
+	csum = csum_partial(&header, sizeof(header), sum);
 	return (__force u16)csum_fold(csum);
 }
 
 static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
 {
 	return __mptcp_make_csum(mpext->data_seq, mpext->subflow_seq, mpext->data_len,
-				 mpext->csum);
+				 ~csum_unfold(mpext->csum));
 }
 
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
@@ -1368,7 +1368,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 					   __mptcp_make_csum(opts->data_seq,
 							     opts->subflow_seq,
 							     opts->data_len,
-							     opts->csum), ptr);
+							     ~csum_unfold(opts->csum)), ptr);
 		} else {
 			put_unaligned_be32(opts->data_len << 16 |
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 82c5dc4d6b49..6bcdaf01f483 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -718,6 +718,7 @@ void mptcp_token_destroy(struct mptcp_sock *msk);
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
+u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
-- 
2.35.1



