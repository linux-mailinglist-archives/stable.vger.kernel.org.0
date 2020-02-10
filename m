Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5691579E9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgBJNS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgBJMhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:50 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75787208C4;
        Mon, 10 Feb 2020 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338269;
        bh=860PfVHuVvVmnE/uxN+52Ty0cY9gG8ZaYg2GcEvQW/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOk/4hsiCPi8KJrQrcdihdowkL0daoVDZ1JAqZFnJIh0bSH+C7SODYK0OQsppibJW
         gSStnLhk38WohzBCjTbEt1qQkRfpqK/tnNsstjtvYXF7IPlLxcwoXztVwdzLCymHN9
         o4yDwVypVucY16yorkX3DF+0+m2ipeY6qW2CZzeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.4 150/309] samples/bpf: Xdp_redirect_cpu fix missing tracepoint attach
Date:   Mon, 10 Feb 2020 04:31:46 -0800
Message-Id: <20200210122420.701561981@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

commit f9e6bfdbaf0cf304d72c70a05d81acac01a04f48 upstream.

When sample xdp_redirect_cpu was converted to use libbpf, the
tracepoints used by this sample were not getting attached automatically
like with bpf_load.c. The BPF-maps was still getting loaded, thus
nobody notice that the tracepoints were not updating these maps.

This fix doesn't use the new skeleton code, as this bug was introduced
in v5.1 and stable might want to backport this. E.g. Red Hat QA uses
this sample as part of their testing.

Fixes: bbaf6029c49c ("samples/bpf: Convert XDP samples to libbpf usage")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/157685877642.26195.2798780195186786841.stgit@firesoul
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 samples/bpf/xdp_redirect_cpu_user.c |   59 +++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -16,6 +16,10 @@ static const char *__doc__ =
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
+#include <linux/limits.h>
+
+#define __must_check
+#include <linux/err.h>
 
 #include <arpa/inet.h>
 #include <linux/if_link.h>
@@ -46,6 +50,10 @@ static int cpus_count_map_fd;
 static int cpus_iterator_map_fd;
 static int exception_cnt_map_fd;
 
+#define NUM_TP 5
+struct bpf_link *tp_links[NUM_TP] = { 0 };
+static int tp_cnt = 0;
+
 /* Exit return codes */
 #define EXIT_OK		0
 #define EXIT_FAIL		1
@@ -88,6 +96,10 @@ static void int_exit(int sig)
 			printf("program on interface changed, not removing\n");
 		}
 	}
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
 	exit(EXIT_OK);
 }
 
@@ -588,23 +600,61 @@ static void stats_poll(int interval, boo
 	free_stats_record(prev);
 }
 
+static struct bpf_link * attach_tp(struct bpf_object *obj,
+				   const char *tp_category,
+				   const char* tp_name)
+{
+	struct bpf_program *prog;
+	struct bpf_link *link;
+	char sec_name[PATH_MAX];
+	int len;
+
+	len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
+		       tp_category, tp_name);
+	if (len < 0)
+		exit(EXIT_FAIL);
+
+	prog = bpf_object__find_program_by_title(obj, sec_name);
+	if (!prog) {
+		fprintf(stderr, "ERR: finding progsec: %s\n", sec_name);
+		exit(EXIT_FAIL_BPF);
+	}
+
+	link = bpf_program__attach_tracepoint(prog, tp_category, tp_name);
+	if (IS_ERR(link))
+		exit(EXIT_FAIL_BPF);
+
+	return link;
+}
+
+static void init_tracepoints(struct bpf_object *obj) {
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_err");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_map_err");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_exception");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_enqueue");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_kthread");
+}
+
 static int init_map_fds(struct bpf_object *obj)
 {
-	cpu_map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
-	rx_cnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
+	/* Maps updated by tracepoints */
 	redirect_err_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "redirect_err_cnt");
+	exception_cnt_map_fd =
+		bpf_object__find_map_fd_by_name(obj, "exception_cnt");
 	cpumap_enqueue_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpumap_enqueue_cnt");
 	cpumap_kthread_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpumap_kthread_cnt");
+
+	/* Maps used by XDP */
+	rx_cnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
+	cpu_map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
 	cpus_available_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpus_available");
 	cpus_count_map_fd = bpf_object__find_map_fd_by_name(obj, "cpus_count");
 	cpus_iterator_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpus_iterator");
-	exception_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "exception_cnt");
 
 	if (cpu_map_fd < 0 || rx_cnt_map_fd < 0 ||
 	    redirect_err_cnt_map_fd < 0 || cpumap_enqueue_cnt_map_fd < 0 ||
@@ -662,6 +712,7 @@ int main(int argc, char **argv)
 			strerror(errno));
 		return EXIT_FAIL;
 	}
+	init_tracepoints(obj);
 	if (init_map_fds(obj) < 0) {
 		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
 		return EXIT_FAIL;


