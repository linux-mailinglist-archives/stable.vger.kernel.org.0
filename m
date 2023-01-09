Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047D86633C5
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 23:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbjAIWQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 17:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbjAIWQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 17:16:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE8178AB
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 14:16:36 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4bdeb1bbeafso106104467b3.4
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 14:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y9TFZ1eWP+JIndu1JdgCdrPRh+jAT3LtUVgzdE/rI84=;
        b=C0Hc9uF3im6Ys2/s/4e6nNvgxvlythCwW8m17GdXHrOqWQ9yn0iW0LTZyj+MdItAEY
         iybja8FN1XyhoSwQX36EF+9wSfenpbb6LvJn2ASIr9ARjPf3bBYDEf0TmC1ADROKbIzA
         uqBW5UJwXEglstUm+YQchdmDfMIzIajQqCXdq5tXej2n/om0MByQQj7QiCcAlkoHzW+f
         0EvQf8SiwDxeGivZRKBfCGtD95VHgBTkc0pBRfvgB/JhWJIan9MB+IxMjhlK+NPhAWfg
         dNKLyThxKdiUaJhH8Ndfdtdxjx9wWLvlbjqkUFmWXQ0tbaB5ICv8vHAarsuXw/gDkqnj
         gHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y9TFZ1eWP+JIndu1JdgCdrPRh+jAT3LtUVgzdE/rI84=;
        b=6sa58Y4cL5dGC2yunb8hXlgomWQGcr3f5rv7iB4awlhpDBEbZj0/nbRrrXioa/wLJw
         lUmiEh3NF34rfcJenfxnI1RNnq32x+PTJb3R5tNyorSbFTe7lhljPeQ9Hx86LcjsvE9W
         9cUqXB2ZA6GFfNKnW+OGWJwujgRO3ctxXhmI7XQiv+wCzf+ql6FDCAmpx09O6w/XtJfP
         rCziPLYoQL+enUiKGAb9y1brto1Ie6HhihecuJtTOnbL9EBNisSwS3d+dfELLhFbS4uB
         JjT4g9lpWBfU11A/mRyh+27FhyB9SUvAw+BSV97SzmCISAo6gwBZyYD4opCwDqg+RLIq
         B81Q==
X-Gm-Message-State: AFqh2koacHp3wRgAxDpDcSAzoASAqYOdOZqc9IvF5Jr4fgeLrmjSyI1u
        CU2VpcbkngFAKSfCHqgBwkP2Ny6cAD2DPRs6xYEhMQ==
X-Google-Smtp-Source: AMrXdXvHobRDwuXj4MA5OcW3NVM1spLgSqNMAAiW4GhwomXZXFwO2kaU1GbMWchPaX3UjiQoZHyyjBmkbD8YjhmyaldVbQ==
X-Received: from isaacmanjarres.irv.corp.google.com ([2620:15c:2d:3:3990:5e50:b0f8:bcdd])
 (user=isaacmanjarres job=sendgmr) by 2002:a05:690c:b08:b0:469:28df:b2c2 with
 SMTP id cj8-20020a05690c0b0800b0046928dfb2c2mr1656471ywb.122.1673302596557;
 Mon, 09 Jan 2023 14:16:36 -0800 (PST)
Date:   Mon,  9 Jan 2023 14:16:23 -0800
In-Reply-To: <20230109221624.592315-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20230109221624.592315-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109221624.592315-3-isaacmanjarres@google.com>
Subject: [PATCH v1 2/2] mm/cma.c: Delete kmemleak objects when freeing CMA
 areas to buddy at boot
From:   "Isaac J. Manjarres" <isaacmanjarres@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        kernel-team@android.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since every CMA region is now tracked by kmemleak at the time
cma_activate_area() is invoked, and cma_activate_area() is called
for each CMA region, invoke kmemleak_free_part_phys() during
cma_activate_area() to inform kmemleak that the CMA region will
be freed. Doing so also removes the need to invoke
kmemleak_ignore_phys() when the global CMA region is being created,
as the kmemleak object for it will be deleted.

This helps resolve a crash when kmemleak and CONFIG_DEBUG_PAGEALLOC
are both enabled, since CONFIG_DEBUG_PAGEALLOC causes the CMA region
to be unmapped from the kernel's address space when the pages are freed
to buddy. Without this patch, kmemleak will attempt to scan the CMA
regions, even though they are unmapped, which leads to a page-fault.

Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 mm/cma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 674b7fdd563e..dd25b095d9ca 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -102,6 +102,13 @@ static void __init cma_activate_area(struct cma *cma)
 	if (!cma->bitmap)
 		goto out_error;
 
+	/*
+	 * The CMA region was marked as allocated by kmemleak when it was either
+	 * dynamically allocated or statically reserved. In any case,
+	 * inform kmemleak that the region is about to be freed to the page allocator.
+	 */
+	kmemleak_free_part_phys(cma_get_base(cma), cma_get_size(cma));
+
 	/*
 	 * alloc_contig_range() requires the pfn range specified to be in the
 	 * same zone. Simplify by forcing the entire CMA resv range to be in the
@@ -361,11 +368,6 @@ int __init cma_declare_contiguous_nid(phys_addr_t base,
 			}
 		}
 
-		/*
-		 * kmemleak scans/reads tracked objects for pointers to other
-		 * objects but this address isn't mapped and accessible
-		 */
-		kmemleak_ignore_phys(addr);
 		base = addr;
 	}
 
-- 
2.39.0.314.g84b9a713c41-goog

