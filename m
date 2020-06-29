Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CF220D91D
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgF2Tod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387642AbgF2Tkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D229248A1;
        Mon, 29 Jun 2020 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444397;
        bh=WcuCMKlaPKNUmEgNGaEVT8QUtg6D2i/bEXZXt9pM2vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOkdcr9aIJVpXAmOyw2+gLOoIoBHieqzp/wLZYkRM6HgLiQ11c9ex2gyu/iupGSgn
         BuQSP4eBPt/yikstBtgjt7pjTPd8VWtzGI3F6jjiHemm8rXAm/eWN4LJTUi5kFLawq
         6VE4hTbzcbk8lwJyzfSGf8SFFsE46K+x7JClIIkc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaurav Singh <gaurav1086@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/178] bpf, xdp, samples: Fix null pointer dereference in *_user code
Date:   Mon, 29 Jun 2020 11:23:39 -0400
Message-Id: <20200629152523.2494198-75-sashal@kernel.org>
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

From: Gaurav Singh <gaurav1086@gmail.com>

[ Upstream commit 6903cdae9f9f08d61e49c16cbef11c293e33a615 ]

Memset on the pointer right after malloc can cause a NULL pointer
deference if it failed to allocate memory. A simple fix is to
replace malloc()/memset() pair with a simple call to calloc().

Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_monitor_user.c      |  8 ++------
 samples/bpf/xdp_redirect_cpu_user.c |  7 ++-----
 samples/bpf/xdp_rxq_info_user.c     | 13 +++----------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index dd558cbb23094..ef53b93db5732 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -509,11 +509,8 @@ static void *alloc_rec_per_cpu(int record_size)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	void *array;
-	size_t size;
 
-	size = record_size * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, record_size);
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -528,8 +525,7 @@ static struct stats_record *alloc_stats_record(void)
 	int i;
 
 	/* Alloc main stats_record structure */
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 767869e3b308f..0a76725568225 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -210,11 +210,8 @@ static struct datarec *alloc_record_per_cpu(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec *array;
-	size_t size;
 
-	size = sizeof(struct datarec) * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -229,11 +226,11 @@ static struct stats_record *alloc_stats_record(void)
 
 	size = sizeof(*rec) + n_cpus * sizeof(struct record);
 	rec = malloc(size);
-	memset(rec, 0, size);
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
 	}
+	memset(rec, 0, size);
 	rec->rx_cnt.cpu    = alloc_record_per_cpu();
 	rec->redir_err.cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index b88df17853b84..21d6e5067a839 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -198,11 +198,8 @@ static struct datarec *alloc_record_per_cpu(void)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec *array;
-	size_t size;
 
-	size = sizeof(struct datarec) * nr_cpus;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_cpus, sizeof(struct datarec));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
 		exit(EXIT_FAIL_MEM);
@@ -214,11 +211,8 @@ static struct record *alloc_record_per_rxq(void)
 {
 	unsigned int nr_rxqs = bpf_map__def(rx_queue_index_map)->max_entries;
 	struct record *array;
-	size_t size;
 
-	size = sizeof(struct record) * nr_rxqs;
-	array = malloc(size);
-	memset(array, 0, size);
+	array = calloc(nr_rxqs, sizeof(struct record));
 	if (!array) {
 		fprintf(stderr, "Mem alloc error (nr_rxqs:%u)\n", nr_rxqs);
 		exit(EXIT_FAIL_MEM);
@@ -232,8 +226,7 @@ static struct stats_record *alloc_stats_record(void)
 	struct stats_record *rec;
 	int i;
 
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	rec = calloc(1, sizeof(struct stats_record));
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
-- 
2.25.1

