Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC92250F5A5
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbiDZIst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346490AbiDZIpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD958BE39;
        Tue, 26 Apr 2022 01:34:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D549AB81D0C;
        Tue, 26 Apr 2022 08:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5E4C385A0;
        Tue, 26 Apr 2022 08:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962089;
        bh=SJUp71Vu33LPw/f8MkThFsF/Wb57hKETgbDG0fLTxOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCoT/N3ZT8QVAMoPgZ3faHsFy6ym7i3c3H9eSGoRr0KaeU+fp5A57qMG9z2+gszrz
         r4VRnocjBBFmxv7s/xB4M4y/0AEclwio6nQSmOvUvr3cUrYFiTmr2/KSyuzMRUl2or
         yuGRDV9uFsjKqi69pBRdGHc/0CV6lAwp7JbmDCPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhipeng Xie <xiezhipeng1@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 67/86] perf/core: Fix perf_mmap fail when CONFIG_PERF_USE_VMALLOC enabled
Date:   Tue, 26 Apr 2022 10:21:35 +0200
Message-Id: <20220426081743.141377871@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhipeng Xie <xiezhipeng1@huawei.com>

[ Upstream commit 60490e7966659b26d74bf1fa4aa8693d9a94ca88 ]

This problem can be reproduced with CONFIG_PERF_USE_VMALLOC enabled on
both x86_64 and aarch64 arch when using sysdig -B(using ebpf)[1].
sysdig -B works fine after rebuilding the kernel with
CONFIG_PERF_USE_VMALLOC disabled.

I tracked it down to the if condition event->rb->nr_pages != nr_pages
in perf_mmap is true when CONFIG_PERF_USE_VMALLOC is enabled where
event->rb->nr_pages = 1 and nr_pages = 2048 resulting perf_mmap to
return -EINVAL. This is because when CONFIG_PERF_USE_VMALLOC is
enabled, rb->nr_pages is always equal to 1.

Arch with CONFIG_PERF_USE_VMALLOC enabled by default:
	arc/arm/csky/mips/sh/sparc/xtensa

Arch with CONFIG_PERF_USE_VMALLOC disabled by default:
	x86_64/aarch64/...

Fix this problem by using data_page_nr()

[1] https://github.com/draios/sysdig

Fixes: 906010b2134e ("perf_event: Provide vmalloc() based mmap() backing")
Signed-off-by: Zhipeng Xie <xiezhipeng1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220209145417.6495-1-xiezhipeng1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c        | 2 +-
 kernel/events/internal.h    | 5 +++++
 kernel/events/ring_buffer.c | 5 -----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 79d8b27cf2fc..9aa6563587d8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6221,7 +6221,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages != nr_pages) {
+		if (data_page_nr(event->rb) != nr_pages) {
 			ret = -EINVAL;
 			goto unlock;
 		}
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 228801e20788..aa23ffdaf819 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -116,6 +116,11 @@ static inline int page_order(struct perf_buffer *rb)
 }
 #endif
 
+static inline int data_page_nr(struct perf_buffer *rb)
+{
+	return rb->nr_pages << page_order(rb);
+}
+
 static inline unsigned long perf_data_size(struct perf_buffer *rb)
 {
 	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index ef91ae75ca56..4032cd475000 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -856,11 +856,6 @@ void rb_free(struct perf_buffer *rb)
 }
 
 #else
-static int data_page_nr(struct perf_buffer *rb)
-{
-	return rb->nr_pages << page_order(rb);
-}
-
 static struct page *
 __perf_mmap_to_page(struct perf_buffer *rb, unsigned long pgoff)
 {
-- 
2.35.1



