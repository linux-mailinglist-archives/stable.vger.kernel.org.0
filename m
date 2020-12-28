Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF22E3D44
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440126AbgL1ONS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440133AbgL1ONS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D89207AB;
        Mon, 28 Dec 2020 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164782;
        bh=6rKxfRTddsCZy/I+/CIRBvA96NRsbhn3MuU5mRp0G/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cV2ROk6/ankE/TC3Dp+EmNDrxWgL3R2CogEPpGOIC9z/A9C5MyfcADrkNHC0pBDlT
         Zfztn+VoHEZ2hujrMdUiefbrUwvc6LAQPf3BB+JL4vnDZz1Sy9HUgjXmszV13769UB
         HeXn2ug+eUBP+jJ7xh/v+fFu0Ejun1h3u6SCn89Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/717] selftests/bpf: Fix invalid use of strncat in test_sockmap
Date:   Mon, 28 Dec 2020 13:44:54 +0100
Message-Id: <20201228125035.208373445@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit eceae70bdeaeb6b8ceb662983cf663ff352fbc96 ]

strncat()'s third argument is how many bytes will be added *in addition* to
already existing bytes in destination. Plus extra zero byte will be added
after that. So existing use in test_sockmap has many opportunities to overflow
the string and cause memory corruptions. And in this case, GCC complains for
a good reason.

Fixes: 16962b2404ac ("bpf: sockmap, add selftests")
Fixes: 73563aa3d977 ("selftests/bpf: test_sockmap, print additional test options")
Fixes: 1ade9abadfca ("bpf: test_sockmap, add options for msg_pop_data() helper")
Fixes: 463bac5f1ca7 ("bpf, selftests: Add test for ktls with skb bpf ingress policy")
Fixes: e9dd904708c4 ("bpf: add tls support for testing in test_sockmap")
Fixes: 753fb2ee0934 ("bpf: sockmap, add msg_peek tests to test_sockmap")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20201203235440.2302137-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 36 ++++++++++++++--------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 0fa1e421c3d7a..427ca00a32177 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1273,6 +1273,16 @@ static char *test_to_str(int test)
 	return "unknown";
 }
 
+static void append_str(char *dst, const char *src, size_t dst_cap)
+{
+	size_t avail = dst_cap - strlen(dst);
+
+	if (avail <= 1) /* just zero byte could be written */
+		return;
+
+	strncat(dst, src, avail - 1); /* strncat() adds + 1 for zero byte */
+}
+
 #define OPTSTRING 60
 static void test_options(char *options)
 {
@@ -1281,42 +1291,42 @@ static void test_options(char *options)
 	memset(options, 0, OPTSTRING);
 
 	if (txmsg_pass)
-		strncat(options, "pass,", OPTSTRING);
+		append_str(options, "pass,", OPTSTRING);
 	if (txmsg_redir)
-		strncat(options, "redir,", OPTSTRING);
+		append_str(options, "redir,", OPTSTRING);
 	if (txmsg_drop)
-		strncat(options, "drop,", OPTSTRING);
+		append_str(options, "drop,", OPTSTRING);
 	if (txmsg_apply) {
 		snprintf(tstr, OPTSTRING, "apply %d,", txmsg_apply);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_cork) {
 		snprintf(tstr, OPTSTRING, "cork %d,", txmsg_cork);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_start) {
 		snprintf(tstr, OPTSTRING, "start %d,", txmsg_start);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_end) {
 		snprintf(tstr, OPTSTRING, "end %d,", txmsg_end);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_start_pop) {
 		snprintf(tstr, OPTSTRING, "pop (%d,%d),",
 			 txmsg_start_pop, txmsg_start_pop + txmsg_pop);
-		strncat(options, tstr, OPTSTRING);
+		append_str(options, tstr, OPTSTRING);
 	}
 	if (txmsg_ingress)
-		strncat(options, "ingress,", OPTSTRING);
+		append_str(options, "ingress,", OPTSTRING);
 	if (txmsg_redir_skb)
-		strncat(options, "redir_skb,", OPTSTRING);
+		append_str(options, "redir_skb,", OPTSTRING);
 	if (txmsg_ktls_skb)
-		strncat(options, "ktls_skb,", OPTSTRING);
+		append_str(options, "ktls_skb,", OPTSTRING);
 	if (ktls)
-		strncat(options, "ktls,", OPTSTRING);
+		append_str(options, "ktls,", OPTSTRING);
 	if (peek_flag)
-		strncat(options, "peek,", OPTSTRING);
+		append_str(options, "peek,", OPTSTRING);
 }
 
 static int __test_exec(int cgrp, int test, struct sockmap_options *opt)
-- 
2.27.0



