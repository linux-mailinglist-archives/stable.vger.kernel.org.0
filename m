Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3711D8380
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbgERSF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732953AbgERSF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAC9E20873;
        Mon, 18 May 2020 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825125;
        bh=KPQ5ee/rVhZdwHtanFh23NNG/VV1y3tWvTV40prfyPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6S83y4ch699cGelMEDzCiZtEfqrBvGfZZQSNpRRbdYEp+6gI+n5ooTPLioMIWzFF
         RPLU0jPWmogalcuDbuEuwtCOOQ0q8RTquYhw2vVfO2yxMZ/EXu2AAJ+4KrWq+ap4HL
         lt4Z1MANmlBXL1iFmy0BDTK7Dr+JP9PR0RkXrXNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 122/194] bpf: Fix bug in mmap() implementation for BPF array map
Date:   Mon, 18 May 2020 19:36:52 +0200
Message-Id: <20200518173541.756566468@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 333291ce5055f2039afc907badaf5b66bc1adfdc ]

mmap() subsystem allows user-space application to memory-map region with
initial page offset. This wasn't taken into account in initial implementation
of BPF array memory-mapping. This would result in wrong pages, not taking into
account requested page shift, being memory-mmaped into user-space. This patch
fixes this gap and adds a test for such scenario.

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200512235925.3817805-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c                         | 7 ++++++-
 tools/testing/selftests/bpf/prog_tests/mmap.c | 9 +++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c9..1d6120fd5ba68 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -486,7 +486,12 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	if (!(map->map_flags & BPF_F_MMAPABLE))
 		return -EINVAL;
 
-	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array), pgoff);
+	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) >
+	    PAGE_ALIGN((u64)array->map.max_entries * array->elem_size))
+		return -EINVAL;
+
+	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array),
+				   vma->vm_pgoff + pgoff);
 }
 
 const struct bpf_map_ops array_map_ops = {
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 16a814eb4d645..b0e789678aa46 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -197,6 +197,15 @@ void test_mmap(void)
 	CHECK_FAIL(map_data->val[far] != 3 * 321);
 
 	munmap(tmp2, 4 * page_size);
+
+	/* map all 4 pages, but with pg_off=1 page, should fail */
+	tmp1 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
+		    data_map_fd, page_size /* initial page shift */);
+	if (CHECK(tmp1 != MAP_FAILED, "adv_mmap7", "unexpected success")) {
+		munmap(tmp1, 4 * page_size);
+		goto cleanup;
+	}
+
 cleanup:
 	if (bss_mmaped)
 		CHECK_FAIL(munmap(bss_mmaped, bss_sz));
-- 
2.20.1



