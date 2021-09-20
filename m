Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8397411C07
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344891AbhITRFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344984AbhITRD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D87614C8;
        Mon, 20 Sep 2021 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156857;
        bh=hVX1NLfmiO5DBcHd5zjH1jrDUSe5miIXW6d7LkFnJX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IpJLnA7g5XnWSW+G6/zQLy+I63mWwNVmhpYsq07wkjTN95E8SGlHIzwjDU7cJyVv
         EYXxSX7WgaD6pKNit6tNffOHmPlhAOo1ci6j1ICUiFLEUf9rwBdeh1duV7JD27STLw
         aGsRKhv3zEwxrD9Q22CaGQ8n5gkqyo/bo1+0ngUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/175] bpf/tests: Do not PASS tests without actually testing the result
Date:   Mon, 20 Sep 2021 18:42:47 +0200
Message-Id: <20210920163921.930960328@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 2b7e9f25e590726cca76700ebdb10e92a7a72ca1 ]

Each test case can have a set of sub-tests, where each sub-test can
run the cBPF/eBPF test snippet with its own data_size and expected
result. Before, the end of the sub-test array was indicated by both
data_size and result being zero. However, most or all of the internal
eBPF tests has a data_size of zero already. When such a test also had
an expected value of zero, the test was never run but reported as
PASS anyway.

Now the test runner always runs the first sub-test, regardless of the
data_size and result values. The sub-test array zero-termination only
applies for any additional sub-tests.

There are other ways fix it of course, but this solution at least
removes the surprise of eBPF tests with a zero result always succeeding.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210721103822.3755111-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ed2ebf677457..0c62275630fa 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5744,7 +5744,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 		u64 duration;
 		u32 ret;
 
-		if (test->test[i].data_size == 0 &&
+		/*
+		 * NOTE: Several sub-tests may be present, in which case
+		 * a zero {data_size, result} tuple indicates the end of
+		 * the sub-test array. The first test is always run,
+		 * even if both data_size and result happen to be zero.
+		 */
+		if (i > 0 &&
+		    test->test[i].data_size == 0 &&
 		    test->test[i].result == 0)
 			break;
 
-- 
2.30.2



