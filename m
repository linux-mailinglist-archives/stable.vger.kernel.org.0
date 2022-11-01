Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12FE614338
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 03:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKAC3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 22:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKAC2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 22:28:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2321D13E;
        Mon, 31 Oct 2022 19:28:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p21so8493768plr.7;
        Mon, 31 Oct 2022 19:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GitM46EFRM9nH6tIDAppCJX9q32SAFXaMRLIqIakjjU=;
        b=jH3NvDCyBGXMBaUTMBOvkNef8p9Z0VL8qnWhCvi1CTp9CmZfiFm2mNXMFVRACIbxqw
         cwWoyLGSHOe3qVRquSR8VN5C4hCEK1au5oRDOi+Bd5HG9wi9gMNcgbk4g8rd/ceqFBbk
         IN4dQ3PK03TQyCZk8aguSBzrkCq7hwpNcDik2LXJdWnwMq0hJ89pqAMzo7y6eqwdJ2KF
         PsUG1EoGlPHx4F46ITYdA4ePouSbjaley6tLhKljI6o/a1/snxg6BTiU/RkitsV1fAuX
         7w43sG0PPrzHFGX44CI9BqAeC7CTCa/D18yPOiRKN3Nm4v6kvyzK+I7Fn00X+ZZh2m5v
         XHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GitM46EFRM9nH6tIDAppCJX9q32SAFXaMRLIqIakjjU=;
        b=E+mZb8vtiZUf/NL5IbK6iVkMGnl38hfPZGb4X/ryfJSIribWgQWrsS3bNwgNgy7M8m
         uPK2xJAiEfZ4D3WiVe/nCA8HwYt1AmCDFqjrHQR3OSuH7tcTGThWcPZJ8zBKNbkVz/w6
         bH6kX9TVMm2iyCtNKUyUyT4P/1F5GLZMT6Z90tAXXq9vdwwH0/Ryw44K5imq/fFEx2xr
         ETSqPB1IKD+61G7FyF+0PQJzqPH8JSEqleJx5p4Pd4wV2TNLx3EQmhdvNDVRnz7WzNwG
         djVtITh3msVwZxS/ApAZnopvkiW2Dc53z0BfMtbAwZ90GncabZJQNsPyZ16804Iu+KAV
         3N+A==
X-Gm-Message-State: ACrzQf0t0KfSWjn1REnM4BUf3Dvte1keu7fBFAeSpVP2l7BJoLv/lUIh
        f9MqPhBITplEzE8GuzfnsTo=
X-Google-Smtp-Source: AMsMyM7uD7HN829N+C1C4t09vo0KK4aDVkMaEbkwQUkvJuBMdbb616LQFG4C5eXBXRIIdRUgC0Q4dQ==
X-Received: by 2002:a17:90a:13:b0:212:d139:748a with SMTP id 19-20020a17090a001300b00212d139748amr17340844pja.182.1667269730416;
        Mon, 31 Oct 2022 19:28:50 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id t5-20020a625f05000000b005385e2e86eesm5126925pfb.18.2022.10.31.19.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 19:28:50 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH -next 2/2] PM: hibernate: add check of preallocate mem for image size pages
Date:   Tue,  1 Nov 2022 10:28:40 +0800
Message-Id: <20221101022840.1351163-3-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221101022840.1351163-1-tgsp002@gmail.com>
References: <20221101022840.1351163-1-tgsp002@gmail.com>
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

"pages -= free_unnecessary_pages()" below will let pages to drop a lot,
so I wonder if it makes sense to add a judgment here.

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Signed-off-by: huanglei <huanglei@kylinos.cn>
---
 kernel/power/snapshot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c20ca5fb9adc..670abf89cf31 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1738,6 +1738,7 @@ int hibernate_preallocate_memory(void)
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
 	unsigned long alloc, save_highmem, pages_highmem, avail_normal;
+	unsigned long size_highmem;
 	ktime_t start, stop;
 	int error;
 
@@ -1863,7 +1864,13 @@ int hibernate_preallocate_memory(void)
 		pages_highmem += size;
 		alloc -= size;
 		size = preallocate_image_memory(alloc, avail_normal);
-		pages_highmem += preallocate_image_highmem(alloc - size);
+		size_highmem += preallocate_image_highmem(alloc - size);
+		if (size_highmem < (alloc - size)) {
+			pr_err("Image allocation is %lu pages short, exit\n",
+				alloc - size - pages_highmem);
+			goto err_out;
+		}
+		pages_highmem += size_highmem;
 		pages += pages_highmem + size;
 	}
 
-- 
2.25.1

