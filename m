Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9976CC804
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 18:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjC1QbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 12:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbjC1Qag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 12:30:36 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659AACDE7;
        Tue, 28 Mar 2023 09:30:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z19so12244694plo.2;
        Tue, 28 Mar 2023 09:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680021035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6cp3hZpmMkj3LJBeC/SGV9aCh/7ARFpl+ERfyritQVU=;
        b=NI8a+SZgZ2/8RILumxLjqGrYUxI7+Misxwqzcbo3JtDUMYM4N0UMIM8gJwbsIhc6WB
         reHEU3+jREon5ZIlLEolgafDb2UExAbxbiAmxhDvnobMI0J882SBjoOxqxVNQNFHh1S2
         0taTKxthhehl8TOvsUs8/EPWznDMJWUAbkiePnXrwbUSnl0RZg5jlSah/OWvVphaOkfJ
         5dVHm5cAv84Bqji+Lgr2RtxfXOfBjlmvo1fiXpASeDm1bA5vQ0ghEaqSTbpSDVKSbqKz
         jzpNg3uRrJnOk88X7gUFYN1QlXFS8qlnz/SYCH2KJ9PMqq5gQGDM2c1ZVYkNN5ueO8cm
         MTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680021035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6cp3hZpmMkj3LJBeC/SGV9aCh/7ARFpl+ERfyritQVU=;
        b=mbiCQgRZAqe1k9Z6HoIY9CtjyozPV4OGqnCegH/OBeK7/Kbf1lB6WAdnVjEV8/+CsV
         En3WriQzzzPhbG0GxsjFnSQ3kAG+F4Z9i/QdqfjcOVTMG7vDEcB6qRKJ2dCTdL57YukI
         AVYDcB1vondqI1X1SBwNNJEnVqJ159n/v1Sl9rvF3B4VkE1u/1771BPmnwjLYppFG2LI
         bGKzp/A25w5v5/ElYHtjHLSDn0VahICtCMDhhz4xJAFbeMupbv4mo7yfLHvfbWwBA456
         NP7wBUIqP8qucm8aZ26Ha9vfd4SqyPHkE85tNGyQno0mjXkOXZD4EFSyOj7NBQ7nc/8s
         oMKw==
X-Gm-Message-State: AO0yUKW7MZ3Lc+rSyUJd9zb183+SSnO4zimIfratcRzmh4B/5ODok+1N
        UYwGuERvboo5mRhrYs/5dw0=
X-Google-Smtp-Source: AK7set9pDNfylTlDix0ysd/Jj09hT3+N6/Wb/qgtWNiN3xtFp6pVScb+Ln5C2/3K+rULqhF81hV/nw==
X-Received: by 2002:a05:6a20:6695:b0:cc:6699:dd8a with SMTP id o21-20020a056a20669500b000cc6699dd8amr15589058pzh.45.1680021034781;
        Tue, 28 Mar 2023 09:30:34 -0700 (PDT)
Received: from localhost.localdomain ([60.177.121.211])
        by smtp.gmail.com with ESMTPSA id n26-20020aa78a5a000000b006260e5bdd81sm21107337pfa.45.2023.03.28.09.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:30:34 -0700 (PDT)
From:   Bang Li <libang.linuxer@gmail.com>
To:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bang Li <libang.linuxer@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] mtdblock: tolerate corrected bit-flips
Date:   Wed, 29 Mar 2023 00:30:12 +0800
Message-Id: <20230328163012.4264-1-libang.linuxer@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mtd_read() may return -EUCLEAN in case of corrected bit-flips.This
particular condition should not be treated like an error.

Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Fixes: e47f68587b82 ("mtd: check for max_bitflips in mtd_read_oob()")
Cc: <stable@vger.kernel.org> # v3.7
---
Changes since v1:
- Resend this patch with Cc and Fixes tags
---
 drivers/mtd/mtdblock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 1e94e7d10b8b..a0a1194dc1d9 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -153,7 +153,7 @@ static int do_cached_write (struct mtdblk_dev *mtdblk, unsigned long pos,
 				mtdblk->cache_state = STATE_EMPTY;
 				ret = mtd_read(mtd, sect_start, sect_size,
 					       &retlen, mtdblk->cache_data);
-				if (ret)
+				if (ret && !mtd_is_bitflip(ret))
 					return ret;
 				if (retlen != sect_size)
 					return -EIO;
@@ -188,8 +188,12 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 	pr_debug("mtdblock: read on \"%s\" at 0x%lx, size 0x%x\n",
 			mtd->name, pos, len);
 
-	if (!sect_size)
-		return mtd_read(mtd, pos, len, &retlen, buf);
+	if (!sect_size) {
+		ret = mtd_read(mtd, pos, len, &retlen, buf);
+		if (ret && !mtd_is_bitflip(ret))
+			return ret;
+		return 0;
+	}
 
 	while (len > 0) {
 		unsigned long sect_start = (pos/sect_size)*sect_size;
@@ -209,7 +213,7 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
-			if (ret)
+			if (ret && !mtd_is_bitflip(ret))
 				return ret;
 			if (retlen != size)
 				return -EIO;
-- 
2.25.1

