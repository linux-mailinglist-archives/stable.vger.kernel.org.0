Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7F823D1D2
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgHEUGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbgHEQel (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6BF823382;
        Wed,  5 Aug 2020 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642779;
        bh=POF6DDiHm8atPTslFXz0sLdllxBBkRKfAFe2q0FnobE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gg+itV+r90Y6NJdDD0QLTkJ1Kak0FRXZ1l7TGvxe1R8a9uw9RgtkSHAPofHqaJw/Y
         1kfFJYrMLT50fYMskW4NFimBq87Cw1pu+F4LC7g7AYzxmbGq/dzaG39dOw2fBK0ZxZ
         0/Hc0BV0vhJVkOApRnPkaVwf8x0y2Q6nM4bXMomU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH 5.4 8/9] selftests: bpf: Fix detach from sockmap tests
Date:   Wed,  5 Aug 2020 17:52:45 +0200
Message-Id: <20200805153507.423308944@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit f43cb0d672aa8eb09bfdb779de5900c040487d1d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/test_maps.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -793,19 +793,19 @@ static void test_sockmap(unsigned int ta
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
@@ -1094,19 +1094,19 @@ static void test_sockmap(unsigned int ta
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


