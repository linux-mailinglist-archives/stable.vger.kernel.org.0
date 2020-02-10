Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45615157563
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgBJMki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgBJMkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:37 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD83E24677;
        Mon, 10 Feb 2020 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338436;
        bh=7Yb61XXglUE8vFoOFTeRXvxRnUMTpt+E2LKizfxYCPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYhNhCIxGY0ayp9T9nUZgJIJeRRJaDJLXCzrsUcI5llpOGzSvbSUqrMAVsQ4gqJ7I
         dYg8II3iVNTaMMquaO5EJ37LEy5XcrPiuI6N64c2MZ7xjvTmZ7j61GaYElzLMUVBHr
         OONRtQy0INBhMCURv06E9GQju2hzbPKc6sfsDj7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.5 171/367] selftests/bpf: Skip perf hw events test if the setup disabled it
Date:   Mon, 10 Feb 2020 04:31:24 -0800
Message-Id: <20200210122440.662026866@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

commit f1c3656c6d9c147d07d16614455aceb34932bdeb upstream.

The same with commit 4e59afbbed96 ("selftests/bpf: skip nmi test when perf
hw events are disabled"), it would make more sense to skip the
test_stacktrace_build_id_nmi test if the setup (e.g. virtual machines) has
disabled hardware perf events.

Fixes: 13790d1cc72c ("bpf: add selftest for stackmap with build_id in NMI context")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200117100656.10359-1-liuhangbin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -49,8 +49,12 @@ retry:
 	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
 			 0 /* cpu 0 */, -1 /* group id */,
 			 0 /* flags */);
-	if (CHECK(pmu_fd < 0, "perf_event_open",
-		  "err %d errno %d. Does the test host support PERF_COUNT_HW_CPU_CYCLES?\n",
+	if (pmu_fd < 0 && errno == ENOENT) {
+		printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
+		test__skip();
+		goto cleanup;
+	}
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
 		  pmu_fd, errno))
 		goto close_prog;
 


