Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D771EB211
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgFAXST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgFAXSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:18:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8305AC03E96B
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 16:18:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c3so4737290ybp.8
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 16:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m13wCjxvuAss7NYvH083DUgqdGzlzjUJaqo6EGXo6l8=;
        b=hGSPlVHMPFqP8l1gdyaycFTDNYeJq+dmve4OcRx0o+NeFXjZUheZXksaQ3egykT3/V
         y3TrMe5GShycYHLIG9qR1qiVRi7FAG/jm43g8+Ud2xrrKhyEfB4RKkxmvPirR5YEKEDZ
         ZETulQIHcmg24tf9rxwGMM7FbhCEyAx78T7pYUbp+woYvGe0RFIl3qSPbmvVSpXfKVCc
         Tghecr2RnKGgHCBnF88MYyD2bMpevoM/xqi5YP+CqERPdo96+ROU7B14cSkX/GKFXAC/
         06Xdutj2ar9pRf2+dnMQTRlul7bsHDMZ7dWvbohS19s78wWY/19IxeUhRQTS4s5V5a2s
         pn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m13wCjxvuAss7NYvH083DUgqdGzlzjUJaqo6EGXo6l8=;
        b=AANaA26h2bBS11+ua/D0Rha8NVqOfJimp9QIFnnbLx3Jb3Yo0Y60fWS+KRlF1YbZ86
         NO9zY0GaSOrvCibQG+M//NEFpOriCDOlVUMUut3JXZjCKQYNdtMsbENJ8jstq6PRP8D2
         5Yp9PJgHO5qeFzp/p9bScCfbtEqW9K3y4dE/dRKXakjqF7IW+edxRD5eJYim3wkNz4un
         PeoLZLX6ju6uGEXYuZr5d+kT0ohQ68uNd+NsJ1fTB28QPz6Jzabng6zf+AeFoaj4ZNw+
         PuuflEgki5wGY0pT59R1rutN0Oa3dEd7amd8spu1RZOP26bTGIVAJ2eg1AEefFVv+vE5
         49yA==
X-Gm-Message-State: AOAM532iAgacJJ53ZTXPRjilrNP+1yVdEJnz/6NDbLYQvJseNnXY1GPv
        xWJyGyBUGvorAuBl2XHs1CZHGy9SBlhB3r80MQI=
X-Google-Smtp-Source: ABdhPJwdKP/WIyb9zDhrdkpb/1aIfGh8Qv+dbXIL0nNPDlwjoNFg5jPiVanp/p5l0pHmiW9OMy1EYfxKlHO/6B0TWDI=
X-Received: by 2002:a25:d28d:: with SMTP id j135mr34423503ybg.208.1591053497544;
 Mon, 01 Jun 2020 16:18:17 -0700 (PDT)
Date:   Mon,  1 Jun 2020 16:18:05 -0700
In-Reply-To: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
Message-Id: <20200601231805.207441-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Robert Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, dvyukov@google.com,
        glider@google.com, guohanjun@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lorenzo.pieralisi@arm.com, mark.rutland@arm.com,
        ndesaulniers@google.com, pcc@google.com, rjw@rjwysocki.net,
        will@kernel.org, stable@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Will reported UBSAN warnings:
UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6

Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
can avoid this by using the compiler builtin, __builtin_offsetof.

The non-kernel runtime of UBSAN would print:
runtime error: member access within null pointer of type
for this macro.

Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
Cc: stable@vger.kernel.org
Reported-by: Will Deacon <will@kernel.org>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/acpi/actypes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 4defed58ea33..04359c70b198 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -508,7 +508,7 @@ typedef u64 acpi_integer;
 
 #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
 #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
-#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
+#define ACPI_OFFSET(d, f)               __builtin_offsetof(d, f)
 #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
 #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
 
-- 
2.27.0.rc2.251.g90737beb825-goog

