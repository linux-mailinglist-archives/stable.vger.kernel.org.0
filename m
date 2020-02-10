Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4DC1576C6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgBJMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgBJMlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:51 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 402F621739;
        Mon, 10 Feb 2020 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338510;
        bh=pRwRD3ZE8xzRD0Zm+JXqrBWFlueuFoeXcvo7GCnrYAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuBkl1aXYnn8zYx2J3lhV96JAEFuj36azuqZca0PthDYyuVcbvGBSbUKEtw4wg7BF
         gLXMtJHKhcsxxJBfTM2LNiL5BJN/ljtP9FJ0igwJ+o/S8a6H+bqQrHKnbTNLShZeG1
         +FSDuuxpSmmfBkOtWnUD4r8YjSXOdZd3d2U8nJNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.5 314/367] libbpf: Extract and generalize CPU mask parsing logic
Date:   Mon, 10 Feb 2020 04:33:47 -0800
Message-Id: <20200210122452.209150060@linuxfoundation.org>
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

commit 6803ee25f0ead1e836808acb14396bb9a9849113 upstream.

This logic is re-used for parsing a set of online CPUs. Having it as an
isolated piece of code working with input string makes it conveninent to test
this logic as well. While refactoring, also improve the robustness of original
implementation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191212013548.1690564-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/bpf/libbpf.c          |  127 ++++++++++++++++++++++++++--------------
 tools/lib/bpf/libbpf_internal.h |    2 
 2 files changed, 87 insertions(+), 42 deletions(-)

--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6542,61 +6542,104 @@ void bpf_program__bpil_offs_to_addr(stru
 	}
 }
 
-int libbpf_num_possible_cpus(void)
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
 {
-	static const char *fcpu = "/sys/devices/system/cpu/possible";
-	int len = 0, n = 0, il = 0, ir = 0;
-	unsigned int start = 0, end = 0;
-	int tmp_cpus = 0;
-	static int cpus;
-	char buf[128];
-	int error = 0;
-	int fd = -1;
+	int err = 0, n, len, start, end = -1;
+	bool *tmp;
 
-	tmp_cpus = READ_ONCE(cpus);
-	if (tmp_cpus > 0)
-		return tmp_cpus;
+	*mask = NULL;
+	*mask_sz = 0;
+
+	/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
+	while (*s) {
+		if (*s == ',' || *s == '\n') {
+			s++;
+			continue;
+		}
+		n = sscanf(s, "%d%n-%d%n", &start, &len, &end, &len);
+		if (n <= 0 || n > 2) {
+			pr_warn("Failed to get CPU range %s: %d\n", s, n);
+			err = -EINVAL;
+			goto cleanup;
+		} else if (n == 1) {
+			end = start;
+		}
+		if (start < 0 || start > end) {
+			pr_warn("Invalid CPU range [%d,%d] in %s\n",
+				start, end, s);
+			err = -EINVAL;
+			goto cleanup;
+		}
+		tmp = realloc(*mask, end + 1);
+		if (!tmp) {
+			err = -ENOMEM;
+			goto cleanup;
+		}
+		*mask = tmp;
+		memset(tmp + *mask_sz, 0, start - *mask_sz);
+		memset(tmp + start, 1, end - start + 1);
+		*mask_sz = end + 1;
+		s += len;
+	}
+	if (!*mask_sz) {
+		pr_warn("Empty CPU range\n");
+		return -EINVAL;
+	}
+	return 0;
+cleanup:
+	free(*mask);
+	*mask = NULL;
+	return err;
+}
+
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
+{
+	int fd, err = 0, len;
+	char buf[128];
 
 	fd = open(fcpu, O_RDONLY);
 	if (fd < 0) {
-		error = errno;
-		pr_warn("Failed to open file %s: %s\n", fcpu, strerror(error));
-		return -error;
+		err = -errno;
+		pr_warn("Failed to open cpu mask file %s: %d\n", fcpu, err);
+		return err;
 	}
 	len = read(fd, buf, sizeof(buf));
 	close(fd);
 	if (len <= 0) {
-		error = len ? errno : EINVAL;
-		pr_warn("Failed to read # of possible cpus from %s: %s\n",
-			fcpu, strerror(error));
-		return -error;
-	}
-	if (len == sizeof(buf)) {
-		pr_warn("File %s size overflow\n", fcpu);
-		return -EOVERFLOW;
+		err = len ? -errno : -EINVAL;
+		pr_warn("Failed to read cpu mask from %s: %d\n", fcpu, err);
+		return err;
+	}
+	if (len >= sizeof(buf)) {
+		pr_warn("CPU mask is too big in file %s\n", fcpu);
+		return -E2BIG;
 	}
 	buf[len] = '\0';
 
-	for (ir = 0, tmp_cpus = 0; ir <= len; ir++) {
-		/* Each sub string separated by ',' has format \d+-\d+ or \d+ */
-		if (buf[ir] == ',' || buf[ir] == '\0') {
-			buf[ir] = '\0';
-			n = sscanf(&buf[il], "%u-%u", &start, &end);
-			if (n <= 0) {
-				pr_warn("Failed to get # CPUs from %s\n",
-					&buf[il]);
-				return -EINVAL;
-			} else if (n == 1) {
-				end = start;
-			}
-			tmp_cpus += end - start + 1;
-			il = ir + 1;
-		}
-	}
-	if (tmp_cpus <= 0) {
-		pr_warn("Invalid #CPUs %d from %s\n", tmp_cpus, fcpu);
-		return -EINVAL;
+	return parse_cpu_mask_str(buf, mask, mask_sz);
+}
+
+int libbpf_num_possible_cpus(void)
+{
+	static const char *fcpu = "/sys/devices/system/cpu/possible";
+	static int cpus;
+	int err, n, i, tmp_cpus;
+	bool *mask;
+
+	tmp_cpus = READ_ONCE(cpus);
+	if (tmp_cpus > 0)
+		return tmp_cpus;
+
+	err = parse_cpu_mask_file(fcpu, &mask, &n);
+	if (err)
+		return err;
+
+	tmp_cpus = 0;
+	for (i = 0; i < n; i++) {
+		if (mask[i])
+			tmp_cpus++;
 	}
+	free(mask);
 
 	WRITE_ONCE(cpus, tmp_cpus);
 	return tmp_cpus;
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -95,6 +95,8 @@ static inline bool libbpf_validate_opts(
 #define OPTS_GET(opts, field, fallback_value) \
 	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
 
+int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz);
+int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 


