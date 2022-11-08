Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D1A620A61
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 08:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiKHHis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 02:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiKHHi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 02:38:29 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FEC4384C
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 23:37:54 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id o13so3386014pgu.7
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 23:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ccLtKwvHNy2QuMoZWgBpTToeHRPcGyCrvdxbvnwB/U=;
        b=d4CL8tk8dpYMm33ih8V+vIAD9Np3iQ8S0hquZ7ZPrnD6OpJ9h8EmE3UgUIxjqimjJz
         ms88IvstXGUROccfAc1oXe5bKeiUd5vkTsBbteLJ5okAHCn3rNJ8YgGcTlspFTOsM4OH
         oVOOdANa4wzFoY3WlsF9PhCWco8dieemqyIE1of3VHK1Umjl7mQYVuAmixHSqIW2vlEe
         /jBwt3dAUePUkbqn3aVGWpEHuotcyJNfp4yPPq2+40h8eveRXP/lchW3C8k/X6jibZIX
         s6pybTrEv/hIOIwFmP9gP8LQW9gcmodAmLmymcC2tIFCaPtQ+H0FA1s0MmT1MqD0JIaO
         Q8jQ==
X-Gm-Message-State: ACrzQf2glf4iCJCkS8OnKZO7fDtinoduxLWVJwQ2e2T+RF3OLCvNbUvt
        Z8FvfY990fdMTbTLl9OtM20=
X-Google-Smtp-Source: AMsMyM7amKglojywIQZLcdCK6QfnN9uHLgNc9NVKKbNQWIuoe/YhnJv36cS8AbMJs0sCm6Jp04B5xQ==
X-Received: by 2002:a05:6a00:cd6:b0:56d:9a94:4075 with SMTP id b22-20020a056a000cd600b0056d9a944075mr42408715pfv.67.1667893073492;
        Mon, 07 Nov 2022 23:37:53 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm5872043pfd.97.2022.11.07.23.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 23:37:53 -0800 (PST)
From:   xiongxin <xiongxin@kylinos.cn>
To:     xiongxin@kylinos.cn
Cc:     stable@vger.kernel.org, huanglei <huanglei@kylinos.cn>
Subject: [PATCH v2 2/2] PM: hibernate: add check of preallocate mem for image size pages
Date:   Tue,  8 Nov 2022 15:37:41 +0800
Message-Id: <20221108073741.3837659-3-xiongxin@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108073741.3837659-1-xiongxin@kylinos.cn>
References: <20221108073741.3837659-1-xiongxin@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

