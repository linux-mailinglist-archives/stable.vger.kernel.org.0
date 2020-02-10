Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A0D1577AC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgBJNBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:01:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729781AbgBJMkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:41 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72F8B2467A;
        Mon, 10 Feb 2020 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338440;
        bh=j+F8/QXxjYYhd5E9o7jGm+TxXK2oZB9TvZwAjvQnMTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLXkkrcMpM0EQuSKr4YqsIxFnDAoXvbUVEsEue9vBeffsX+56EsxmF1ETrrbAtC1M
         I0VxzTU1+QJIUpJcjgM2IIssAMTmLcoxs7kBTSQQu0lEi8+/eR4p4oqk1CaFmvCmxK
         WqUba8nvSRK4S0cadzqDZeHCSPwanzAkKWAUDbXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.5 160/367] libbpf: Dont attach perf_buffer to offline/missing CPUs
Date:   Mon, 10 Feb 2020 04:31:13 -0800
Message-Id: <20200210122439.600419382@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

commit 783b8f01f5942a786998f5577bd9ff3992f22a1a upstream.

It's quite common on some systems to have more CPUs enlisted as "possible",
than there are (and could ever be) present/online CPUs. In such cases,
perf_buffer creationg will fail due to inability to create perf event on
missing CPU with error like this:

libbpf: failed to open perf buffer event on cpu #16: No such device

This patch fixes the logic of perf_buffer__new() to ignore CPUs that are
missing or currently offline. In rare cases where user explicitly listed
specific CPUs to connect to, behavior is unchanged: libbpf will try to open
perf event buffer on specified CPU(s) anyways.

Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191212013609.1691168-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/libbpf.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5945,7 +5945,7 @@ struct perf_buffer {
 	size_t mmap_size;
 	struct perf_cpu_buf **cpu_bufs;
 	struct epoll_event *events;
-	int cpu_cnt;
+	int cpu_cnt; /* number of allocated CPU buffers */
 	int epoll_fd; /* perf event FD */
 	int map_fd; /* BPF_MAP_TYPE_PERF_EVENT_ARRAY BPF map FD */
 };
@@ -6079,11 +6079,13 @@ perf_buffer__new_raw(int map_fd, size_t
 static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 					      struct perf_buffer_params *p)
 {
+	const char *online_cpus_file = "/sys/devices/system/cpu/online";
 	struct bpf_map_info map = {};
 	char msg[STRERR_BUFSIZE];
 	struct perf_buffer *pb;
+	bool *online = NULL;
 	__u32 map_info_len;
-	int err, i;
+	int err, i, j, n;
 
 	if (page_cnt & (page_cnt - 1)) {
 		pr_warn("page count should be power of two, but is %zu\n",
@@ -6152,20 +6154,32 @@ static struct perf_buffer *__perf_buffer
 		goto error;
 	}
 
-	for (i = 0; i < pb->cpu_cnt; i++) {
+	err = parse_cpu_mask_file(online_cpus_file, &online, &n);
+	if (err) {
+		pr_warn("failed to get online CPU mask: %d\n", err);
+		goto error;
+	}
+
+	for (i = 0, j = 0; i < pb->cpu_cnt; i++) {
 		struct perf_cpu_buf *cpu_buf;
 		int cpu, map_key;
 
 		cpu = p->cpu_cnt > 0 ? p->cpus[i] : i;
 		map_key = p->cpu_cnt > 0 ? p->map_keys[i] : i;
 
+		/* in case user didn't explicitly requested particular CPUs to
+		 * be attached to, skip offline/not present CPUs
+		 */
+		if (p->cpu_cnt <= 0 && (cpu >= n || !online[cpu]))
+			continue;
+
 		cpu_buf = perf_buffer__open_cpu_buf(pb, p->attr, cpu, map_key);
 		if (IS_ERR(cpu_buf)) {
 			err = PTR_ERR(cpu_buf);
 			goto error;
 		}
 
-		pb->cpu_bufs[i] = cpu_buf;
+		pb->cpu_bufs[j] = cpu_buf;
 
 		err = bpf_map_update_elem(pb->map_fd, &map_key,
 					  &cpu_buf->fd, 0);
@@ -6177,21 +6191,25 @@ static struct perf_buffer *__perf_buffer
 			goto error;
 		}
 
-		pb->events[i].events = EPOLLIN;
-		pb->events[i].data.ptr = cpu_buf;
+		pb->events[j].events = EPOLLIN;
+		pb->events[j].data.ptr = cpu_buf;
 		if (epoll_ctl(pb->epoll_fd, EPOLL_CTL_ADD, cpu_buf->fd,
-			      &pb->events[i]) < 0) {
+			      &pb->events[j]) < 0) {
 			err = -errno;
 			pr_warn("failed to epoll_ctl cpu #%d perf FD %d: %s\n",
 				cpu, cpu_buf->fd,
 				libbpf_strerror_r(err, msg, sizeof(msg)));
 			goto error;
 		}
+		j++;
 	}
+	pb->cpu_cnt = j;
+	free(online);
 
 	return pb;
 
 error:
+	free(online);
 	if (pb)
 		perf_buffer__free(pb);
 	return ERR_PTR(err);


