Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADBB219405
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 01:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgGHXEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 19:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGHXE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 19:04:29 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FF0C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 16:04:29 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 13so373339qkk.10
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 16:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H30vrOQhccXy2z47QDukRitq+MH3qKUcVxED3fXqq14=;
        b=pd5fjTGg8IdtNYtO/lHGKAz9d2SZPFouoIpNeSlUCDTLBtIrh2/I8I7U/8irXxQJSU
         9Tykg5Ogpx5oim6otterHsWP3x9tn0kH6sqxTqHk8Mn49gOqUqYkw2d+eo3Fz5IGHAT7
         t/CDTKbLZRQb8eSj2P5SxDaCerceRSB0j685tSuk3X5B0iMpmkMYZqnsEnoc3IhlzQjB
         4zKkb8w6I9zoovm3BdJ2A3zAKPUBFaYZTevK9xF2cXg77/h7lbUA5KyRnbhFr9bO/Vjm
         7iUrbhU4/oSJ6CvGXEL6oFqoc7jgnrZX2mm7WydBNnNNeCBGs9DR9Hw43PIC1d3i/fNd
         f2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H30vrOQhccXy2z47QDukRitq+MH3qKUcVxED3fXqq14=;
        b=jItCvnpkJ9qF6I8B7G4mS/bR20gFxt9O4CzwNmVdTQ7F7QWkpYQaHxSPL8ClIX3XPd
         cnDLi4Gv6xKYMPWHkuLzk8rfybwxcOgOab4rnu/cWaJhQmmOtOkUotRMOwtsk2gzNSJ6
         eO9SCwtxllprNxSbGpaGKrz27HGaSAUJIE5k74rFcTEPirrpShDrT86AK62iXp166OGS
         42mV/Hd/TDhuJem3BVExWLF4A7lUCMylE+tenqIju2tpCBhu2SyXFrL5+BSrcn4XNT8O
         CE4j45tstfAUSQTJeB6orG3cOX86AuKUxp2ja7/ldRc3oowGkqRZ8STXKZEG0YFd+IR6
         MIrg==
X-Gm-Message-State: AOAM530jIc5htN97BHLNs63JzVjJLf8ILYKYe1TlGsiZZVuujBkoGH4s
        ugIpzNFr6Ul+PzhYVP9Gs/lrvzGKKHpMaZ+V/3w=
X-Google-Smtp-Source: ABdhPJyCbEpTQo5d8KBsrN2ab+vvAVkwMfY8qhefN9+75WMTnJ3OnbMj5LjWLR3gjKX5dur1iSxAmbU7TJ982n7fJuI=
X-Received: by 2002:ad4:476a:: with SMTP id d10mr59900422qvx.13.1594249468307;
 Wed, 08 Jul 2020 16:04:28 -0700 (PDT)
Date:   Wed,  8 Jul 2020 16:04:01 -0700
In-Reply-To: <20200708230402.1644819-1-ndesaulniers@google.com>
Message-Id: <20200708230402.1644819-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 1/2 net] bitfield.h: don't compile-time validate _val in FIELD_FIT
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
compiler to deduce a case where _val can only have the value of -1 at
compile time. Specifically,

/* struct bpf_insn: _s32 imm */
u64 imm = insn->imm; /* sign extend */
if (imm >> 32) { /* non-zero only if insn->imm is negative */
  /* inlined from ur_load_imm_any */
  u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
  if (__builtin_constant_p(__imm) && __imm > 255)
    compiletime_assert_XXX()

This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
checks that a given value is representable in one byte (interpreted as
unsigned).

FIELD_FIT() should return true or false at runtime for whether a value
can fit for not. Don't break the build over a value that's too large for
the mask. We'd prefer to keep the inlining and compiler optimizations
though we know this case will always return false.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
Reported-by: Masahiro Yamada <masahiroy@kernel.org>
Debugged-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1->V2:
* None

 include/linux/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 48ea093ff04c..4e035aca6f7e 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -77,7 +77,7 @@
  */
 #define FIELD_FIT(_mask, _val)						\
 	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");	\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
 		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
 	})
 
-- 
2.27.0.383.g050319c2ae-goog

