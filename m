Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F72C25949D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbgIAPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730616AbgIAPlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:41:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46F1206EB;
        Tue,  1 Sep 2020 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974880;
        bh=TYTTdCegp15oLYrWq/F7PP5Ab8BnxcWk62tjoSVlprc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bwd3Xi4C1KYyvuUCd8bkTFO/tHAXpuwCYnUnLvAwPn7f7pTK4Y2eyFWmDNCW53o8M
         Ot0iWMThnKLDfibJfaW39ldcpBtOcYPATRHDY7PPDCuMQv4NUGemJJJRJBukMR5WfY
         BNawrRqStVr5IysMrTjLPKQelGWLKHpYV+eNqvmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Lv <Jianlin.Lv@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 126/255] selftests/bpf: Fix segmentation fault in test_progs
Date:   Tue,  1 Sep 2020 17:09:42 +0200
Message-Id: <20200901151006.765388854@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianlin Lv <Jianlin.Lv@arm.com>

[ Upstream commit 0390c429dbed4068bd2cd8dded937d9a5ec24cd2 ]

test_progs reports the segmentation fault as below:

  $ sudo ./test_progs -t mmap --verbose
  test_mmap:PASS:skel_open_and_load 0 nsec
  [...]
  test_mmap:PASS:adv_mmap1 0 nsec
  test_mmap:PASS:adv_mmap2 0 nsec
  test_mmap:PASS:adv_mmap3 0 nsec
  test_mmap:PASS:adv_mmap4 0 nsec
  Segmentation fault

This issue was triggered because mmap() and munmap() used inconsistent
length parameters; mmap() creates a new mapping of 3 * page_size, but the
length parameter set in the subsequent re-map and munmap() functions is
4 * page_size; this leads to the destruction of the process space.

To fix this issue, first create 4 pages of anonymous mapping, then do all
the mmap() with MAP_FIXED.

Another issue is that when unmap the second page fails, the length
parameter to delete tmp1 mappings should be 4 * page_size.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200810153940.125508-1-Jianlin.Lv@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 43d0b5578f461..9c3c5c0f068fb 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -21,7 +21,7 @@ void test_mmap(void)
 	const long page_size = sysconf(_SC_PAGE_SIZE);
 	int err, duration = 0, i, data_map_fd, data_map_id, tmp_fd, rdmap_fd;
 	struct bpf_map *data_map, *bss_map;
-	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp1, *tmp2;
+	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp0, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
 	struct bpf_map_info map_info;
 	__u32 map_info_sz = sizeof(map_info);
@@ -183,16 +183,23 @@ void test_mmap(void)
 
 	/* check some more advanced mmap() manipulations */
 
+	tmp0 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_ANONYMOUS,
+			  -1, 0);
+	if (CHECK(tmp0 == MAP_FAILED, "adv_mmap0", "errno %d\n", errno))
+		goto cleanup;
+
 	/* map all but last page: pages 1-3 mapped */
-	tmp1 = mmap(NULL, 3 * page_size, PROT_READ, MAP_SHARED,
+	tmp1 = mmap(tmp0, 3 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
 			  data_map_fd, 0);
-	if (CHECK(tmp1 == MAP_FAILED, "adv_mmap1", "errno %d\n", errno))
+	if (CHECK(tmp0 != tmp1, "adv_mmap1", "tmp0: %p, tmp1: %p\n", tmp0, tmp1)) {
+		munmap(tmp0, 4 * page_size);
 		goto cleanup;
+	}
 
 	/* unmap second page: pages 1, 3 mapped */
 	err = munmap(tmp1 + page_size, page_size);
 	if (CHECK(err, "adv_mmap2", "errno %d\n", errno)) {
-		munmap(tmp1, map_sz);
+		munmap(tmp1, 4 * page_size);
 		goto cleanup;
 	}
 
@@ -201,7 +208,7 @@ void test_mmap(void)
 		    MAP_SHARED | MAP_FIXED, data_map_fd, 0);
 	if (CHECK(tmp2 == MAP_FAILED, "adv_mmap3", "errno %d\n", errno)) {
 		munmap(tmp1, page_size);
-		munmap(tmp1 + 2*page_size, page_size);
+		munmap(tmp1 + 2*page_size, 2 * page_size);
 		goto cleanup;
 	}
 	CHECK(tmp1 + page_size != tmp2, "adv_mmap4",
@@ -211,7 +218,7 @@ void test_mmap(void)
 	tmp2 = mmap(tmp1, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
 		    data_map_fd, 0);
 	if (CHECK(tmp2 == MAP_FAILED, "adv_mmap5", "errno %d\n", errno)) {
-		munmap(tmp1, 3 * page_size); /* unmap page 1 */
+		munmap(tmp1, 4 * page_size); /* unmap page 1 */
 		goto cleanup;
 	}
 	CHECK(tmp1 != tmp2, "adv_mmap6", "tmp1: %p, tmp2: %p\n", tmp1, tmp2);
-- 
2.25.1



