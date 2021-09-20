Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF45C411E49
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbhITR2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350114AbhITR0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:26:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D5261425;
        Mon, 20 Sep 2021 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157370;
        bh=sD6Zjz4XgFnTkzsdkW1tFoWkAVvIfgF0vNhuksybvbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/Ai9vK+0DE2OLim/AHJTpDTiSPpg1c0z02u5pntjNI5mqM3djoQFReNdrtDbcL2k
         VrRbmpX4/h/ZwRvGsUQENI8qo8d+gBu2gnMbxBNuZFrMtlKDQ0RFzlKQheJ3p/XboO
         2y1fCOMc4Yp6y0FVJUOWBpg1NcQDbMymqpOSUfbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/217] bpf/tests: Do not PASS tests without actually testing the result
Date:   Mon, 20 Sep 2021 18:42:46 +0200
Message-Id: <20210920163929.553597446@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index 4aa88ba8238c..9a8f957ad86e 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6306,7 +6306,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
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



