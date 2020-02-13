Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804B615C430
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgBMP1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgBMP1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:18 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CDC206DB;
        Thu, 13 Feb 2020 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607637;
        bh=uXHAlkeBHn3E/t2VnFzPT+P6qV46bbGDPnOCUUOx6Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKf/qOYuj5usB24G7qjSmXKeG+HO2X/2Jh6nh1M+QHbuaf3Zf45unCgsDH/7ePKC2
         f1Uu2PkZJ6MRW8CzW2f+1JvYfr0ROIEQDlaq5sKXrJeXFc0FeLZp+m6QdAQxocENQX
         E3lH8VWx+SQk3R44TfhFDYI81VL/15RYnup7+bzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.4 24/96] selftests/bpf: Test freeing sockmap/sockhash with a socket in it
Date:   Thu, 13 Feb 2020 07:20:31 -0800
Message-Id: <20200213151848.506659123@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 5d3919a953c3c96c02fc7a337f8376cde43ae31f upstream.

Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
down") introduced sleeping issues inside RCU critical sections and while
holding a spinlock on sockmap/sockhash tear-down. There has to be at least
one socket in the map for the problem to surface.

This adds a test that triggers the warnings for broken locking rules. Not a
fix per se, but rather tooling to verify the accompanying fixes. Run on a
VM with 1 vCPU to reproduce the warnings.

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200206111652.694507-4-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c |   74 +++++++++++++++++
 1 file changed, 74 insertions(+)

--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+
+#include "test_progs.h"
+
+static int connected_socket_v4(void)
+{
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_port = htons(80),
+		.sin_addr = { inet_addr("127.0.0.1") },
+	};
+	socklen_t len = sizeof(addr);
+	int s, repair, err;
+
+	s = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK_FAIL(s == -1))
+		goto error;
+
+	repair = TCP_REPAIR_ON;
+	err = setsockopt(s, SOL_TCP, TCP_REPAIR, &repair, sizeof(repair));
+	if (CHECK_FAIL(err))
+		goto error;
+
+	err = connect(s, (struct sockaddr *)&addr, len);
+	if (CHECK_FAIL(err))
+		goto error;
+
+	repair = TCP_REPAIR_OFF_NO_WP;
+	err = setsockopt(s, SOL_TCP, TCP_REPAIR, &repair, sizeof(repair));
+	if (CHECK_FAIL(err))
+		goto error;
+
+	return s;
+error:
+	perror(__func__);
+	close(s);
+	return -1;
+}
+
+/* Create a map, populate it with one socket, and free the map. */
+static void test_sockmap_create_update_free(enum bpf_map_type map_type)
+{
+	const int zero = 0;
+	int s, map, err;
+
+	s = connected_socket_v4();
+	if (CHECK_FAIL(s == -1))
+		return;
+
+	map = bpf_create_map(map_type, sizeof(int), sizeof(int), 1, 0);
+	if (CHECK_FAIL(map == -1)) {
+		perror("bpf_create_map");
+		goto out;
+	}
+
+	err = bpf_map_update_elem(map, &zero, &s, BPF_NOEXIST);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_update");
+		goto out;
+	}
+
+out:
+	close(map);
+	close(s);
+}
+
+void test_sockmap_basic(void)
+{
+	if (test__start_subtest("sockmap create_update_free"))
+		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKMAP);
+	if (test__start_subtest("sockhash create_update_free"))
+		test_sockmap_create_update_free(BPF_MAP_TYPE_SOCKHASH);
+}


