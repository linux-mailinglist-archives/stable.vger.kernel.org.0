Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3080561432E
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 03:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKACYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 22:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 22:24:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93CB101E0
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 19:24:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so17598071pji.1
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 19:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GitM46EFRM9nH6tIDAppCJX9q32SAFXaMRLIqIakjjU=;
        b=l98qeV3Jl06cF0GHoDotzNUlLR72obCljG0Olhz1Se0nlIdIJIHkSt0DmWgtqZvEPZ
         tQEg0+BLFGOJt26/7J8kijyufjXpByTTDwSnywwKUIZt7sZjjqOajvnOZvgVYLe2WtwX
         Tt88uPmFFYiCJQNdGKvIpmsF1dUjCMUb/lwHSyAXympKswmc7wKShns1YToayDMercnA
         iDtWvXICq61Dvx26LSYTlYzclvBVEkozLGodeCmHJ5kQlvxh2LX94g/zvG2+x1LS781D
         DbM7Cy/0VvXLh19GvA7fgX+SKe3Swm4Dp6SBm2KcdUvSDqiyEJeoW+bhmaZxTaodlvc4
         r9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GitM46EFRM9nH6tIDAppCJX9q32SAFXaMRLIqIakjjU=;
        b=7XqFJigrTP1b0b7DooGgGrAYjxkRHme4VUMVhjEWXe3LDakcY8kafau7IL1n4vlhE9
         pdRQMAkqLILlIQJpUq05CRVGOrxp1LtpUlBGjNseCqzB/qWp/SmZjaganbTOSI781J1u
         A9WvhhVeb3TbT3AVOf98EI4PXkM58B7F5DljfP5TQc30lcK50Yy+hyfL3iFT3N5iFI8I
         qfT3ZtSWS1ukGJwicZD9VDYEAfWmGJnEnKOnXIHN1Rg4ord6YrPbjC9nDEmFEJmyLB9O
         oHsa1XWa9NcWJ4hzlpFEUusIJyi43s22/vXl7z6iAkGKlIB9vY7JFv4m2rxcz6YJ78nt
         5ssw==
X-Gm-Message-State: ACrzQf0cRc3RA5ROI2hVksXd+73NN+mZXcOEEw1q4wWAzv4K7nHnt6lb
        MAcU51/zfkKKVn1yJ1383TK9SBEUTnrAPcV1Xfg=
X-Google-Smtp-Source: AMsMyM5LV3+JR6SC8g3LdWmmv4+mh3MPppYCkYKq7Uy7/tBON2ER6Z9/i8ep4Xlzkek8vgcJEKWamQ==
X-Received: by 2002:a17:90b:4c46:b0:213:d3e3:ba44 with SMTP id np6-20020a17090b4c4600b00213d3e3ba44mr10275472pjb.18.1667269481319;
        Mon, 31 Oct 2022 19:24:41 -0700 (PDT)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 129-20020a630387000000b0043a1c0a0ab1sm4849062pgd.83.2022.10.31.19.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 19:24:40 -0700 (PDT)
From:   TGSP <tgsp002@gmail.com>
To:     xiongxin@kylinos.cn
Cc:     stable@vger.kernel.org, huanglei <huanglei@kylinos.cn>
Subject: [PATCH -next 2/2] PM: hibernate: add check of preallocate mem for image size pages
Date:   Tue,  1 Nov 2022 10:23:42 +0800
Message-Id: <20221101022342.1345980-3-tgsp002@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221101022342.1345980-1-tgsp002@gmail.com>
References: <20221101022342.1345980-1-tgsp002@gmail.com>
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

