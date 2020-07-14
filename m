Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3B221FB8A
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbgGNS6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbgGNS6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4441D22AAF;
        Tue, 14 Jul 2020 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753110;
        bh=RT8SnblZPxY4b+OdOEcKbtPwUcpxAo4yfWM5wPnqJwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCuBVsChzWJUC658n27glzGyE88I3HsylLEa5C4zCOSc+J1lFkJ8QVESDED/DTYoJ
         ldwrwiQc7qQuxdqMvjeludXpg6X1nYmJMvo0cEFLzAjWevbj3Gl1FnlrQ6KJGPzxNA
         g0p7ZKP968dvZdetSHtNWayRk9ZPg5ps1jMHrHrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 093/166] selftests: bpf: Fix detach from sockmap tests
Date:   Tue, 14 Jul 2020 20:44:18 +0200
Message-Id: <20200714184120.295897188@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit f43cb0d672aa8eb09bfdb779de5900c040487d1d ]

Fix sockmap tests which rely on old bpf_prog_dispatch behaviour.
In the first case, the tests check that detaching without giving
a program succeeds. Since these are not the desired semantics,
invert the condition. In the second case, the clean up code doesn't
supply the necessary program fds.

Fixes: bb0de3131f4c ("bpf: sockmap: Require attach_bpf_fd when detaching a program")
Reported-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200709115151.75829-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index c6766b2cff853..9990e91c18dff 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -789,19 +789,19 @@ static void test_sockmap(unsigned int tasks, void *data)
 	}
 
 	err = bpf_prog_detach(fd, BPF_SK_SKB_STREAM_PARSER);
-	if (err) {
+	if (!err) {
 		printf("Failed empty parser prog detach\n");
 		goto out_sockmap;
 	}
 
 	err = bpf_prog_detach(fd, BPF_SK_SKB_STREAM_VERDICT);
-	if (err) {
+	if (!err) {
 		printf("Failed empty verdict prog detach\n");
 		goto out_sockmap;
 	}
 
 	err = bpf_prog_detach(fd, BPF_SK_MSG_VERDICT);
-	if (err) {
+	if (!err) {
 		printf("Failed empty msg verdict prog detach\n");
 		goto out_sockmap;
 	}
@@ -1090,19 +1090,19 @@ static void test_sockmap(unsigned int tasks, void *data)
 		assert(status == 0);
 	}
 
-	err = bpf_prog_detach(map_fd_rx, __MAX_BPF_ATTACH_TYPE);
+	err = bpf_prog_detach2(parse_prog, map_fd_rx, __MAX_BPF_ATTACH_TYPE);
 	if (!err) {
 		printf("Detached an invalid prog type.\n");
 		goto out_sockmap;
 	}
 
-	err = bpf_prog_detach(map_fd_rx, BPF_SK_SKB_STREAM_PARSER);
+	err = bpf_prog_detach2(parse_prog, map_fd_rx, BPF_SK_SKB_STREAM_PARSER);
 	if (err) {
 		printf("Failed parser prog detach\n");
 		goto out_sockmap;
 	}
 
-	err = bpf_prog_detach(map_fd_rx, BPF_SK_SKB_STREAM_VERDICT);
+	err = bpf_prog_detach2(verdict_prog, map_fd_rx, BPF_SK_SKB_STREAM_VERDICT);
 	if (err) {
 		printf("Failed parser prog detach\n");
 		goto out_sockmap;
-- 
2.25.1



