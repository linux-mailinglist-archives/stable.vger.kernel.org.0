Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42402157803
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgBJNE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbgBJMkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:14 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1676A20661;
        Mon, 10 Feb 2020 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338414;
        bh=w5A4eA5jMsXvzpUtja3e+W6Wm1p/u6dChInaxePgKbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/PuzdaNSv51udF3b54qaGldo74WY5snI6ZdMdvufbySBrRHZKYySHTUG6lJ6I2V+
         asYyycBRSTowqQxekEdpTDiw4a/aRImLHy5ffauXSX95Kf26B7sk/iUtQfN+H3H1J9
         /u379oWKucptcNJX667Te6I7IyylP2dbaw8SUMJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.5 127/367] cpupower: Revert library ABI changes from commit ae2917093fb60bdc1ed3e
Date:   Mon, 10 Feb 2020 04:30:40 -0800
Message-Id: <20200210122436.582325663@linuxfoundation.org>
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

From: Thomas Renninger <trenn@suse.de>

commit 41ddb7e1f79693d904502ae9bea609837973eff8 upstream.

Commit ae2917093fb6 ("tools/power/cpupower: Display boost frequency
separately") modified the library function:

struct cpufreq_available_frequencies
*cpufreq_get_available_frequencies(unsigned int cpu)

to
struct cpufreq_frequencies
*cpufreq_get_frequencies(const char *type, unsigned int cpu)

This patch recovers the old API and implements the new functionality
in a newly introduce method:
struct cpufreq_boost_frequencies
*cpufreq_get_available_frequencies(unsigned int cpu)

This one should get merged into stable kernels back to 5.0 when
the above had been introduced.

Fixes: ae2917093fb6 ("tools/power/cpupower: Display boost frequency separately")

Cc: stable@vger.kernel.org
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/power/cpupower/lib/cpufreq.c        |   78 ++++++++++++++++++++++++++----
 tools/power/cpupower/lib/cpufreq.h        |   20 +++++--
 tools/power/cpupower/utils/cpufreq-info.c |   12 ++--
 3 files changed, 87 insertions(+), 23 deletions(-)

--- a/tools/power/cpupower/lib/cpufreq.c
+++ b/tools/power/cpupower/lib/cpufreq.c
@@ -332,21 +332,74 @@ void cpufreq_put_available_governors(str
 }
 
 
-struct cpufreq_frequencies
-*cpufreq_get_frequencies(const char *type, unsigned int cpu)
+struct cpufreq_available_frequencies
+*cpufreq_get_available_frequencies(unsigned int cpu)
 {
-	struct cpufreq_frequencies *first = NULL;
-	struct cpufreq_frequencies *current = NULL;
+	struct cpufreq_available_frequencies *first = NULL;
+	struct cpufreq_available_frequencies *current = NULL;
 	char one_value[SYSFS_PATH_MAX];
 	char linebuf[MAX_LINE_LEN];
-	char fname[MAX_LINE_LEN];
 	unsigned int pos, i;
 	unsigned int len;
 
-	snprintf(fname, MAX_LINE_LEN, "scaling_%s_frequencies", type);
+	len = sysfs_cpufreq_read_file(cpu, "scaling_available_frequencies",
+				      linebuf, sizeof(linebuf));
+	if (len == 0)
+		return NULL;
+
+	pos = 0;
+	for (i = 0; i < len; i++) {
+		if (linebuf[i] == ' ' || linebuf[i] == '\n') {
+			if (i - pos < 2)
+				continue;
+			if (i - pos >= SYSFS_PATH_MAX)
+				goto error_out;
+			if (current) {
+				current->next = malloc(sizeof(*current));
+				if (!current->next)
+					goto error_out;
+				current = current->next;
+			} else {
+				first = malloc(sizeof(*first));
+				if (!first)
+					goto error_out;
+				current = first;
+			}
+			current->first = first;
+			current->next = NULL;
+
+			memcpy(one_value, linebuf + pos, i - pos);
+			one_value[i - pos] = '\0';
+			if (sscanf(one_value, "%lu", &current->frequency) != 1)
+				goto error_out;
+
+			pos = i + 1;
+		}
+	}
+
+	return first;
+
+ error_out:
+	while (first) {
+		current = first->next;
+		free(first);
+		first = current;
+	}
+	return NULL;
+}
 
-	len = sysfs_cpufreq_read_file(cpu, fname,
-				linebuf, sizeof(linebuf));
+struct cpufreq_available_frequencies
+*cpufreq_get_boost_frequencies(unsigned int cpu)
+{
+	struct cpufreq_available_frequencies *first = NULL;
+	struct cpufreq_available_frequencies *current = NULL;
+	char one_value[SYSFS_PATH_MAX];
+	char linebuf[MAX_LINE_LEN];
+	unsigned int pos, i;
+	unsigned int len;
+
+	len = sysfs_cpufreq_read_file(cpu, "scaling_boost_frequencies",
+				      linebuf, sizeof(linebuf));
 	if (len == 0)
 		return NULL;
 
@@ -391,9 +444,9 @@ struct cpufreq_frequencies
 	return NULL;
 }
 
-void cpufreq_put_frequencies(struct cpufreq_frequencies *any)
+void cpufreq_put_available_frequencies(struct cpufreq_available_frequencies *any)
 {
-	struct cpufreq_frequencies *tmp, *next;
+	struct cpufreq_available_frequencies *tmp, *next;
 
 	if (!any)
 		return;
@@ -406,6 +459,11 @@ void cpufreq_put_frequencies(struct cpuf
 	}
 }
 
+void cpufreq_put_boost_frequencies(struct cpufreq_available_frequencies *any)
+{
+	cpufreq_put_available_frequencies(any);
+}
+
 static struct cpufreq_affected_cpus *sysfs_get_cpu_list(unsigned int cpu,
 							const char *file)
 {
--- a/tools/power/cpupower/lib/cpufreq.h
+++ b/tools/power/cpupower/lib/cpufreq.h
@@ -20,10 +20,10 @@ struct cpufreq_available_governors {
 	struct cpufreq_available_governors *first;
 };
 
-struct cpufreq_frequencies {
+struct cpufreq_available_frequencies {
 	unsigned long frequency;
-	struct cpufreq_frequencies *next;
-	struct cpufreq_frequencies *first;
+	struct cpufreq_available_frequencies *next;
+	struct cpufreq_available_frequencies *first;
 };
 
 
@@ -124,11 +124,17 @@ void cpufreq_put_available_governors(
  * cpufreq_put_frequencies after use.
  */
 
-struct cpufreq_frequencies
-*cpufreq_get_frequencies(const char *type, unsigned int cpu);
+struct cpufreq_available_frequencies
+*cpufreq_get_available_frequencies(unsigned int cpu);
 
-void cpufreq_put_frequencies(
-		struct cpufreq_frequencies *first);
+void cpufreq_put_available_frequencies(
+		struct cpufreq_available_frequencies *first);
+
+struct cpufreq_available_frequencies
+*cpufreq_get_boost_frequencies(unsigned int cpu);
+
+void cpufreq_put_boost_frequencies(
+		struct cpufreq_available_frequencies *first);
 
 
 /* determine affected CPUs
--- a/tools/power/cpupower/utils/cpufreq-info.c
+++ b/tools/power/cpupower/utils/cpufreq-info.c
@@ -244,14 +244,14 @@ static int get_boost_mode_x86(unsigned i
 
 static int get_boost_mode(unsigned int cpu)
 {
-	struct cpufreq_frequencies *freqs;
+	struct cpufreq_available_frequencies *freqs;
 
 	if (cpupower_cpu_info.vendor == X86_VENDOR_AMD ||
 	    cpupower_cpu_info.vendor == X86_VENDOR_HYGON ||
 	    cpupower_cpu_info.vendor == X86_VENDOR_INTEL)
 		return get_boost_mode_x86(cpu);
 
-	freqs = cpufreq_get_frequencies("boost", cpu);
+	freqs = cpufreq_get_boost_frequencies(cpu);
 	if (freqs) {
 		printf(_("  boost frequency steps: "));
 		while (freqs->next) {
@@ -261,7 +261,7 @@ static int get_boost_mode(unsigned int c
 		}
 		print_speed(freqs->frequency);
 		printf("\n");
-		cpufreq_put_frequencies(freqs);
+		cpufreq_put_available_frequencies(freqs);
 	}
 
 	return 0;
@@ -475,7 +475,7 @@ static int get_latency(unsigned int cpu,
 
 static void debug_output_one(unsigned int cpu)
 {
-	struct cpufreq_frequencies *freqs;
+	struct cpufreq_available_frequencies *freqs;
 
 	get_driver(cpu);
 	get_related_cpus(cpu);
@@ -483,7 +483,7 @@ static void debug_output_one(unsigned in
 	get_latency(cpu, 1);
 	get_hardware_limits(cpu, 1);
 
-	freqs = cpufreq_get_frequencies("available", cpu);
+	freqs = cpufreq_get_available_frequencies(cpu);
 	if (freqs) {
 		printf(_("  available frequency steps:  "));
 		while (freqs->next) {
@@ -493,7 +493,7 @@ static void debug_output_one(unsigned in
 		}
 		print_speed(freqs->frequency);
 		printf("\n");
-		cpufreq_put_frequencies(freqs);
+		cpufreq_put_available_frequencies(freqs);
 	}
 
 	get_available_governors(cpu);


