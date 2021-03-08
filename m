Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B91331182
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCHO6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhCHO63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 09:58:29 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45632C06175F
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 06:58:29 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id s16so7842957qvw.3
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 06:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=BxhzP0W+qvkeGdKa9mCwOIPGRH/6WApGqekyUBkmdsU=;
        b=CY88Hxf2Z8/gwTvCyBxUyuzMp7CoVm0G6k9lqiClBdaCH8B5QSel2N2Mj5PLm0i3yT
         Hqvloxqbm9lRHA6jBiv/OWaskMEaPGN+1X+POacMZcPwB0m699GyZlTZnfpZbVkH/D8r
         XM4GR0+EFi/Fv45w2TSAKL7nwGE8yTLUFS5AixCu+fjtSz41gcxDUOo21IUJdspNEp13
         ewzp80BiD5xk0THgDQCxFULqm6xCJemMN/4iEmTcDHN3vS8rGKtG3skn1wdaO42YSiaz
         H/n5YdB6s79G30DRpGrJarKGHI0X3p9oLJikdt69GK7B01LI5G+VV/i3sIZFhzKBbToP
         zP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=BxhzP0W+qvkeGdKa9mCwOIPGRH/6WApGqekyUBkmdsU=;
        b=LteHhWDcJH2vdO1sSTVxC6OxUe0HLBItArBE5p6BQTze0zclcC0D76tzcVJ6L/kipP
         0f3VIYfw/WiYPB8uH06oZoPErtNUWv3UQlcJCzVoiikQC7tWFeJsWSlXZxM6BZ48Pa/E
         UZLtQA350czjQy+At5zs5Y+/MwjRMhVpHCVCkz9E63E7fVfwsdfBsrmJ1NkpQMJb6r3U
         MuJ7818/KlTiaGCT7laiVJzVnof8BMtwj8VL5w3Z3W8FKuoCEswGi+Ltz3zcYbxorbIk
         +vB9TTGNxAJR5KgKVtZTLay1/EoK5a1vAVfPKg2huZxvnVoF3Cz6aMByr0dMj2gRyO3F
         a3JA==
X-Gm-Message-State: AOAM5330lM+8HK8BxH/fZ6ezFJneLL3vErMzAGbMINAZcZawiRvwJh1h
        UBEui5UTuD2xv9WyUs5Gh9ge7wTuopAaiZIl
X-Google-Smtp-Source: ABdhPJyIR50ri0LAWjT90EsKXlRruxnqF4NWGe0j6wHw7WPZvJUWWmFvWXg60/U+OgeRpKTWkVSKKitaM0gH1zUr
Sender: "andreyknvl via sendgmr" <andreyknvl@andreyknvl3.muc.corp.google.com>
X-Received: from andreyknvl3.muc.corp.google.com ([2a00:79e0:15:13:85fb:aac9:69ed:e574])
 (user=andreyknvl job=sendgmr) by 2002:a0c:b418:: with SMTP id
 u24mr20842991qve.20.1615215508348; Mon, 08 Mar 2021 06:58:28 -0800 (PST)
Date:   Mon,  8 Mar 2021 15:58:21 +0100
Message-Id: <59e75426241dbb5611277758c8d4d6f5f9298dac.1615215441.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] kasan: fix KASAN_STACK dependency for HW_TAGS
From:   Andrey Konovalov <andreyknvl@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's a runtime failure when running HW_TAGS-enabled kernel built with
GCC on hardware that doesn't support MTE. GCC-built kernels always have
CONFIG_KASAN_STACK enabled, even though stack instrumentation isn't
supported by HW_TAGS. Having that config enabled causes KASAN to issue
MTE-only instructions to unpoison kernel stacks, which causes the failure.

Fix the issue by disallowing CONFIG_KASAN_STACK when HW_TAGS is used.

(The commit that introduced CONFIG_KASAN_HW_TAGS specified proper
 dependency for CONFIG_KASAN_STACK_ENABLE but not for CONFIG_KASAN_STACK.)

Fixes: 6a63a63ff1ac ("kasan: introduce CONFIG_KASAN_HW_TAGS")
Cc: stable@vger.kernel.org
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 lib/Kconfig.kasan | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 624ae1df7984..fba9909e31b7 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -156,6 +156,7 @@ config KASAN_STACK_ENABLE
 
 config KASAN_STACK
 	int
+	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	default 1 if KASAN_STACK_ENABLE || CC_IS_GCC
 	default 0
 
-- 
2.30.1.766.gb4fecdf3b7-goog

