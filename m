Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA22EA8E47
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbfIDR5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387782AbfIDR5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F82208E4;
        Wed,  4 Sep 2019 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619825;
        bh=yXn5V3reSUa4JewyBLMYoVI4vg9EKURLb3VjTzOCjj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wrr+T0j0DIBnGHHMTKINbTqqE3avh/dGdXjDME37+LiBoK2W7fSmHkfLJtewODYui
         3j+JHNZAOD2LKcIq/fnVOtX7YIJb/0mvvHAqnKCRmoRjnnZ+pjNd2z1rhF2vOe1Nmb
         N9W8dOrQdynOiO1dvsP/X/oJLWA0UoEi1nu+nTzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 47/77] Revert "perf test 6: Fix missing kvm module load for s390"
Date:   Wed,  4 Sep 2019 19:53:34 +0200
Message-Id: <20190904175307.884235347@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 5f18429ae48faebefc00533cb24afdd01064754c.

Which was upstream commit 53fe307dfd309e425b171f6272d64296a54f4dff.

Ben Hutchings reports that this commit depends on new code added in
v4.18, and so is irrelevant on older kernels, and breaks the build.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/parse-events.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 1a35ab044c11d..54af2f2e2ee4f 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -12,32 +12,6 @@
 #define PERF_TP_SAMPLE_TYPE (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | \
 			     PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
 
-#if defined(__s390x__)
-/* Return true if kvm module is available and loaded. Test this
- * and retun success when trace point kvm_s390_create_vm
- * exists. Otherwise this test always fails.
- */
-static bool kvm_s390_create_vm_valid(void)
-{
-	char *eventfile;
-	bool rc = false;
-
-	eventfile = get_events_file("kvm-s390");
-
-	if (eventfile) {
-		DIR *mydir = opendir(eventfile);
-
-		if (mydir) {
-			rc = true;
-			closedir(mydir);
-		}
-		put_events_file(eventfile);
-	}
-
-	return rc;
-}
-#endif
-
 static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
@@ -1587,7 +1561,6 @@ static struct evlist_test test__events[] = {
 	{
 		.name  = "kvm-s390:kvm_s390_create_vm",
 		.check = test__checkevent_tracepoint,
-		.valid = kvm_s390_create_vm_valid,
 		.id    = 100,
 	},
 #endif
-- 
2.20.1



