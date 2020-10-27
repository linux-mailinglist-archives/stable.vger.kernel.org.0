Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51B329B83B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368811AbgJ0PeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368704AbgJ0PeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7B822202;
        Tue, 27 Oct 2020 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812843;
        bh=db3idX7P0RIhbEKjulac1pFFOKXO6hrNb9E0DQGDb9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOIXD/7OeCnkkKXvpZWHZCMtZ2OHsstEEl5NsHB+thPlrbXwW7HYmbrJW4inoR+Uk
         AzTA8KPjEkoMf8u2ma4hb+pMTXatUGinIE5WA0tfovyBhhn4vwTWNK12pzTSvn5zhp
         LthlhqdmyykvsIgatnx5mjizJd4KQyjAeWQnmEnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 350/757] selftests/bpf: Fix endianness issues in sk_lookup/ctx_narrow_access
Date:   Tue, 27 Oct 2020 14:50:00 +0100
Message-Id: <20201027135506.987837008@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 6458bde368cee77e798d05cccd2316db4d748c41 ]

This test makes a lot of narrow load checks while assuming little
endian architecture, and therefore fails on s390.

Fix by introducing LSB and LSW macros and using them to perform narrow
loads.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200929201814.44360-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/test_sk_lookup.c      | 216 ++++++++----------
 1 file changed, 101 insertions(+), 115 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index bbf8296f4d663..1032b292af5b7 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -19,6 +19,17 @@
 #define IP6(aaaa, bbbb, cccc, dddd)			\
 	{ bpf_htonl(aaaa), bpf_htonl(bbbb), bpf_htonl(cccc), bpf_htonl(dddd) }
 
+/* Macros for least-significant byte and word accesses. */
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define LSE_INDEX(index, size) (index)
+#else
+#define LSE_INDEX(index, size) ((size) - (index) - 1)
+#endif
+#define LSB(value, index)				\
+	(((__u8 *)&(value))[LSE_INDEX((index), sizeof(value))])
+#define LSW(value, index)				\
+	(((__u16 *)&(value))[LSE_INDEX((index), sizeof(value) / 2)])
+
 #define MAX_SOCKS 32
 
 struct {
@@ -369,171 +380,146 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 {
 	struct bpf_sock *sk;
 	int err, family;
-	__u16 *half;
-	__u8 *byte;
 	bool v4;
 
 	v4 = (ctx->family == AF_INET);
 
 	/* Narrow loads from family field */
-	byte = (__u8 *)&ctx->family;
-	half = (__u16 *)&ctx->family;
-	if (byte[0] != (v4 ? AF_INET : AF_INET6) ||
-	    byte[1] != 0 || byte[2] != 0 || byte[3] != 0)
+	if (LSB(ctx->family, 0) != (v4 ? AF_INET : AF_INET6) ||
+	    LSB(ctx->family, 1) != 0 || LSB(ctx->family, 2) != 0 || LSB(ctx->family, 3) != 0)
 		return SK_DROP;
-	if (half[0] != (v4 ? AF_INET : AF_INET6))
+	if (LSW(ctx->family, 0) != (v4 ? AF_INET : AF_INET6))
 		return SK_DROP;
 
-	byte = (__u8 *)&ctx->protocol;
-	if (byte[0] != IPPROTO_TCP ||
-	    byte[1] != 0 || byte[2] != 0 || byte[3] != 0)
+	/* Narrow loads from protocol field */
+	if (LSB(ctx->protocol, 0) != IPPROTO_TCP ||
+	    LSB(ctx->protocol, 1) != 0 || LSB(ctx->protocol, 2) != 0 || LSB(ctx->protocol, 3) != 0)
 		return SK_DROP;
-	half = (__u16 *)&ctx->protocol;
-	if (half[0] != IPPROTO_TCP)
+	if (LSW(ctx->protocol, 0) != IPPROTO_TCP)
 		return SK_DROP;
 
 	/* Narrow loads from remote_port field. Expect non-0 value. */
-	byte = (__u8 *)&ctx->remote_port;
-	if (byte[0] == 0 && byte[1] == 0 && byte[2] == 0 && byte[3] == 0)
+	if (LSB(ctx->remote_port, 0) == 0 && LSB(ctx->remote_port, 1) == 0 &&
+	    LSB(ctx->remote_port, 2) == 0 && LSB(ctx->remote_port, 3) == 0)
 		return SK_DROP;
-	half = (__u16 *)&ctx->remote_port;
-	if (half[0] == 0)
+	if (LSW(ctx->remote_port, 0) == 0)
 		return SK_DROP;
 
 	/* Narrow loads from local_port field. Expect DST_PORT. */
-	byte = (__u8 *)&ctx->local_port;
-	if (byte[0] != ((DST_PORT >> 0) & 0xff) ||
-	    byte[1] != ((DST_PORT >> 8) & 0xff) ||
-	    byte[2] != 0 || byte[3] != 0)
+	if (LSB(ctx->local_port, 0) != ((DST_PORT >> 0) & 0xff) ||
+	    LSB(ctx->local_port, 1) != ((DST_PORT >> 8) & 0xff) ||
+	    LSB(ctx->local_port, 2) != 0 || LSB(ctx->local_port, 3) != 0)
 		return SK_DROP;
-	half = (__u16 *)&ctx->local_port;
-	if (half[0] != DST_PORT)
+	if (LSW(ctx->local_port, 0) != DST_PORT)
 		return SK_DROP;
 
 	/* Narrow loads from IPv4 fields */
 	if (v4) {
 		/* Expect non-0.0.0.0 in remote_ip4 */
-		byte = (__u8 *)&ctx->remote_ip4;
-		if (byte[0] == 0 && byte[1] == 0 &&
-		    byte[2] == 0 && byte[3] == 0)
+		if (LSB(ctx->remote_ip4, 0) == 0 && LSB(ctx->remote_ip4, 1) == 0 &&
+		    LSB(ctx->remote_ip4, 2) == 0 && LSB(ctx->remote_ip4, 3) == 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->remote_ip4;
-		if (half[0] == 0 && half[1] == 0)
+		if (LSW(ctx->remote_ip4, 0) == 0 && LSW(ctx->remote_ip4, 1) == 0)
 			return SK_DROP;
 
 		/* Expect DST_IP4 in local_ip4 */
-		byte = (__u8 *)&ctx->local_ip4;
-		if (byte[0] != ((DST_IP4 >>  0) & 0xff) ||
-		    byte[1] != ((DST_IP4 >>  8) & 0xff) ||
-		    byte[2] != ((DST_IP4 >> 16) & 0xff) ||
-		    byte[3] != ((DST_IP4 >> 24) & 0xff))
+		if (LSB(ctx->local_ip4, 0) != ((DST_IP4 >> 0) & 0xff) ||
+		    LSB(ctx->local_ip4, 1) != ((DST_IP4 >> 8) & 0xff) ||
+		    LSB(ctx->local_ip4, 2) != ((DST_IP4 >> 16) & 0xff) ||
+		    LSB(ctx->local_ip4, 3) != ((DST_IP4 >> 24) & 0xff))
 			return SK_DROP;
-		half = (__u16 *)&ctx->local_ip4;
-		if (half[0] != ((DST_IP4 >>  0) & 0xffff) ||
-		    half[1] != ((DST_IP4 >> 16) & 0xffff))
+		if (LSW(ctx->local_ip4, 0) != ((DST_IP4 >> 0) & 0xffff) ||
+		    LSW(ctx->local_ip4, 1) != ((DST_IP4 >> 16) & 0xffff))
 			return SK_DROP;
 	} else {
 		/* Expect 0.0.0.0 IPs when family != AF_INET */
-		byte = (__u8 *)&ctx->remote_ip4;
-		if (byte[0] != 0 || byte[1] != 0 &&
-		    byte[2] != 0 || byte[3] != 0)
+		if (LSB(ctx->remote_ip4, 0) != 0 || LSB(ctx->remote_ip4, 1) != 0 ||
+		    LSB(ctx->remote_ip4, 2) != 0 || LSB(ctx->remote_ip4, 3) != 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->remote_ip4;
-		if (half[0] != 0 || half[1] != 0)
+		if (LSW(ctx->remote_ip4, 0) != 0 || LSW(ctx->remote_ip4, 1) != 0)
 			return SK_DROP;
 
-		byte = (__u8 *)&ctx->local_ip4;
-		if (byte[0] != 0 || byte[1] != 0 &&
-		    byte[2] != 0 || byte[3] != 0)
+		if (LSB(ctx->local_ip4, 0) != 0 || LSB(ctx->local_ip4, 1) != 0 ||
+		    LSB(ctx->local_ip4, 2) != 0 || LSB(ctx->local_ip4, 3) != 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->local_ip4;
-		if (half[0] != 0 || half[1] != 0)
+		if (LSW(ctx->local_ip4, 0) != 0 || LSW(ctx->local_ip4, 1) != 0)
 			return SK_DROP;
 	}
 
 	/* Narrow loads from IPv6 fields */
 	if (!v4) {
-		/* Expenct non-:: IP in remote_ip6 */
-		byte = (__u8 *)&ctx->remote_ip6;
-		if (byte[0] == 0 && byte[1] == 0 &&
-		    byte[2] == 0 && byte[3] == 0 &&
-		    byte[4] == 0 && byte[5] == 0 &&
-		    byte[6] == 0 && byte[7] == 0 &&
-		    byte[8] == 0 && byte[9] == 0 &&
-		    byte[10] == 0 && byte[11] == 0 &&
-		    byte[12] == 0 && byte[13] == 0 &&
-		    byte[14] == 0 && byte[15] == 0)
+		/* Expect non-:: IP in remote_ip6 */
+		if (LSB(ctx->remote_ip6[0], 0) == 0 && LSB(ctx->remote_ip6[0], 1) == 0 &&
+		    LSB(ctx->remote_ip6[0], 2) == 0 && LSB(ctx->remote_ip6[0], 3) == 0 &&
+		    LSB(ctx->remote_ip6[1], 0) == 0 && LSB(ctx->remote_ip6[1], 1) == 0 &&
+		    LSB(ctx->remote_ip6[1], 2) == 0 && LSB(ctx->remote_ip6[1], 3) == 0 &&
+		    LSB(ctx->remote_ip6[2], 0) == 0 && LSB(ctx->remote_ip6[2], 1) == 0 &&
+		    LSB(ctx->remote_ip6[2], 2) == 0 && LSB(ctx->remote_ip6[2], 3) == 0 &&
+		    LSB(ctx->remote_ip6[3], 0) == 0 && LSB(ctx->remote_ip6[3], 1) == 0 &&
+		    LSB(ctx->remote_ip6[3], 2) == 0 && LSB(ctx->remote_ip6[3], 3) == 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->remote_ip6;
-		if (half[0] == 0 && half[1] == 0 &&
-		    half[2] == 0 && half[3] == 0 &&
-		    half[4] == 0 && half[5] == 0 &&
-		    half[6] == 0 && half[7] == 0)
+		if (LSW(ctx->remote_ip6[0], 0) == 0 && LSW(ctx->remote_ip6[0], 1) == 0 &&
+		    LSW(ctx->remote_ip6[1], 0) == 0 && LSW(ctx->remote_ip6[1], 1) == 0 &&
+		    LSW(ctx->remote_ip6[2], 0) == 0 && LSW(ctx->remote_ip6[2], 1) == 0 &&
+		    LSW(ctx->remote_ip6[3], 0) == 0 && LSW(ctx->remote_ip6[3], 1) == 0)
 			return SK_DROP;
-
 		/* Expect DST_IP6 in local_ip6 */
-		byte = (__u8 *)&ctx->local_ip6;
-		if (byte[0] != ((DST_IP6[0] >>  0) & 0xff) ||
-		    byte[1] != ((DST_IP6[0] >>  8) & 0xff) ||
-		    byte[2] != ((DST_IP6[0] >> 16) & 0xff) ||
-		    byte[3] != ((DST_IP6[0] >> 24) & 0xff) ||
-		    byte[4] != ((DST_IP6[1] >>  0) & 0xff) ||
-		    byte[5] != ((DST_IP6[1] >>  8) & 0xff) ||
-		    byte[6] != ((DST_IP6[1] >> 16) & 0xff) ||
-		    byte[7] != ((DST_IP6[1] >> 24) & 0xff) ||
-		    byte[8] != ((DST_IP6[2] >>  0) & 0xff) ||
-		    byte[9] != ((DST_IP6[2] >>  8) & 0xff) ||
-		    byte[10] != ((DST_IP6[2] >> 16) & 0xff) ||
-		    byte[11] != ((DST_IP6[2] >> 24) & 0xff) ||
-		    byte[12] != ((DST_IP6[3] >>  0) & 0xff) ||
-		    byte[13] != ((DST_IP6[3] >>  8) & 0xff) ||
-		    byte[14] != ((DST_IP6[3] >> 16) & 0xff) ||
-		    byte[15] != ((DST_IP6[3] >> 24) & 0xff))
+		if (LSB(ctx->local_ip6[0], 0) != ((DST_IP6[0] >> 0) & 0xff) ||
+		    LSB(ctx->local_ip6[0], 1) != ((DST_IP6[0] >> 8) & 0xff) ||
+		    LSB(ctx->local_ip6[0], 2) != ((DST_IP6[0] >> 16) & 0xff) ||
+		    LSB(ctx->local_ip6[0], 3) != ((DST_IP6[0] >> 24) & 0xff) ||
+		    LSB(ctx->local_ip6[1], 0) != ((DST_IP6[1] >> 0) & 0xff) ||
+		    LSB(ctx->local_ip6[1], 1) != ((DST_IP6[1] >> 8) & 0xff) ||
+		    LSB(ctx->local_ip6[1], 2) != ((DST_IP6[1] >> 16) & 0xff) ||
+		    LSB(ctx->local_ip6[1], 3) != ((DST_IP6[1] >> 24) & 0xff) ||
+		    LSB(ctx->local_ip6[2], 0) != ((DST_IP6[2] >> 0) & 0xff) ||
+		    LSB(ctx->local_ip6[2], 1) != ((DST_IP6[2] >> 8) & 0xff) ||
+		    LSB(ctx->local_ip6[2], 2) != ((DST_IP6[2] >> 16) & 0xff) ||
+		    LSB(ctx->local_ip6[2], 3) != ((DST_IP6[2] >> 24) & 0xff) ||
+		    LSB(ctx->local_ip6[3], 0) != ((DST_IP6[3] >> 0) & 0xff) ||
+		    LSB(ctx->local_ip6[3], 1) != ((DST_IP6[3] >> 8) & 0xff) ||
+		    LSB(ctx->local_ip6[3], 2) != ((DST_IP6[3] >> 16) & 0xff) ||
+		    LSB(ctx->local_ip6[3], 3) != ((DST_IP6[3] >> 24) & 0xff))
 			return SK_DROP;
-		half = (__u16 *)&ctx->local_ip6;
-		if (half[0] != ((DST_IP6[0] >>  0) & 0xffff) ||
-		    half[1] != ((DST_IP6[0] >> 16) & 0xffff) ||
-		    half[2] != ((DST_IP6[1] >>  0) & 0xffff) ||
-		    half[3] != ((DST_IP6[1] >> 16) & 0xffff) ||
-		    half[4] != ((DST_IP6[2] >>  0) & 0xffff) ||
-		    half[5] != ((DST_IP6[2] >> 16) & 0xffff) ||
-		    half[6] != ((DST_IP6[3] >>  0) & 0xffff) ||
-		    half[7] != ((DST_IP6[3] >> 16) & 0xffff))
+		if (LSW(ctx->local_ip6[0], 0) != ((DST_IP6[0] >> 0) & 0xffff) ||
+		    LSW(ctx->local_ip6[0], 1) != ((DST_IP6[0] >> 16) & 0xffff) ||
+		    LSW(ctx->local_ip6[1], 0) != ((DST_IP6[1] >> 0) & 0xffff) ||
+		    LSW(ctx->local_ip6[1], 1) != ((DST_IP6[1] >> 16) & 0xffff) ||
+		    LSW(ctx->local_ip6[2], 0) != ((DST_IP6[2] >> 0) & 0xffff) ||
+		    LSW(ctx->local_ip6[2], 1) != ((DST_IP6[2] >> 16) & 0xffff) ||
+		    LSW(ctx->local_ip6[3], 0) != ((DST_IP6[3] >> 0) & 0xffff) ||
+		    LSW(ctx->local_ip6[3], 1) != ((DST_IP6[3] >> 16) & 0xffff))
 			return SK_DROP;
 	} else {
 		/* Expect :: IPs when family != AF_INET6 */
-		byte = (__u8 *)&ctx->remote_ip6;
-		if (byte[0] != 0 || byte[1] != 0 ||
-		    byte[2] != 0 || byte[3] != 0 ||
-		    byte[4] != 0 || byte[5] != 0 ||
-		    byte[6] != 0 || byte[7] != 0 ||
-		    byte[8] != 0 || byte[9] != 0 ||
-		    byte[10] != 0 || byte[11] != 0 ||
-		    byte[12] != 0 || byte[13] != 0 ||
-		    byte[14] != 0 || byte[15] != 0)
+		if (LSB(ctx->remote_ip6[0], 0) != 0 || LSB(ctx->remote_ip6[0], 1) != 0 ||
+		    LSB(ctx->remote_ip6[0], 2) != 0 || LSB(ctx->remote_ip6[0], 3) != 0 ||
+		    LSB(ctx->remote_ip6[1], 0) != 0 || LSB(ctx->remote_ip6[1], 1) != 0 ||
+		    LSB(ctx->remote_ip6[1], 2) != 0 || LSB(ctx->remote_ip6[1], 3) != 0 ||
+		    LSB(ctx->remote_ip6[2], 0) != 0 || LSB(ctx->remote_ip6[2], 1) != 0 ||
+		    LSB(ctx->remote_ip6[2], 2) != 0 || LSB(ctx->remote_ip6[2], 3) != 0 ||
+		    LSB(ctx->remote_ip6[3], 0) != 0 || LSB(ctx->remote_ip6[3], 1) != 0 ||
+		    LSB(ctx->remote_ip6[3], 2) != 0 || LSB(ctx->remote_ip6[3], 3) != 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->remote_ip6;
-		if (half[0] != 0 || half[1] != 0 ||
-		    half[2] != 0 || half[3] != 0 ||
-		    half[4] != 0 || half[5] != 0 ||
-		    half[6] != 0 || half[7] != 0)
+		if (LSW(ctx->remote_ip6[0], 0) != 0 || LSW(ctx->remote_ip6[0], 1) != 0 ||
+		    LSW(ctx->remote_ip6[1], 0) != 0 || LSW(ctx->remote_ip6[1], 1) != 0 ||
+		    LSW(ctx->remote_ip6[2], 0) != 0 || LSW(ctx->remote_ip6[2], 1) != 0 ||
+		    LSW(ctx->remote_ip6[3], 0) != 0 || LSW(ctx->remote_ip6[3], 1) != 0)
 			return SK_DROP;
 
-		byte = (__u8 *)&ctx->local_ip6;
-		if (byte[0] != 0 || byte[1] != 0 ||
-		    byte[2] != 0 || byte[3] != 0 ||
-		    byte[4] != 0 || byte[5] != 0 ||
-		    byte[6] != 0 || byte[7] != 0 ||
-		    byte[8] != 0 || byte[9] != 0 ||
-		    byte[10] != 0 || byte[11] != 0 ||
-		    byte[12] != 0 || byte[13] != 0 ||
-		    byte[14] != 0 || byte[15] != 0)
+		if (LSB(ctx->local_ip6[0], 0) != 0 || LSB(ctx->local_ip6[0], 1) != 0 ||
+		    LSB(ctx->local_ip6[0], 2) != 0 || LSB(ctx->local_ip6[0], 3) != 0 ||
+		    LSB(ctx->local_ip6[1], 0) != 0 || LSB(ctx->local_ip6[1], 1) != 0 ||
+		    LSB(ctx->local_ip6[1], 2) != 0 || LSB(ctx->local_ip6[1], 3) != 0 ||
+		    LSB(ctx->local_ip6[2], 0) != 0 || LSB(ctx->local_ip6[2], 1) != 0 ||
+		    LSB(ctx->local_ip6[2], 2) != 0 || LSB(ctx->local_ip6[2], 3) != 0 ||
+		    LSB(ctx->local_ip6[3], 0) != 0 || LSB(ctx->local_ip6[3], 1) != 0 ||
+		    LSB(ctx->local_ip6[3], 2) != 0 || LSB(ctx->local_ip6[3], 3) != 0)
 			return SK_DROP;
-		half = (__u16 *)&ctx->local_ip6;
-		if (half[0] != 0 || half[1] != 0 ||
-		    half[2] != 0 || half[3] != 0 ||
-		    half[4] != 0 || half[5] != 0 ||
-		    half[6] != 0 || half[7] != 0)
+		if (LSW(ctx->remote_ip6[0], 0) != 0 || LSW(ctx->remote_ip6[0], 1) != 0 ||
+		    LSW(ctx->remote_ip6[1], 0) != 0 || LSW(ctx->remote_ip6[1], 1) != 0 ||
+		    LSW(ctx->remote_ip6[2], 0) != 0 || LSW(ctx->remote_ip6[2], 1) != 0 ||
+		    LSW(ctx->remote_ip6[3], 0) != 0 || LSW(ctx->remote_ip6[3], 1) != 0)
 			return SK_DROP;
 	}
 
-- 
2.25.1



