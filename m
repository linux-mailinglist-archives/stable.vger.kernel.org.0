Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FF351F2AF
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 04:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiEICv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 22:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiEICvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 22:51:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD526462;
        Sun,  8 May 2022 19:47:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i1so12584348plg.7;
        Sun, 08 May 2022 19:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09Vt4G6n2lDrTYL/OjY7UiKCXH1y9x+5kX8o8WWVQgw=;
        b=NQruP2zCQHSaJQUmJCI9RhATtkSlIijZCS+mT5oc8iOV0GgqNp6+mmzKsSIuQLS/Sa
         gb3ZP24Urz562/DxdMZTJuFuFvvpC+O3t7V/9jxxrrXBcRfy7j7See7/YI5izGYnJI5V
         IAV/expdJmASHN2iU3Tpp0HITZILUsyvrBKOFspglPCO5S2tIKFc6Uhf50ws+LKt8v1q
         V+/NfeC828eRkrlVvi0q86CoCLLFKJpxNYJF499nPqkGJ5AoDrBVe/3wPvNtCKUF/fdP
         Hr5jrQJTmiCUQMD9hrNNP/wUOzRGjtll2Ep7D40W3SV2pahKmMSmv75Bx2/e4fFHa6dj
         RD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=09Vt4G6n2lDrTYL/OjY7UiKCXH1y9x+5kX8o8WWVQgw=;
        b=rLzomKUauY6fxWcqWgSOMcfGyL8BF/AmLbIMi7obTzTtU4GB0zSfhEid83AK6KqFjz
         wvfDy1R9cICOZ7gwR3JE9qPYlLIfIRyWQdG7cukcGZ7ZYjT3vNgEdgzNOkCr4HhWCKFs
         68tuhp6BZj8WlUU2JZ31dEKNZWV8eoA1lQNdaLo6nYq/dnItZH6qAmSgKZlU6FWTRo/u
         wDs5c8DCMVU3JmLlvEPZANcjbriJNQdpEv7CnLtFIRt9N4KS6PZJxk1T2sYoa3F6u4U/
         ruqM9H952kOy4RNenOIZYJ8x1DZ3a+ZvZVaYK2IqfJvZHxD02+Ci2AC0dO/BNPrez/t+
         7v+A==
X-Gm-Message-State: AOAM533uQjNrJEBIDB+Dl95c52rZMZbOGJz7Tc3nzxsOtVWw59A64LMn
        jA7AhV6v3r8Q+1wcI8ZvYLY=
X-Google-Smtp-Source: ABdhPJyqLCkqK3/akcURR3Rflog2HpRW6HLgyMluoXrSsDXRzsGQg+YZm5qwdBADAFGOHLV5BJzY5A==
X-Received: by 2002:a17:903:189:b0:15e:9584:fbe7 with SMTP id z9-20020a170903018900b0015e9584fbe7mr14570008plg.65.1652064453194;
        Sun, 08 May 2022 19:47:33 -0700 (PDT)
Received: from sultan-box.localdomain ([204.152.216.102])
        by smtp.gmail.com with ESMTPSA id s24-20020a656918000000b003c14af50607sm7346077pgq.31.2022.05.08.19.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 19:47:32 -0700 (PDT)
Sender: Sultan Alsawaf <sultan.kerneltoast@gmail.com>
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] zsmalloc: Fix races between asynchronous zspage free and page migration
Date:   Sun,  8 May 2022 19:47:02 -0700
Message-Id: <20220509024703.243847-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

The asynchronous zspage free worker tries to lock a zspage's entire page
list without defending against page migration. Since pages which haven't
yet been locked can concurrently migrate off the zspage page list while
lock_zspage() churns away, lock_zspage() can suffer from a few different
lethal races. It can lock a page which no longer belongs to the zspage and
unsafely dereference page_private(), it can unsafely dereference a torn
pointer to the next page (since there's a data race), and it can observe a
spurious NULL pointer to the next page and thus not lock all of the
zspage's pages (since a single page migration will reconstruct the entire
page list, and create_page_chain() unconditionally zeroes out each list
pointer in the process).

Fix the races by using migrate_read_lock() in lock_zspage() to synchronize
with page migration.

Cc: stable@vger.kernel.org
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 mm/zsmalloc.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 9152fbde33b5..5d5fc04385b8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1718,11 +1718,40 @@ static enum fullness_group putback_zspage(struct size_class *class,
  */
 static void lock_zspage(struct zspage *zspage)
 {
-	struct page *page = get_first_page(zspage);
+	struct page *curr_page, *page;
 
-	do {
-		lock_page(page);
-	} while ((page = get_next_page(page)) != NULL);
+	/*
+	 * Pages we haven't locked yet can be migrated off the list while we're
+	 * trying to lock them, so we need to be careful and only attempt to
+	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * may no longer belong to the zspage. This means that we may wait for
+	 * the wrong page to unlock, so we must take a reference to the page
+	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 */
+	while (1) {
+		migrate_read_lock(zspage);
+		page = get_first_page(zspage);
+		if (trylock_page(page))
+			break;
+		get_page(page);
+		migrate_read_unlock(zspage);
+		wait_on_page_locked(page);
+		put_page(page);
+	}
+
+	curr_page = page;
+	while ((page = get_next_page(curr_page))) {
+		if (trylock_page(page)) {
+			curr_page = page;
+		} else {
+			get_page(page);
+			migrate_read_unlock(zspage);
+			wait_on_page_locked(page);
+			put_page(page);
+			migrate_read_lock(zspage);
+		}
+	}
+	migrate_read_unlock(zspage);
 }
 
 static int zs_init_fs_context(struct fs_context *fc)
-- 
2.36.0

