Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D608452373
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351178AbhKPB0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243404AbhKOTB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E1E263347;
        Mon, 15 Nov 2021 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000079;
        bh=5pllriLMsJyqD0CUjWP1Jgbm8esa7oPKn6wy0/9vCyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW83rkoaJ4mzMsJ7hH3BWiilV7p43jp9LjEMRlVCA4msGFGHASNu+oJOD3dVfZEed
         jXqorPAkFh6KeDvWMegbrDGScfUlwfMSj06bsb5j4+fjQJvUbrLukUpAIzU5U9g8Zf
         a5TvdEFiPaNuXJHtnzdy2sa2llKnG4Vt8b99+KZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 528/849] selftests/bpf: Fix fd cleanup in sk_lookup test
Date:   Mon, 15 Nov 2021 18:00:11 +0100
Message-Id: <20211115165438.135999216@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit c3fc706e94f5653def2783ffcd809a38676b7551 ]

Similar to the fix in commit:
e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")

We use designated initializer to set fds to -1 without breaking on
future changes to MAX_SERVER constant denoting the array size.

The particular close(0) occurs on non-reuseport tests, so it can be seen
with -n 115/{2,3} but not 115/4. This can cause problems with future
tests if they depend on BTF fd never being acquired as fd 0, breaking
internal libbpf assumptions.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20211028063501.2239335-8-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index aee41547e7f45..6db07401bc493 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -598,7 +598,7 @@ close:
 
 static void run_lookup_prog(const struct test *t)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
 	int i, err;
@@ -1053,7 +1053,7 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
 			  const char *remote_ip, const char *local_ip)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	struct bpf_sk_lookup ctx;
 	__u64 server_cookie;
 	int i, err;
-- 
2.33.0



