Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958AB619015
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 06:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiKDFle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 01:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiKDFlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 01:41:32 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B0E275E4;
        Thu,  3 Nov 2022 22:41:31 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q1so3513562pgl.11;
        Thu, 03 Nov 2022 22:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M77Wzzy8TacgRzejR5rXO6K4BybMH7Jtom+GhKe2B0U=;
        b=cEnfOXHV0UQH6PZUCLoulKGFACo4g6/DhhbZr/eJ2Jo25T+ShstQwJm6SEdcOSe+NA
         JkLsoIjzKq0TffGczU7CyPA0RRjLSjNChFcIVlzpJfymO0M4B0bY77IHoatM7HEhOLE5
         YlKou+aGOHiHqpIhov+Dz/OcnAwRzCHCwcJ5Lxu8yHWX8dlizr2Te0sToIiVlDVHVubE
         MUFzXJkySFvE11h1x6U4NwkkXh8Gk78Yxc33+NgMtkUW6pdHmy5AUIA/McaPbiux2UEx
         y8TH03zQ9+GzAlIxHUSqEGVNcJUklHoiXBO2yaGTy8U7Yu4oc6OewJaAQ9alofsVkSdX
         FeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M77Wzzy8TacgRzejR5rXO6K4BybMH7Jtom+GhKe2B0U=;
        b=ox7UAoDKIJu2UbCj312cHQdUpvRaYbFqjOd5wuwNzEKobQgC2IBRz28xDAG4GdQPtO
         RqFQpbrrUSu8TbVcKQCeAy5RKGoav7JGYe8kByq1agyxLfTvM4k9y7gKpRabnPVn13Ch
         +qlTfO7d82fsh4Mpb8F0VGf1McTfL6/xegp79nPKhxh9XKwDzqAYzAHNAdui/3eQDuvd
         oikSOuEXywGOJgblItM2Ulcli+jES2Ei0NgrITlhvOwCM9HAH3r9SItmrrpKT6Ki4ikU
         ++XGo04v59znN1bUDW+arXbb/Tt7CGcvxZg1nNYYjFwTu0CvnJGAdE7iASNEFpi0dNtD
         AMAw==
X-Gm-Message-State: ACrzQf3vzhPXNXdhb53E8XAvzJ4WyLP40IxvdixA6CcJXSTuFQxLTeRR
        o+c4eRLYhZFybjhwOIFB0I4=
X-Google-Smtp-Source: AMsMyM50XcYyJTYDpYak6UUvPkVV31MBr40uJxGsBXCDrHmDm5nnRvZ0g4AFcSnDbvFaaBNrjUs1CQ==
X-Received: by 2002:aa7:9e85:0:b0:56c:683b:d31f with SMTP id p5-20020aa79e85000000b0056c683bd31fmr34165085pfq.48.1667540490781;
        Thu, 03 Nov 2022 22:41:30 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id q15-20020aa7960f000000b0056bdc3f5b29sm1684043pfg.186.2022.11.03.22.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 22:41:30 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] PM: hibernate: add check of preallocate mem for image size pages
Date:   Fri,  4 Nov 2022 13:41:19 +0800
Message-Id: <20221104054119.1946073-3-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104054119.1946073-1-tgsp002@gmail.com>
References: <20221104054119.1946073-1-tgsp002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiongxin <xiongxin@kylinos.cn>

Added a check on the return value of preallocate_image_highmem(). If
memory preallocate is insufficient, S4 cannot be done;

I am playing 4K video on a machine with AMD or other graphics card and
only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
When doing the S4 test, the analysis found that when the pages get from
minimum_image_size() is large enough, The preallocate_image_memory() and
preallocate_image_highmem() calls failed to obtain enough memory. Add
the judgment that memory preallocate is insufficient;

The detailed debugging data is as follows:

image_size: 3225923584, totalram_pages: 1968948 in
hibernate_reserved_size_init();

in hibernate_preallocate_memory():
code pages = minimum_image_size(saveable) = 717992, at this time(line):
count: 2030858
avail_normal: 2053753
highmem: 0
totalreserve_pages: 22895
max_size: 1013336
size: 787579
saveable: 1819905

When the code executes to:
pages = preallocate_image_memory(alloc, avail_normal), at that
time(line):
pages_highmem: 0
avail_normal: 1335761
alloc: 1017522
pages: 1017522

So enter the else branch judged by (pages < alloc), When executed to
size = preallocate_image_memory(alloc, avail_normal):
alloc = max_size - size = 225757;
size = preallocate_image_memory(alloc, avail_normal) = 168671, That is,
preallocate_image_memory() does not apply for all alloc memory pages,
because highmem is not enabled, and size_highmem will return 0 here, so
there is a memory page that has not been preallocated, so I think a
judgment needs to be added here.

But what I can't understand is that although pages are not preallocated
enough, "pages -= free_unnecessary_pages()" in the code below can also
discard some pages that have been preallocated, so I am not sure whether
it is appropriate to add a judgment here.

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Signed-off-by: huanglei <huanglei@kylinos.cn>
---
 kernel/power/snapshot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c20ca5fb9adc..546d544cf7de 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1854,6 +1854,8 @@ int hibernate_preallocate_memory(void)
 		alloc = (count - pages) - size;
 		pages += preallocate_image_highmem(alloc);
 	} else {
+		unsigned long size_highmem = 0;
+
 		/*
 		 * There are approximately max_size saveable pages at this point
 		 * and we want to reduce this number down to size.
@@ -1863,8 +1865,13 @@ int hibernate_preallocate_memory(void)
 		pages_highmem += size;
 		alloc -= size;
 		size = preallocate_image_memory(alloc, avail_normal);
-		pages_highmem += preallocate_image_highmem(alloc - size);
-		pages += pages_highmem + size;
+		size_highmem = preallocate_image_highmem(alloc - size);
+		if (size_highmem < (alloc - size)) {
+			pr_err("Image allocation is %lu pages short, exit\n",
+				alloc - size - pages_highmem);
+			goto err_out;
+		}
+		pages += pages_highmem + size_highmem + size;
 	}
 
 	/*
-- 
2.25.1

