Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5841673B2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbgBUIOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733213AbgBUIOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:14:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B21420578;
        Fri, 21 Feb 2020 08:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272879;
        bh=j5+g+RQG+8iUqfhHmGbPWGjRcRjG8CzYFVOGHpcaMTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4LTdY8KDmEN7pdqVQGNanROLSBVF2bKqsIE3hYhplN5lLboYWcWrtLuwSJLkmT4e
         iO/fgUX40V0nsfFFMVMnshs3u5omS+8/vcs+G1+AMsxG8UeyyT8sdUnEWbe/fD7nMO
         OLYl+49lgwLUt+wo/hcBzDU0ykTqB+gCrsEAIYGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/344] selftests: bpf: Reset global state between reuseport test runs
Date:   Fri, 21 Feb 2020 08:41:31 +0100
Message-Id: <20200221072416.378047685@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 51bad0f05616c43d6d34b0a19bcc9bdab8e8fb39 ]

Currently, there is a lot of false positives if a single reuseport test
fails. This is because expected_results and the result map are not cleared.

Zero both after individual test runs, which fixes the mentioned false
positives.

Fixes: 91134d849a0e ("bpf: Test BPF_PROG_TYPE_SK_REUSEPORT")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200124112754.19664-5-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/test_select_reuseport.c        | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
index 7566c13eb51a7..079d0f5a29091 100644
--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -30,7 +30,7 @@
 #define REUSEPORT_ARRAY_SIZE 32
 
 static int result_map, tmp_index_ovr_map, linum_map, data_check_map;
-static enum result expected_results[NR_RESULTS];
+static __u32 expected_results[NR_RESULTS];
 static int sk_fds[REUSEPORT_ARRAY_SIZE];
 static int reuseport_array, outer_map;
 static int select_by_skb_data_prog;
@@ -662,7 +662,19 @@ static void setup_per_test(int type, unsigned short family, bool inany)
 
 static void cleanup_per_test(void)
 {
-	int i, err;
+	int i, err, zero = 0;
+
+	memset(expected_results, 0, sizeof(expected_results));
+
+	for (i = 0; i < NR_RESULTS; i++) {
+		err = bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
+		RET_IF(err, "reset elem in result_map",
+		       "i:%u err:%d errno:%d\n", i, err, errno);
+	}
+
+	err = bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
+	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	       err, errno);
 
 	for (i = 0; i < REUSEPORT_ARRAY_SIZE; i++)
 		close(sk_fds[i]);
-- 
2.20.1



