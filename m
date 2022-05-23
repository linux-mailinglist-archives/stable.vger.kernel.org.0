Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2BC5319B7
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbiEWR2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbiEWR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7C975200;
        Mon, 23 May 2022 10:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E55061149;
        Mon, 23 May 2022 17:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A84C385A9;
        Mon, 23 May 2022 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326491;
        bh=b1f3Xs/RdsG4s/2l3MGwmQkavIui4Nkfu8c/7GVi37E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssi+FhIjAkuhXZzVCT2HFfNJ5TSsVPknWN5kYpnbx7rI7vrIbSQHw57ECxee00lje
         e0yZuOWsHQvvY2ChT0h/Oih/LEGd3VeiQTSHJePviOkMg1+C48aMYW3Icu1T5EJHWP
         8ndljjV82m0lpekL7QJP/1ZtLhtEI5E2VSa1SPrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/132] mptcp: fix checksum byte order
Date:   Mon, 23 May 2022 19:05:06 +0200
Message-Id: <20220523165839.452698115@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ba2c89e0ea74a904d5231643245753d77422e7f5 ]

The MPTCP code typecasts the checksum value to u16 and
then converts it to big endian while storing the value into
the MPTCP option.

As a result, the wire encoding for little endian host is
wrong, and that causes interoperabilty interoperability
issues with other implementation or host with different endianness.

Address the issue writing in the packet the unmodified __sum16 value.

MPTCP checksum is disabled by default, interoperating with systems
with bad mptcp-level csum encoding should cause fallback to TCP.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/275
Fixes: c5b39e26d003 ("mptcp: send out checksum for DSS")
Fixes: 390b95a5fb84 ("mptcp: receive checksum for DSS")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 36 ++++++++++++++++++++++++------------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  |  2 +-
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index d158f53d3bc3..193f0fcce8d8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -107,7 +107,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			ptr += 2;
 		}
 		if (opsize == TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM) {
-			mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+			mp_opt->csum = get_unaligned((__force __sum16 *)ptr);
 			mp_opt->suboptions |= OPTION_MPTCP_CSUMREQD;
 			ptr += 2;
 		}
@@ -221,7 +221,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 			if (opsize == expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM) {
 				mp_opt->suboptions |= OPTION_MPTCP_CSUMREQD;
-				mp_opt->csum = (__force __sum16)get_unaligned_be16(ptr);
+				mp_opt->csum = get_unaligned((__force __sum16 *)ptr);
 				ptr += 2;
 			}
 
@@ -1214,7 +1214,7 @@ static void mptcp_set_rwin(const struct tcp_sock *tp)
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 }
 
-u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
+__sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 {
 	struct csum_pseudo_header header;
 	__wsum csum;
@@ -1230,15 +1230,25 @@ u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum)
 	header.csum = 0;
 
 	csum = csum_partial(&header, sizeof(header), sum);
-	return (__force u16)csum_fold(csum);
+	return csum_fold(csum);
 }
 
-static u16 mptcp_make_csum(const struct mptcp_ext *mpext)
+static __sum16 mptcp_make_csum(const struct mptcp_ext *mpext)
 {
 	return __mptcp_make_csum(mpext->data_seq, mpext->subflow_seq, mpext->data_len,
 				 ~csum_unfold(mpext->csum));
 }
 
+static void put_len_csum(u16 len, __sum16 csum, void *data)
+{
+	__sum16 *sumptr = data + 2;
+	__be16 *ptr = data;
+
+	put_unaligned_be16(len, ptr);
+
+	put_unaligned(csum, sumptr);
+}
+
 void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			 struct mptcp_out_options *opts)
 {
@@ -1315,8 +1325,9 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			put_unaligned_be32(mpext->subflow_seq, ptr);
 			ptr += 1;
 			if (opts->csum_reqd) {
-				put_unaligned_be32(mpext->data_len << 16 |
-						   mptcp_make_csum(mpext), ptr);
+				put_len_csum(mpext->data_len,
+					     mptcp_make_csum(mpext),
+					     ptr);
 			} else {
 				put_unaligned_be32(mpext->data_len << 16 |
 						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
@@ -1364,11 +1375,12 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 			goto mp_capable_done;
 
 		if (opts->csum_reqd) {
-			put_unaligned_be32(opts->data_len << 16 |
-					   __mptcp_make_csum(opts->data_seq,
-							     opts->subflow_seq,
-							     opts->data_len,
-							     ~csum_unfold(opts->csum)), ptr);
+			put_len_csum(opts->data_len,
+				     __mptcp_make_csum(opts->data_seq,
+						       opts->subflow_seq,
+						       opts->data_len,
+						       ~csum_unfold(opts->csum)),
+				     ptr);
 		} else {
 			put_unaligned_be32(opts->data_len << 16 |
 					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6bcdaf01f483..72a259a74b57 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -718,7 +718,7 @@ void mptcp_token_destroy(struct mptcp_sock *msk);
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
 
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
-u16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
+__sum16 __mptcp_make_csum(u64 data_seq, u32 subflow_seq, u16 data_len, __wsum sum);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 04afead7316f..9c7deffe7cb6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -846,7 +846,7 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	u32 offset, seq, delta;
-	u16 csum;
+	__sum16 csum;
 	int len;
 
 	if (!csum_reqd)
-- 
2.35.1



