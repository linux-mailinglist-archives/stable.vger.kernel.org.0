Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2639657B9A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiL1PX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiL1PX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C413F5C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A3B4B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63845C433D2;
        Wed, 28 Dec 2022 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241004;
        bh=MgDrVh8TgP1lYs6ZUZmj1KacACULdMBbFc2oSgkD32A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjxI0fJj6iry/2rSFI3EMVsI6km4lQWwzHsvCYr4utZSFLOrWopRPxepfH8jLcu/t
         UlymqetoYBowXhEKke9U7uez8Aw4HRNtYbnPe7iyfufrvv9GHuM5nsc2ARkDtKtmKs
         LeawajycG2esa7oRfI9zQe0JnTC5H5QYUIfx9sOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kui-Feng Lee <kuifeng@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0194/1146] selftests/bpf: Add missing bpf_iter_vma_offset__destroy call
Date:   Wed, 28 Dec 2022 15:28:53 +0100
Message-Id: <20221228144335.415930323@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 1d2d941bc140b34587b4c889699fb0f89d29937f ]

Adding missing bpf_iter_vma_offset__destroy call and using in-skeletin
link pointer so we don't need extra bpf_link__destroy call.

Fixes: b3e1331eb925 ("selftests/bpf: Test parameterized task BPF iterators.")
Cc: Kui-Feng Lee <kuifeng@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221006083106.117987-1-jolsa@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 3369c5ec3a17..ecde236047fe 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -1498,7 +1498,6 @@ static noinline int trigger_func(int arg)
 static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool one_proc)
 {
 	struct bpf_iter_vma_offset *skel;
-	struct bpf_link *link;
 	char buf[16] = {};
 	int iter_fd, len;
 	int pgsz, shift;
@@ -1513,11 +1512,11 @@ static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool
 		;
 	skel->bss->page_shift = shift;
 
-	link = bpf_program__attach_iter(skel->progs.get_vma_offset, opts);
-	if (!ASSERT_OK_PTR(link, "attach_iter"))
-		return;
+	skel->links.get_vma_offset = bpf_program__attach_iter(skel->progs.get_vma_offset, opts);
+	if (!ASSERT_OK_PTR(skel->links.get_vma_offset, "attach_iter"))
+		goto exit;
 
-	iter_fd = bpf_iter_create(bpf_link__fd(link));
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.get_vma_offset));
 	if (!ASSERT_GT(iter_fd, 0, "create_iter"))
 		goto exit;
 
@@ -1535,7 +1534,7 @@ static void test_task_vma_offset_common(struct bpf_iter_attach_opts *opts, bool
 	close(iter_fd);
 
 exit:
-	bpf_link__destroy(link);
+	bpf_iter_vma_offset__destroy(skel);
 }
 
 static void test_task_vma_offset(void)
-- 
2.35.1



