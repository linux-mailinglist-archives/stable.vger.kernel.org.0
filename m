Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E17855A7F6
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 10:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiFYIEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 04:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiFYIEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 04:04:38 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41F3FD12;
        Sat, 25 Jun 2022 01:04:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r66so4453824pgr.2;
        Sat, 25 Jun 2022 01:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BfzrLrWFlU3AsBKqqcHgoNoL2/cAeQlLWsne6vZJpyA=;
        b=gSnHhutlBGP0Zc+ke5/gSYv2nW8AY/IpA/SwV+4+7wiGESDHAf8BgjxZZ3EFN+DdEH
         f+/9k4M2yvJV9hw9JWBknq1f3ZsTTg/f4CDLrJ2r2vGBjh/ZFtxYSXEG6C475B5rWxN1
         5gbKYQovNRteKDG0Ga5xz93ysmM+5W5c26mza0Fa0afXMoKGjCa1NwE98/77WJ6QVqUG
         4pY0+HiRTkRUuZaA38bFeOr4AyrAB40vHsat5xjbHADCw7QBVYi2Ci/eQpcuFMLTzzMg
         nn/fa+LiUBnTFAV0Ptcnx6VrYISzLutBG98U6zRPzeUasA1ULuM7/O6vbVf1OX4eBL7m
         en4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BfzrLrWFlU3AsBKqqcHgoNoL2/cAeQlLWsne6vZJpyA=;
        b=IDtuabp/uKgHteJoB3XcFvSnrQJoY8bHVVVX4R57rQS/rpC55998M0BqCWTYHklKgv
         PsB/nbbAFbVhGxbd9SuDZP/QQX7WIFZmznI4gp6hqRXfdQq3NsSo7oGmHr/TYN1IMGpl
         Kj2KkOr1uKVCnvKsme56vxYpcmemONcXaGx5xWTihiC7l32Iny7XSIFob+oxkvrIB9vV
         +uXpOprOMEkAeKNGfZTneovOQDtGam5ISgzOiT1R2/xi2iE/JJO5Ijr6+hdK7YZufkIK
         Vhv5uVQ4RZGk9vKMmdutbkGJMi/P+0PRcssQDq9Qt8qINLEcHcfwxDChUQaeFsbvqTpL
         Oijg==
X-Gm-Message-State: AJIora/yldWtGRejfNObvFxR70Rbji+0y95LgFdQKf4OGFeNnGUsMfcj
        OmA5lLm6R1zqF+XZAU8y12c=
X-Google-Smtp-Source: AGRyM1sxtS9VevqvfBbYWfIogi3zIDyhDpdZQ4zG+5Ws8pWwVgzyfWnuLDMmesowsg6pj5ia02Qpuw==
X-Received: by 2002:a05:6a00:2292:b0:525:6c57:8dd5 with SMTP id f18-20020a056a00229200b005256c578dd5mr3131042pfe.17.1656144276147;
        Sat, 25 Jun 2022 01:04:36 -0700 (PDT)
Received: from localhost.localdomain ([112.20.112.134])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902a50900b001690ca017fasm3056609plq.38.2022.06.25.01.04.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jun 2022 01:04:35 -0700 (PDT)
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
X-Google-Original-From: Feiyang Chen <chenfeiyang@loongson.cn>
To:     akpm@linux-foundation.org, willy@infradead.org, vbabka@suse.cz,
        songmuchun@bytedance.com
Cc:     Feiyang Chen <chenfeiyang@loongson.cn>, chenhuacai@kernel.org,
        chris.chenfeiyang@gmail.com, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] page-flags.h: Fix a missing header include of static_keys.h
Date:   Sat, 25 Jun 2022 16:04:23 +0800
Message-Id: <20220625080423.2797-1-chenfeiyang@loongson.cn>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The page-flags.h header relies on static keys since commit
a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
with a static_key"), so make sure to include the header to avoid
compilation errors.

Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
Cc: stable@vger.kernel.org
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
---
 include/linux/page-flags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e66f7aa3191d..147b336c7a35 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -11,6 +11,7 @@
 #include <linux/mmdebug.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
+#include <linux/static_key.h>
 #include <generated/bounds.h>
 #endif /* !__GENERATING_BOUNDS_H */
 
-- 
2.27.0

