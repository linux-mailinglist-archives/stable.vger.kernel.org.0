Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4086447AE35
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhLTO7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:59:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34152 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbhLTO41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 878BFB80EF5;
        Mon, 20 Dec 2021 14:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDEBC36AE7;
        Mon, 20 Dec 2021 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012184;
        bh=eOpUGIF7+iDVg+xN+h3qxoKk41uVUs8NCd4DQQ3tuE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3ImnD4EcANneM2tk5wb+wFX6yM6mx7sB8zUDPG9ty/7lyjn9dWH/rBTaZELHPCxx
         z6gI3Wcg8tbtccWhYz7VQb+oAjv3u9YaZrxwCmdBdwH2s9Rl/y/2cIdPKp2pdnIvcj
         u4YcVnUaDDpIwiu2SZKzrknmoIaLHTpStISy//4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/177] bpf, selftests: Fix racing issue in btf_skc_cls_ingress test
Date:   Mon, 20 Dec 2021 15:34:21 +0100
Message-Id: <20211220143043.814191641@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit c2fcbf81c332b42382a0c439bfe2414a241e4f5b ]

The libbpf CI reported occasional failure in btf_skc_cls_ingress:

  test_syncookie:FAIL:Unexpected syncookie states gen_cookie:80326634 recv_cookie:0
  bpf prog error at line 97

"error at line 97" means the bpf prog cannot find the listening socket
when the final ack is received.  It then skipped processing
the syncookie in the final ack which then led to "recv_cookie:0".

The problem is the userspace program did not do accept() and went
ahead to close(listen_fd) before the kernel (and the bpf prog) had
a chance to process the final ack.

The fix is to add accept() call so that the userspace will wait for
the kernel to finish processing the final ack first before close()-ing
everything.

Fixes: 9a856cae2217 ("bpf: selftest: Add test_btf_skc_cls_ingress")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211216191630.466151-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/btf_skc_cls_ingress.c         | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
index 762f6a9da8b5e..664ffc0364f4f 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
@@ -90,7 +90,7 @@ static void print_err_line(void)
 
 static void test_conn(void)
 {
-	int listen_fd = -1, cli_fd = -1, err;
+	int listen_fd = -1, cli_fd = -1, srv_fd = -1, err;
 	socklen_t addrlen = sizeof(srv_sa6);
 	int srv_port;
 
@@ -112,6 +112,10 @@ static void test_conn(void)
 	if (CHECK_FAIL(cli_fd == -1))
 		goto done;
 
+	srv_fd = accept(listen_fd, NULL, NULL);
+	if (CHECK_FAIL(srv_fd == -1))
+		goto done;
+
 	if (CHECK(skel->bss->listen_tp_sport != srv_port ||
 		  skel->bss->req_sk_sport != srv_port,
 		  "Unexpected sk src port",
@@ -134,11 +138,13 @@ static void test_conn(void)
 		close(listen_fd);
 	if (cli_fd != -1)
 		close(cli_fd);
+	if (srv_fd != -1)
+		close(srv_fd);
 }
 
 static void test_syncookie(void)
 {
-	int listen_fd = -1, cli_fd = -1, err;
+	int listen_fd = -1, cli_fd = -1, srv_fd = -1, err;
 	socklen_t addrlen = sizeof(srv_sa6);
 	int srv_port;
 
@@ -161,6 +167,10 @@ static void test_syncookie(void)
 	if (CHECK_FAIL(cli_fd == -1))
 		goto done;
 
+	srv_fd = accept(listen_fd, NULL, NULL);
+	if (CHECK_FAIL(srv_fd == -1))
+		goto done;
+
 	if (CHECK(skel->bss->listen_tp_sport != srv_port,
 		  "Unexpected tp src port",
 		  "listen_tp_sport:%u expected:%u\n",
@@ -188,6 +198,8 @@ static void test_syncookie(void)
 		close(listen_fd);
 	if (cli_fd != -1)
 		close(cli_fd);
+	if (srv_fd != -1)
+		close(srv_fd);
 }
 
 struct test {
-- 
2.33.0



