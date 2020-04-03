Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C991219D698
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403925AbgDCMSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41629 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403845AbgDCMSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id h9so8269290wrc.8
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0ZLg9OVS5LPGUTR/MUK1s5R+uH5HTAX/aXfIPj67qI=;
        b=IexUxYQ7c8xFrTydW85NdnXLWhhva5JKcJOMEWEL2ZsemAmu1t+7V8q2P4ELTebUf0
         zivoyMoTZNTUKkfJhcKodhgNHS/kqwxW4MH3qcP1fpdSTf3PWPog2RM4W5sKfzWfgdP/
         VfFblxbGUTCe1I5TBjDR2LnzC9UtGQ/gmui1WjzoxRG+YGs6IJetzAb5VZ+vk7of+vj3
         1Lw36kVxKNucOp104TXneTq3cQTLYjvnRHeA1TYT5BU35A86UCsFRXIIofYEINvGM3VC
         wtrTNZjdhBXsmy6+RV/0hYiKweZ6f6msgsUq8c252v35h8CZWXs0PigAgrwpczPVNVFA
         99Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0ZLg9OVS5LPGUTR/MUK1s5R+uH5HTAX/aXfIPj67qI=;
        b=chLZ1OCGtvkSSTAhzZkQ7MykY5CTuQZOPeT9dkvfOACH6tyjlYPbUmprCFhEw22kFz
         sg8Ed5Ijno4VOpqyZWcPLw7734u6Base+S9Uzkj9pu1XHgTPU7k0qXmi6hZZfb2a0F4W
         yXerPEYUWWg/EGVfDUVEHh62biwdLvv14BgwP1ysW7QH66e/Gdt0mYX83OsH9myyi4d1
         huwkQwtZx/GH2mzWDqrD3dHf35bVG54lbemstGkTahSmJGYXz+IghfdsZzdLuF2DxhMj
         sLIhBmVBCVrSgvLvMyhKrCnkIPkQr3T2j2QVJ1gPVFQZMOPenMHmRzfwkmLCKcSfkYCr
         4pTg==
X-Gm-Message-State: AGi0PubeSLVF9mTc9lXDq6kZHbBFOraoA0Pd5ySQzZgymHg3xzi/IWl9
        Phl+x1LM1cXC0TwuS5icZoEPOyVar4U=
X-Google-Smtp-Source: APiQypIfjRf03/lfA11+je8fRM4mopXftP+iRrE030Urzvdh+fTk8SQM56gLkzjNd1+TDZ1Ojxx6Bw==
X-Received: by 2002:adf:ead1:: with SMTP id o17mr8827025wrn.14.1585916317227;
        Fri, 03 Apr 2020 05:18:37 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Roman Gushchin <guro@fb.com>, Roman Penyaev <rpenyaev@suse.de>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 12/13] mm/vmalloc.c: move 'area->pages' after if statement
Date:   Fri,  3 Apr 2020 13:18:58 +0100
Message-Id: <20200403121859.901838-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 7ea362427c170061b8822dd41bafaa72b3bcb9ad ]

If !area->pages statement is true where memory allocation fails, area is
freed.

In this case 'area->pages = pages' should not executed.  So move
'area->pages = pages' after if statement.

[akpm@linux-foundation.org: give area->pages the same treatment]
Link: http://lkml.kernel.org/r/20190830035716.GA190684@LGEARND20B15
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 mm/vmalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 958d6ba9ee2d1..be65161f97531 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1668,7 +1668,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
-	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
@@ -1676,13 +1675,16 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
-	area->pages = pages;
-	if (!area->pages) {
+
+	if (!pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
 		return NULL;
 	}
 
+	area->pages = pages;
+	area->nr_pages = nr_pages;
+
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
 
-- 
2.25.1

