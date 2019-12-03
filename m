Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3039111C8F
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfLCWpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbfLCWpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05377207DD;
        Tue,  3 Dec 2019 22:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413110;
        bh=zu+sqw2iuBQpxvHwWCWDs3LdcAd3OGvse7iGBAp+gGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sord+HX/p2QufqVArD1I7us7MQiGetXsMhfkE+8do+0iarEPy72DGv51VI7aVtZTY
         hyOzYfeWxWTGA/PSbJPL01UfJ4/2xKrY5FlG9c+Al7Ei4rQqN/603fCKpFq8MHGuMd
         DY2lK7ekWMrbXFphLeSZAhM+sjEz32tiefp1Ergk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 129/135] selftests: bpf: correct perror strings
Date:   Tue,  3 Dec 2019 23:36:09 +0100
Message-Id: <20191203213045.417085200@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit e5dc9dd3258098bf8b5ceb75fc3433b41eff618a ]

perror(str) is basically equivalent to
print("%s: %s\n", str, strerror(errno)).
New line or colon at the end of str is
a mistake/breaks formatting.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_sockmap.c |   38 ++++++++++++++---------------
 tools/testing/selftests/bpf/xdping.c       |    2 -
 2 files changed, 20 insertions(+), 20 deletions(-)

--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -240,14 +240,14 @@ static int sockmap_init_sockets(int verb
 	addr.sin_port = htons(S1_PORT);
 	err = bind(s1, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0) {
-		perror("bind s1 failed()\n");
+		perror("bind s1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = bind(s2, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0) {
-		perror("bind s2 failed()\n");
+		perror("bind s2 failed()");
 		return errno;
 	}
 
@@ -255,14 +255,14 @@ static int sockmap_init_sockets(int verb
 	addr.sin_port = htons(S1_PORT);
 	err = listen(s1, 32);
 	if (err < 0) {
-		perror("listen s1 failed()\n");
+		perror("listen s1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = listen(s2, 32);
 	if (err < 0) {
-		perror("listen s1 failed()\n");
+		perror("listen s1 failed()");
 		return errno;
 	}
 
@@ -270,14 +270,14 @@ static int sockmap_init_sockets(int verb
 	addr.sin_port = htons(S1_PORT);
 	err = connect(c1, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0 && errno != EINPROGRESS) {
-		perror("connect c1 failed()\n");
+		perror("connect c1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = connect(c2, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0 && errno != EINPROGRESS) {
-		perror("connect c2 failed()\n");
+		perror("connect c2 failed()");
 		return errno;
 	} else if (err < 0) {
 		err = 0;
@@ -286,13 +286,13 @@ static int sockmap_init_sockets(int verb
 	/* Accept Connecrtions */
 	p1 = accept(s1, NULL, NULL);
 	if (p1 < 0) {
-		perror("accept s1 failed()\n");
+		perror("accept s1 failed()");
 		return errno;
 	}
 
 	p2 = accept(s2, NULL, NULL);
 	if (p2 < 0) {
-		perror("accept s1 failed()\n");
+		perror("accept s1 failed()");
 		return errno;
 	}
 
@@ -353,7 +353,7 @@ static int msg_loop_sendpage(int fd, int
 		int sent = sendfile(fd, fp, NULL, iov_length);
 
 		if (!drop && sent < 0) {
-			perror("send loop error:");
+			perror("send loop error");
 			close(fp);
 			return sent;
 		} else if (drop && sent >= 0) {
@@ -472,7 +472,7 @@ static int msg_loop(int fd, int iov_coun
 			int sent = sendmsg(fd, &msg, flags);
 
 			if (!drop && sent < 0) {
-				perror("send loop error:");
+				perror("send loop error");
 				goto out_errno;
 			} else if (drop && sent >= 0) {
 				printf("send loop error expected: %i\n", sent);
@@ -508,7 +508,7 @@ static int msg_loop(int fd, int iov_coun
 		total_bytes -= txmsg_pop_total;
 		err = clock_gettime(CLOCK_MONOTONIC, &s->start);
 		if (err < 0)
-			perror("recv start time: ");
+			perror("recv start time");
 		while (s->bytes_recvd < total_bytes) {
 			if (txmsg_cork) {
 				timeout.tv_sec = 0;
@@ -552,7 +552,7 @@ static int msg_loop(int fd, int iov_coun
 			if (recv < 0) {
 				if (errno != EWOULDBLOCK) {
 					clock_gettime(CLOCK_MONOTONIC, &s->end);
-					perror("recv failed()\n");
+					perror("recv failed()");
 					goto out_errno;
 				}
 			}
@@ -566,7 +566,7 @@ static int msg_loop(int fd, int iov_coun
 
 				errno = msg_verify_data(&msg, recv, chunk_sz);
 				if (errno) {
-					perror("data verify msg failed\n");
+					perror("data verify msg failed");
 					goto out_errno;
 				}
 				if (recvp) {
@@ -574,7 +574,7 @@ static int msg_loop(int fd, int iov_coun
 								recvp,
 								chunk_sz);
 					if (errno) {
-						perror("data verify msg_peek failed\n");
+						perror("data verify msg_peek failed");
 						goto out_errno;
 					}
 				}
@@ -663,7 +663,7 @@ static int sendmsg_test(struct sockmap_o
 			err = 0;
 		exit(err ? 1 : 0);
 	} else if (rxpid == -1) {
-		perror("msg_loop_rx: ");
+		perror("msg_loop_rx");
 		return errno;
 	}
 
@@ -690,7 +690,7 @@ static int sendmsg_test(struct sockmap_o
 				s.bytes_recvd, recvd_Bps, recvd_Bps/giga);
 		exit(err ? 1 : 0);
 	} else if (txpid == -1) {
-		perror("msg_loop_tx: ");
+		perror("msg_loop_tx");
 		return errno;
 	}
 
@@ -724,7 +724,7 @@ static int forever_ping_pong(int rate, s
 	/* Ping/Pong data from client to server */
 	sc = send(c1, buf, sizeof(buf), 0);
 	if (sc < 0) {
-		perror("send failed()\n");
+		perror("send failed()");
 		return sc;
 	}
 
@@ -757,7 +757,7 @@ static int forever_ping_pong(int rate, s
 			rc = recv(i, buf, sizeof(buf), 0);
 			if (rc < 0) {
 				if (errno != EWOULDBLOCK) {
-					perror("recv failed()\n");
+					perror("recv failed()");
 					return rc;
 				}
 			}
@@ -769,7 +769,7 @@ static int forever_ping_pong(int rate, s
 
 			sc = send(i, buf, rc, 0);
 			if (sc < 0) {
-				perror("send failed()\n");
+				perror("send failed()");
 				return sc;
 			}
 		}
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -45,7 +45,7 @@ static int get_stats(int fd, __u16 count
 	printf("\nXDP RTT data:\n");
 
 	if (bpf_map_lookup_elem(fd, &raddr, &pinginfo)) {
-		perror("bpf_map_lookup elem: ");
+		perror("bpf_map_lookup elem");
 		return 1;
 	}
 


