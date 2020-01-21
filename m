Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6078514360A
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 04:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgAUDtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 22:49:21 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35717 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUDtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 22:49:21 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so728361pgk.2;
        Mon, 20 Jan 2020 19:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1mhl28SFkO0YIHewkDhFiERCfDvcLRjUnQPqYxs1pwY=;
        b=uJl8UecBwzVUJz3p4V6rWzopI3GrqaNzL2YyAzhZD8HQ4VM/lMDBZkWymAJFGFHQXu
         9Sc6E1ImrqBd8Vf0yerDXZtC7MPO+ik+xaTmSV7yKZuEK6KjJI5UFnLXviCqwDOXAMa4
         A6vNxo7AJZu3EHNFKJMbnW8Drr2FlCCB22K+G62LqvqdpXwBGxNQ25/DbqzsYuI4Dh+B
         WmEqaS1NvNjCkNf/VwqFpn4Izd3E42rwoDIKJMjViyRMYA/8yrnKl0AhptxNzpD4WBEY
         UgDavrE5kzDg21nilbJr3BdRrH3mabZVZ62/W0iA5IAGTPvPDfFiEbd92k78xhme5Q3Z
         pSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1mhl28SFkO0YIHewkDhFiERCfDvcLRjUnQPqYxs1pwY=;
        b=GzcNeSAjCj9Lxwve5Ilk83VW4+eyIuCiu3iGwqZzt3shzpqX6+RchNXYfRPYu+TWrZ
         i3POJbWiPCfQg0pkFYe3EVoxAeZImXPLJ2P7yjlinmNsNMIB7F1sr/ahiex8iJGYbZXZ
         sTc1Whj0acboA5YBQTU5QwwLjdu/2FriTyNgHPFj7VmQAAmA+8UBokaznQH5ZUBMrq9P
         rPapRedMGv67K1VFuSPKTe8wDhREb2QGZpUv5D2sd6HI3daprYcGpbOKVCXtX04Rxwph
         ExpKBACzQZ0Wi0JcBgyMaZ5tPG5IX5qZhLvVWrEp8XozcPaGTxQfrAcVIZoLnsXq5V6I
         e0Dw==
X-Gm-Message-State: APjAAAXn8Io7DM9YbtEwB70U4uKFc0qOypin4cieG1doSEULKJXAtHrx
        Bf/HqO7Q+nUSACNNLYG5oJT9ZY9VvSU=
X-Google-Smtp-Source: APXvYqwh05Aou8EHt1EImr3ATWeP7N3Kv8qYKiN8Njt9NfveMCnTB6+JIF2Nq9oqXpUOEjflecjufA==
X-Received: by 2002:a63:d906:: with SMTP id r6mr3222211pgg.440.1579578560391;
        Mon, 20 Jan 2020 19:49:20 -0800 (PST)
Received: from localhost.corp.microsoft.com ([167.220.255.5])
        by smtp.googlemail.com with ESMTPSA id m22sm41070528pgn.8.2020.01.20.19.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Jan 2020 19:49:19 -0800 (PST)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: [PATCH V4] x86/Hyper-V: Balloon up according to request page number
Date:   Tue, 21 Jan 2020 11:49:12 +0800
Message-Id: <20200121034912.2725-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Current code has assumption that balloon request memory size aligns
with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
balloon driver receives non-aligned balloon request, it produces warning
and balloon up more memory than requested in order to keep 2MB alignment.
Remove the warning and balloon up memory according to actual requested
memory size.

Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
    - Revert optimization of swtiching alloc_unit

Change since v2:
    - Remove check between request page number and alloc_unit
    in the alloc_balloon_pages() because it's redundant with
    new change.
    - Remove the "continue" just follwoing alloc_unit switch
     from 2MB to 4K in order to avoid skipping allocated
     memory.

Change since v1:
    - Change logic of switching alloc_unit from 2MB to 4KB
    in the balloon_up() to avoid redundant iteration when
    handle non-aligned page request.
    - Remove 2MB alignment operation and comment in balloon_up()
---
 drivers/hv/hv_balloon.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7f3e7ab22d5d..a03c5191101e 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1681,10 +1681,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 	unsigned int i, j;
 	struct page *pg;
 
-	if (num_pages < alloc_unit)
-		return 0;
-
-	for (i = 0; (i * alloc_unit) < num_pages; i++) {
+	for (i = 0; i < num_pages / alloc_unit; i++) {
 		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
 			HV_HYP_PAGE_SIZE)
 			return i * alloc_unit;
@@ -1722,7 +1719,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 
 	}
 
-	return num_pages;
+	return i * alloc_unit;
 }
 
 static void balloon_up(union dm_msg_info *msg_info)
@@ -1737,9 +1734,6 @@ static void balloon_up(union dm_msg_info *msg_info)
 	long avail_pages;
 	unsigned long floor;
 
-	/* The host balloons pages in 2M granularity. */
-	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
-
 	/*
 	 * We will attempt 2M allocations. However, if we fail to
 	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
@@ -1749,14 +1743,13 @@ static void balloon_up(union dm_msg_info *msg_info)
 	avail_pages = si_mem_available();
 	floor = compute_balloon_floor();
 
-	/* Refuse to balloon below the floor, keep the 2M granularity. */
+	/* Refuse to balloon below the floor. */
 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
 		pr_warn("Balloon request will be partially fulfilled. %s\n",
 			avail_pages < num_pages ? "Not enough memory." :
 			"Balloon floor reached.");
 
 		num_pages = avail_pages > floor ? (avail_pages - floor) : 0;
-		num_pages -= num_pages % PAGES_IN_2M;
 	}
 
 	while (!done) {
-- 
2.14.5

