Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3443C53FC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349378AbhGLH4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351400AbhGLHvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF36610D1;
        Mon, 12 Jul 2021 07:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076137;
        bh=+RzFM+rthSAvLTTRDDU15Kk30txzb6o8uc9cRcG6qII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2IjvR/mYfgZWt0UOk4GqQla7yunvDlq0DwVoA8L9/gh3DN+g8yfE/FouNMS8LZsX
         oV581PAebPZGsxnlOCUB1XqYQoPpfGQx9yKyKiedqoEUAldmLHm0Jt76uLItHRJGKM
         fhOBMg/Ff/t+7abZ7A5bRjtyQ7LHsqpy1Z8lXjMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 512/800] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
Date:   Mon, 12 Jul 2021 08:08:55 +0200
Message-Id: <20210712061021.664437716@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit a7e65fe7d8201527129206754db1a2db6a6b2fde ]

We use non-blocking sockets for testing sockmap redirections,
and got some random EAGAIN errors from UDP tests.

There is no guarantee the packet would be immediately available
to receive as soon as it is sent out, even on the local host.
For UDP, this is especially true because it does not lock the
sock during BH (unlike the TCP path). This is probably why we
only saw this error in UDP cases.

No matter how hard we try to make the queue empty check accurate,
it is always possible for recvmsg() to beat ->sk_data_ready().
Therefore, we should just retry in case of EAGAIN.

Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20210615021342.7416-3-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 648d9ae898d2..01ab11259809 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1610,6 +1610,7 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	struct sockaddr_storage addr;
 	int c0, c1, p0, p1;
 	unsigned int pass;
+	int retries = 100;
 	socklen_t len;
 	int err, n;
 	u64 value;
@@ -1686,9 +1687,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
 	if (pass != 1)
 		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
 
+again:
 	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
-	if (n < 0)
+	if (n < 0) {
+		if (errno == EAGAIN && retries--)
+			goto again;
 		FAIL_ERRNO("%s: read", log_prefix);
+	}
 	if (n == 0)
 		FAIL("%s: incomplete read", log_prefix);
 
-- 
2.30.2



