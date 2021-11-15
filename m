Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6445241F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhKPBgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241267AbhKOSkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F141632F7;
        Mon, 15 Nov 2021 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999459;
        bh=ICuWYp9fH4pKQJMgZaPftWgz5rRTUT8rMVdswGMMt7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKNdVseoG0DJViKQLZWtRU59ssTWC0Ee5mJvA2h5tgWPXDmg6OqmtO+X9wRuKB3Ox
         amttlerL1vCvPgUogZyxnJHC1aL+UhuwdQVxqX7JwjYJgI8WIk8phBP9YcScJqXK0Y
         lTSTYIu3LTRY29JtSoTGT8BJ/WNRs6McVmgk+EAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 304/849] selftests/bpf: Fix perf_buffer test on system with offline cpus
Date:   Mon, 15 Nov 2021 17:56:27 +0100
Message-Id: <20211115165430.536859047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit d4121376ac7a9c81a696d7558789b2f29ef3574e ]

The perf_buffer fails on system with offline cpus:

  # test_progs -t perf_buffer
  test_perf_buffer:PASS:nr_cpus 0 nsec
  test_perf_buffer:PASS:nr_on_cpus 0 nsec
  test_perf_buffer:PASS:skel_load 0 nsec
  test_perf_buffer:PASS:attach_kprobe 0 nsec
  test_perf_buffer:PASS:perf_buf__new 0 nsec
  test_perf_buffer:PASS:epoll_fd 0 nsec
  skipping offline CPU #24
  skipping offline CPU #25
  skipping offline CPU #26
  skipping offline CPU #27
  skipping offline CPU #28
  skipping offline CPU #29
  skipping offline CPU #30
  skipping offline CPU #31
  test_perf_buffer:PASS:perf_buffer__poll 0 nsec
  test_perf_buffer:PASS:seen_cpu_cnt 0 nsec
  test_perf_buffer:FAIL:buf_cnt got 24, expected 32
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Changing the test to check online cpus instead of possible.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20211021114132.8196-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/perf_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
index 6490e9673002f..7daaaab13681b 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_buffer.c
@@ -107,8 +107,8 @@ void test_perf_buffer(void)
 		  "expect %d, seen %d\n", nr_on_cpus, CPU_COUNT(&cpu_seen)))
 		goto out_free_pb;
 
-	if (CHECK(perf_buffer__buffer_cnt(pb) != nr_cpus, "buf_cnt",
-		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_cpus))
+	if (CHECK(perf_buffer__buffer_cnt(pb) != nr_on_cpus, "buf_cnt",
+		  "got %zu, expected %d\n", perf_buffer__buffer_cnt(pb), nr_on_cpus))
 		goto out_close;
 
 	for (i = 0; i < nr_cpus; i++) {
-- 
2.33.0



