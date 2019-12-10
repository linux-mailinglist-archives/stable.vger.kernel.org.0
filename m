Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC10911944B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfLJVOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729439AbfLJVNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9446B20838;
        Tue, 10 Dec 2019 21:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012427;
        bh=yqx72H2vXF6J6QbDXFlx295h0kTpuICaRywV8UDBDvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz7hyZfW2kvCSpaZkDBv6s51IgCnfW2c32eDWoFjyVB74OpX8RiIV3YqvBH/Z52K/
         WSViM6evhgDyl/Ph4R7yuiip2jAXI+6ov6RxnWVZ9JLGiEQM/xOaDJCjAK3Ew5CZMi
         vEf9gYml6PrxcYloWGUuUUcyXgBEb9yATJgWtyYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 341/350] perf record: Add a function to test for kernel support for AUX area sampling
Date:   Tue, 10 Dec 2019 16:07:26 -0500
Message-Id: <20191210210735.9077-302-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 9bca1a4ef5034f0a82861ac0375eb0272c5ce04e ]

Architectures are expected to know if AUX area sampling is supported by
the hardware. Add a function perf_can_aux_sample() which will determine
whether the kernel supports it.

Committer notes:

I reported that this message was taking place on a kernel without the
required bits:

  # perf record --aux-sample -e '{intel_pt//u,branch-misses:u}'
  Error:
  The sys_perf_event_open() syscall returned with 7 (Argument list too long) for event (branch-misses:u).
  /bin/dmesg | grep -i perf may provide additional information.

Adrian sent a patch addressing it, with this explanation:

 ----
  perf_can_aux_sample_size() always returned true because it did not pass
  the attribute size to sys_perf_event_open, nor correctly check the
  return value and errno.
 ----

After applying it I get, later in the series, when --aux-sample is
added:

  # perf record --aux-sample -e '{intel_pt//u,branch-misses:u}'
  AUX area sampling is not supported by kernel

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20191115124225.5247-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.h |  1 +
 tools/perf/util/record.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7cfe75522ba5f..d89e72bd1c814 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -164,6 +164,7 @@ void perf_evlist__set_id_pos(struct evlist *evlist);
 bool perf_can_sample_identifier(void);
 bool perf_can_record_switch_events(void);
 bool perf_can_record_cpu_wide(void);
+bool perf_can_aux_sample(void);
 void perf_evlist__config(struct evlist *evlist, struct record_opts *opts,
 			 struct callchain_param *callchain);
 int record_opts__config(struct record_opts *opts);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 8579505c29a4d..7def661685032 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -136,6 +136,37 @@ bool perf_can_record_cpu_wide(void)
 	return true;
 }
 
+/*
+ * Architectures are expected to know if AUX area sampling is supported by the
+ * hardware. Here we check for kernel support.
+ */
+bool perf_can_aux_sample(void)
+{
+	struct perf_event_attr attr = {
+		.size = sizeof(struct perf_event_attr),
+		.exclude_kernel = 1,
+		/*
+		 * Non-zero value causes the kernel to calculate the effective
+		 * attribute size up to that byte.
+		 */
+		.aux_sample_size = 1,
+	};
+	int fd;
+
+	fd = sys_perf_event_open(&attr, -1, 0, -1, 0);
+	/*
+	 * If the kernel attribute is big enough to contain aux_sample_size
+	 * then we assume that it is supported. We are relying on the kernel to
+	 * validate the attribute size before anything else that could be wrong.
+	 */
+	if (fd < 0 && errno == E2BIG)
+		return false;
+	if (fd >= 0)
+		close(fd);
+
+	return true;
+}
+
 void perf_evlist__config(struct evlist *evlist, struct record_opts *opts,
 			 struct callchain_param *callchain)
 {
-- 
2.20.1

