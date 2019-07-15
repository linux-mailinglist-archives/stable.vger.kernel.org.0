Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477DC697A4
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbfGONvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbfGONva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:51:30 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C1AD2083D;
        Mon, 15 Jul 2019 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198689;
        bh=AHReuTE0Q7LdzAk7XuYYkP8J2o2H1q4tT6cZA70814M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBCVLoCpDnVW6M6mCNKk12EfiLTuuUXbyWsr9dXwtdHRye9jnNBCY45Y5w4Zmrmo1
         b00SnQkEJ1jrX6CdB5fl5iPXMAjpsxcs+l/Xd/gooAu9XS9QKBL7yg+bLHFBlHBIlL
         Y2SykvOqUihCZJdSI+dUcTAnBM0aSwLFVCgJkqeA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 083/249] perf test 6: Fix missing kvm module load for s390
Date:   Mon, 15 Jul 2019 09:44:08 -0400
Message-Id: <20190715134655.4076-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 53fe307dfd309e425b171f6272d64296a54f4dff ]

Command

   # perf test -Fv 6

fails with error

   running test 100 'kvm-s390:kvm_s390_create_vm' failed to parse
    event 'kvm-s390:kvm_s390_create_vm', err -1, str 'unknown tracepoint'
    event syntax error: 'kvm-s390:kvm_s390_create_vm'
                         \___ unknown tracepoint

when the kvm module is not loaded or not built in.

Fix this by adding a valid function which tests if the module
is loaded. Loaded modules (or builtin KVM support) have a
directory named
  /sys/kernel/debug/tracing/events/kvm-s390
for this tracepoint.

Check for existence of this directory.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20190604053504.43073-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/parse-events.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 4a69c07f4101..8f3c80e13584 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -18,6 +18,32 @@
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
 			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
 
+#if defined(__s390x__)
+/* Return true if kvm module is available and loaded. Test this
+ * and retun success when trace point kvm_s390_create_vm
+ * exists. Otherwise this test always fails.
+ */
+static bool kvm_s390_create_vm_valid(void)
+{
+	char *eventfile;
+	bool rc = false;
+
+	eventfile = get_events_file("kvm-s390");
+
+	if (eventfile) {
+		DIR *mydir = opendir(eventfile);
+
+		if (mydir) {
+			rc = true;
+			closedir(mydir);
+		}
+		put_events_file(eventfile);
+	}
+
+	return rc;
+}
+#endif
+
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
@@ -1642,6 +1668,7 @@ static struct evlist_test test__events[] = {
 	{
 		.name  = "kvm-s390:kvm_s390_create_vm",
 		.check = test__checkevent_tracepoint,
+		.valid = kvm_s390_create_vm_valid,
 		.id    = 100,
 	},
 #endif
-- 
2.20.1

