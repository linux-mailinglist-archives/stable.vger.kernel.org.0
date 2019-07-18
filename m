Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDA66C3BA
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 02:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfGRACr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 20:02:47 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:49725 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbfGRACn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 20:02:43 -0400
Received: by mail-pg1-f201.google.com with SMTP id 30so15560590pgk.16
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 17:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d2opEawD5+UpjHd3NqyX+5wHPW1XJIxl9MSYmfk275Q=;
        b=JzADRtkOw2096YFXxVSMAzsSWjQX8A9aoK4y1dNuoORdeMgF6K2He4c4O4zv+SvN1C
         UNqNMY/GIiooHoE15NvVgxlMs/qpJxGGW8RFAoHq/wQ6szsqmG6LnRHB4dULrMiW4Vzg
         IUj4LTC/4PLSbvqJwgooz1Mlzhu1UhCeAzoMilvUyGj/7izvs3+tWqOjcFQR2KUg25Si
         omfLoHXCTMhlrVNQEY9J5rCa7XG2EOcD+J5GGbnvSsBg6GUf8Gelz5fbj6EqKMRp7c0Y
         L5YSYp3s7fpOT6STKRp3YIixv/u1jSSDhY/5h3ag4LEIAN3yGLS7G6GAXS9ckGFD8wu0
         1tmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d2opEawD5+UpjHd3NqyX+5wHPW1XJIxl9MSYmfk275Q=;
        b=ZGoM4M0Ue/JTHjVF4p2i3UDPq5Kp5hilbj+Szu1sFt+7a8m0huaeGKlPx+P8GDffxg
         of/i7O23PA7J1QdaXQe3RP22N/dQXyTjbhdKGE9GoVVwFkkgFwgeDpXOM31ppIfIHf6n
         NYLj0I/wS3m3e94IExtcuZ/FoKU1W5nTEbQTRZQSU4Ql/JtL4GWntD+hWprjSEM++Cc2
         WUo/6tZX6ISpB8tNMz8Z/R7CBHD6C9LvGgJU0xF3iidRX7eZwYF82wwg0biw1dxDrSoT
         tXrMPtWKXiu5gt+oSYVbZiLHdU9PW0/wi0uOqWyGimynsgFyuljVkwffYD3GKTHoIOkE
         A2TQ==
X-Gm-Message-State: APjAAAVdC6l09ZUjA8wqurm6g+AOzRg0uNKzDpftedrfVRoeVnvDLSA/
        YPhJ5F13W1rZGW53T/4f25gVn7guXw5tK8P4z6GitQ==
X-Google-Smtp-Source: APXvYqx8C+Hy6Xs2urAbdNvACQ68TCh4KNRmJw+r8zbsjI0Iz08oehTCqQsB2iYjkYZRoMBdYUgYRrzMAIY59zdjl7ZMAQ==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr728662pgn.144.1563408162493;
 Wed, 17 Jul 2019 17:02:42 -0700 (PDT)
Date:   Wed, 17 Jul 2019 17:02:05 -0700
In-Reply-To: <20190718000206.121392-1-vaibhavrustagi@google.com>
Message-Id: <20190718000206.121392-2-vaibhavrustagi@google.com>
Mime-Version: 1.0
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH 1/2] x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to Makefile
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>,
        Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Compiling the purgatory code with clang results in using of mmx
registers.

$ objdump -d arch/x86/purgatory/purgatory.ro | grep xmm

     112:	0f 28 00             	movaps (%rax),%xmm0
     115:	0f 11 07             	movups %xmm0,(%rdi)
     122:	0f 28 00             	movaps (%rax),%xmm0
     125:	0f 11 47 10          	movups %xmm0,0x10(%rdi)

Add -mno-sse, -mno-mmx, -mno-sse2 to avoid generating SSE instructions.

Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
---
 arch/x86/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 3cf302b26332..3589ec4a28c7 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,6 +20,7 @@ KCOV_INSTRUMENT := n
 # sure how to relocate those. Like kexec-tools, use custom flags.
 
 KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
+KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-sse2
 KBUILD_CFLAGS += -m$(BITS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
 
-- 
2.22.0.510.g264f2c817a-goog

