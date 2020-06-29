Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD720D9F8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388317AbgF2Twg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387699AbgF2Tk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BB1248B5;
        Mon, 29 Jun 2020 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444411;
        bh=tOrwBAVd/x0Oigir99dcKgnRdsCe7DV5Y5oW2/wsAZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zoxcgrn/lUSLtRFnTecjaUM6wn6h43UDsL47PQnDiMu6Kende1IZz1VkBpkYYNQjs
         tiYBD2mkN15n1WL3oUGILQ8T0OjLGpQSyZPL0iis7A5ePu8zjU+2t8bNcFGit5TT24
         lIlnSeQ/M0fkLbLfEGXXkXjWCC58/JEgzt7cnnNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/178] selftests/net: report etf errors correctly
Date:   Mon, 29 Jun 2020 11:23:54 -0400
Message-Id: <20200629152523.2494198-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit ca8826095e4d4afc0ccaead27bba6e4b623a12ae ]

The ETF qdisc can queue skbs that it could not pace on the errqueue.

Address a few issues in the selftest

- recv buffer size was too small, and incorrectly calculated
- compared errno to ee_code instead of ee_errno
- missed invalid request error type

v2:
  - fix a few checkpatch --strict indentation warnings

Fixes: ea6a547669b3 ("selftests/net: make so_txtime more robust to timer variance")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_txtime.c | 33 +++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 383bac05ac324..ceaad78e96674 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -15,8 +15,9 @@
 #include <inttypes.h>
 #include <linux/net_tstamp.h>
 #include <linux/errqueue.h>
+#include <linux/if_ether.h>
 #include <linux/ipv6.h>
-#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -140,8 +141,8 @@ static void do_recv_errqueue_timeout(int fdt)
 {
 	char control[CMSG_SPACE(sizeof(struct sock_extended_err)) +
 		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
-	char data[sizeof(struct ipv6hdr) +
-		  sizeof(struct tcphdr) + 1];
+	char data[sizeof(struct ethhdr) + sizeof(struct ipv6hdr) +
+		  sizeof(struct udphdr) + 1];
 	struct sock_extended_err *err;
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
@@ -159,6 +160,8 @@ static void do_recv_errqueue_timeout(int fdt)
 	msg.msg_controllen = sizeof(control);
 
 	while (1) {
+		const char *reason;
+
 		ret = recvmsg(fdt, &msg, MSG_ERRQUEUE);
 		if (ret == -1 && errno == EAGAIN)
 			break;
@@ -176,14 +179,30 @@ static void do_recv_errqueue_timeout(int fdt)
 		err = (struct sock_extended_err *)CMSG_DATA(cm);
 		if (err->ee_origin != SO_EE_ORIGIN_TXTIME)
 			error(1, 0, "errqueue: origin 0x%x\n", err->ee_origin);
-		if (err->ee_code != ECANCELED)
-			error(1, 0, "errqueue: code 0x%x\n", err->ee_code);
+
+		switch (err->ee_errno) {
+		case ECANCELED:
+			if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
+				error(1, 0, "errqueue: unknown ECANCELED %u\n",
+				      err->ee_code);
+			reason = "missed txtime";
+		break;
+		case EINVAL:
+			if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
+				error(1, 0, "errqueue: unknown EINVAL %u\n",
+				      err->ee_code);
+			reason = "invalid txtime";
+		break;
+		default:
+			error(1, 0, "errqueue: errno %u code %u\n",
+			      err->ee_errno, err->ee_code);
+		};
 
 		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
 		tstamp -= (int64_t) glob_tstart;
 		tstamp /= 1000 * 1000;
-		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
-				data[ret - 1], tstamp);
+		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
+			data[ret - 1], tstamp, reason);
 
 		msg.msg_flags = 0;
 		msg.msg_controllen = sizeof(control);
-- 
2.25.1

