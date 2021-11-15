Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CDB450E19
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbhKOSKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239986AbhKOSFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FDF06336D;
        Mon, 15 Nov 2021 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998058;
        bh=1cEP+z5GriaP6ZbnItAk/cZJj+F75kWRZRrgyXilQgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTWDw2TyfTAzyU5x3XVqwOTcnVYgaKBEXzeYPJ0bhN+YoFD5FjCOxSzcbSuqzoZdm
         Sk8zddPyDPTJeZtIKH1nKGhH5uyizkpqoYmG+/lFPZ7mMoNrZ1wjgnw9m9v93YInn2
         DdWSjwKDzyFV57GDSAqkMQsCsFhCH22Ghed/SrGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/575] selftests: bpf: Convert sk_lookup ctx access tests to PROG_TEST_RUN
Date:   Mon, 15 Nov 2021 18:01:38 +0100
Message-Id: <20211115165356.685521944@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit 509b2937bce90089fd2785db9f27951a3d850c34 ]

Convert the selftests for sk_lookup narrow context access to use
PROG_TEST_RUN instead of creating actual sockets. This ensures that
ctx is populated correctly when using PROG_TEST_RUN.

Assert concrete values since we now control remote_ip and remote_port.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210303101816.36774-4-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 83 +++++++++++++++----
 .../selftests/bpf/progs/test_sk_lookup.c      | 62 +++++++++-----
 2 files changed, 109 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index 9ff0412e1fd38..45c82db3c58c5 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -241,6 +241,48 @@ fail:
 	return -1;
 }
 
+static __u64 socket_cookie(int fd)
+{
+	__u64 cookie;
+	socklen_t cookie_len = sizeof(cookie);
+
+	if (CHECK(getsockopt(fd, SOL_SOCKET, SO_COOKIE, &cookie, &cookie_len) < 0,
+		  "getsockopt(SO_COOKIE)", "%s\n", strerror(errno)))
+		return 0;
+	return cookie;
+}
+
+static int fill_sk_lookup_ctx(struct bpf_sk_lookup *ctx, const char *local_ip, __u16 local_port,
+			      const char *remote_ip, __u16 remote_port)
+{
+	void *local, *remote;
+	int err;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->local_port = local_port;
+	ctx->remote_port = htons(remote_port);
+
+	if (is_ipv6(local_ip)) {
+		ctx->family = AF_INET6;
+		local = &ctx->local_ip6[0];
+		remote = &ctx->remote_ip6[0];
+	} else {
+		ctx->family = AF_INET;
+		local = &ctx->local_ip4;
+		remote = &ctx->remote_ip4;
+	}
+
+	err = inet_pton(ctx->family, local_ip, local);
+	if (CHECK(err != 1, "inet_pton", "local_ip failed\n"))
+		return 1;
+
+	err = inet_pton(ctx->family, remote_ip, remote);
+	if (CHECK(err != 1, "inet_pton", "remote_ip failed\n"))
+		return 1;
+
+	return 0;
+}
+
 static int send_byte(int fd)
 {
 	ssize_t n;
@@ -1009,18 +1051,27 @@ static void test_drop_on_reuseport(struct test_sk_lookup *skel)
 
 static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
-			  const char *listen_ip, const char *connect_ip)
+			  const char *remote_ip, const char *local_ip)
 {
-	int client_fd, peer_fd, server_fds[MAX_SERVERS] = { -1 };
-	struct bpf_link *lookup_link;
+	int server_fds[MAX_SERVERS] = { -1 };
+	struct bpf_sk_lookup ctx;
+	__u64 server_cookie;
 	int i, err;
 
-	lookup_link = attach_lookup_prog(lookup_prog);
-	if (!lookup_link)
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+		.ctx_in = &ctx,
+		.ctx_size_in = sizeof(ctx),
+		.ctx_out = &ctx,
+		.ctx_size_out = sizeof(ctx),
+	);
+
+	if (fill_sk_lookup_ctx(&ctx, local_ip, EXT_PORT, remote_ip, INT_PORT))
 		return;
 
+	ctx.protocol = IPPROTO_TCP;
+
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		server_fds[i] = make_server(SOCK_STREAM, listen_ip, 0, NULL);
+		server_fds[i] = make_server(SOCK_STREAM, local_ip, 0, NULL);
 		if (server_fds[i] < 0)
 			goto close_servers;
 
@@ -1030,23 +1081,25 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			goto close_servers;
 	}
 
-	client_fd = make_client(SOCK_STREAM, connect_ip, EXT_PORT);
-	if (client_fd < 0)
+	server_cookie = socket_cookie(server_fds[SERVER_B]);
+	if (!server_cookie)
+		return;
+
+	err = bpf_prog_test_run_opts(bpf_program__fd(lookup_prog), &opts);
+	if (CHECK(err, "test_run", "failed with error %d\n", errno))
+		goto close_servers;
+
+	if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
 		goto close_servers;
 
-	peer_fd = accept(server_fds[SERVER_B], NULL, NULL);
-	if (CHECK(peer_fd < 0, "accept", "failed\n"))
-		goto close_client;
+	CHECK(ctx.cookie != server_cookie, "ctx.cookie",
+	      "selected sk %llu instead of %llu\n", ctx.cookie, server_cookie);
 
-	close(peer_fd);
-close_client:
-	close(client_fd);
 close_servers:
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
 		if (server_fds[i] != -1)
 			close(server_fds[i]);
 	}
-	bpf_link__destroy(lookup_link);
 }
 
 static void run_sk_assign_v4(struct test_sk_lookup *skel,
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index 1032b292af5b7..ac6f7f205e25d 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -64,6 +64,10 @@ static const int PROG_DONE = 1;
 static const __u32 KEY_SERVER_A = SERVER_A;
 static const __u32 KEY_SERVER_B = SERVER_B;
 
+static const __u16 SRC_PORT = bpf_htons(8008);
+static const __u32 SRC_IP4 = IP4(127, 0, 0, 2);
+static const __u32 SRC_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000002);
+
 static const __u16 DST_PORT = 7007; /* Host byte order */
 static const __u32 DST_IP4 = IP4(127, 0, 0, 1);
 static const __u32 DST_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000001);
@@ -398,11 +402,12 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 	if (LSW(ctx->protocol, 0) != IPPROTO_TCP)
 		return SK_DROP;
 
-	/* Narrow loads from remote_port field. Expect non-0 value. */
-	if (LSB(ctx->remote_port, 0) == 0 && LSB(ctx->remote_port, 1) == 0 &&
-	    LSB(ctx->remote_port, 2) == 0 && LSB(ctx->remote_port, 3) == 0)
+	/* Narrow loads from remote_port field. Expect SRC_PORT. */
+	if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
+	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
+	    LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port, 3) != 0)
 		return SK_DROP;
-	if (LSW(ctx->remote_port, 0) == 0)
+	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;
 
 	/* Narrow loads from local_port field. Expect DST_PORT. */
@@ -415,11 +420,14 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 
 	/* Narrow loads from IPv4 fields */
 	if (v4) {
-		/* Expect non-0.0.0.0 in remote_ip4 */
-		if (LSB(ctx->remote_ip4, 0) == 0 && LSB(ctx->remote_ip4, 1) == 0 &&
-		    LSB(ctx->remote_ip4, 2) == 0 && LSB(ctx->remote_ip4, 3) == 0)
+		/* Expect SRC_IP4 in remote_ip4 */
+		if (LSB(ctx->remote_ip4, 0) != ((SRC_IP4 >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip4, 1) != ((SRC_IP4 >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip4, 2) != ((SRC_IP4 >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip4, 3) != ((SRC_IP4 >> 24) & 0xff))
 			return SK_DROP;
-		if (LSW(ctx->remote_ip4, 0) == 0 && LSW(ctx->remote_ip4, 1) == 0)
+		if (LSW(ctx->remote_ip4, 0) != ((SRC_IP4 >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip4, 1) != ((SRC_IP4 >> 16) & 0xffff))
 			return SK_DROP;
 
 		/* Expect DST_IP4 in local_ip4 */
@@ -448,20 +456,32 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 
 	/* Narrow loads from IPv6 fields */
 	if (!v4) {
-		/* Expect non-:: IP in remote_ip6 */
-		if (LSB(ctx->remote_ip6[0], 0) == 0 && LSB(ctx->remote_ip6[0], 1) == 0 &&
-		    LSB(ctx->remote_ip6[0], 2) == 0 && LSB(ctx->remote_ip6[0], 3) == 0 &&
-		    LSB(ctx->remote_ip6[1], 0) == 0 && LSB(ctx->remote_ip6[1], 1) == 0 &&
-		    LSB(ctx->remote_ip6[1], 2) == 0 && LSB(ctx->remote_ip6[1], 3) == 0 &&
-		    LSB(ctx->remote_ip6[2], 0) == 0 && LSB(ctx->remote_ip6[2], 1) == 0 &&
-		    LSB(ctx->remote_ip6[2], 2) == 0 && LSB(ctx->remote_ip6[2], 3) == 0 &&
-		    LSB(ctx->remote_ip6[3], 0) == 0 && LSB(ctx->remote_ip6[3], 1) == 0 &&
-		    LSB(ctx->remote_ip6[3], 2) == 0 && LSB(ctx->remote_ip6[3], 3) == 0)
+		/* Expect SRC_IP6 in remote_ip6 */
+		if (LSB(ctx->remote_ip6[0], 0) != ((SRC_IP6[0] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 1) != ((SRC_IP6[0] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 2) != ((SRC_IP6[0] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[0], 3) != ((SRC_IP6[0] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 0) != ((SRC_IP6[1] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 1) != ((SRC_IP6[1] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 2) != ((SRC_IP6[1] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[1], 3) != ((SRC_IP6[1] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 0) != ((SRC_IP6[2] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 1) != ((SRC_IP6[2] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 2) != ((SRC_IP6[2] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[2], 3) != ((SRC_IP6[2] >> 24) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 0) != ((SRC_IP6[3] >> 0) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 1) != ((SRC_IP6[3] >> 8) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 2) != ((SRC_IP6[3] >> 16) & 0xff) ||
+		    LSB(ctx->remote_ip6[3], 3) != ((SRC_IP6[3] >> 24) & 0xff))
 			return SK_DROP;
-		if (LSW(ctx->remote_ip6[0], 0) == 0 && LSW(ctx->remote_ip6[0], 1) == 0 &&
-		    LSW(ctx->remote_ip6[1], 0) == 0 && LSW(ctx->remote_ip6[1], 1) == 0 &&
-		    LSW(ctx->remote_ip6[2], 0) == 0 && LSW(ctx->remote_ip6[2], 1) == 0 &&
-		    LSW(ctx->remote_ip6[3], 0) == 0 && LSW(ctx->remote_ip6[3], 1) == 0)
+		if (LSW(ctx->remote_ip6[0], 0) != ((SRC_IP6[0] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[0], 1) != ((SRC_IP6[0] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[1], 0) != ((SRC_IP6[1] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[1], 1) != ((SRC_IP6[1] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[2], 0) != ((SRC_IP6[2] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[2], 1) != ((SRC_IP6[2] >> 16) & 0xffff) ||
+		    LSW(ctx->remote_ip6[3], 0) != ((SRC_IP6[3] >> 0) & 0xffff) ||
+		    LSW(ctx->remote_ip6[3], 1) != ((SRC_IP6[3] >> 16) & 0xffff))
 			return SK_DROP;
 		/* Expect DST_IP6 in local_ip6 */
 		if (LSB(ctx->local_ip6[0], 0) != ((DST_IP6[0] >> 0) & 0xff) ||
-- 
2.33.0



