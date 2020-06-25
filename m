Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3920A531
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390903AbgFYSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390007AbgFYSst (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 14:48:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F67C08C5C1
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 11:48:49 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id v20so4690265qvt.15
        for <stable@vger.kernel.org>; Thu, 25 Jun 2020 11:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=KSzIS4R7pLrhz4aCSES8O8YLNhHnwl2dEbCnP+qYXsc=;
        b=knKRqtKFatSe2XltGnadadXYJpHZawUTiMMobs3BChNf5NM/0u4nk3w1QtVHi/2TGJ
         MGNBG0TtVcq9viEuR8zd0jqEo96IcfEx2gHSvdbcB3ckYEBrQpTXPq6tK7H3viZFPRCh
         W+tC3F45N6UTYj0fflhVzOdIoHvpOoyhbYthTQDmVfNUqHx0tGPh7vhaiXJwh7WiaksG
         7Kf5IMLzUrlNU6YJQr6tdlMkp4qTejHrXN7RwXjbYezMfBQiMV6OqL4xP8Ruhg7l7wC+
         7t2aLAeRG5q6VH6HMvzX+Eg6XRp5dSUfVkt84VBZgheT20HcdfWZHWgyMfgVe44smHLm
         eYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=KSzIS4R7pLrhz4aCSES8O8YLNhHnwl2dEbCnP+qYXsc=;
        b=LYDaDKVZdW8bu7UZwmwgOmIlYjFyum7LMBh63fIr6dtdCmzkC46jVEY0yFgQWC6edM
         oysb21gHMwS0dB8cHfOoOC3/RBSgOztrdp/8zGbEc+gGH9MIpJ+dyg5JgII5YI8eNhO+
         Vujx4skL+mJoa9GN+N4FchFi+Xyb49Ws0hw8rK4j9o9TC2uZgaqRhYV0jMHcg2GaVJzG
         /IEwigFJBbVO0290RhH/o5F4BP9Ib2IdLV2bStdqjMIBu4DU9gngkq85oE7t73KXHJ3i
         f4yOpetJpcBFqShD1b9g7n/gGFwOhrck6TyHOw7bxinzH+7zfrzqzyZX//5EEs/JjGah
         ge7w==
X-Gm-Message-State: AOAM530iLdkoxPq3ilcMOm5/MDV2sy322/nZuxHm8q8uHEBUPLJXiACv
        uWxZ/UF8Mf6ViRYcRRAwAVON0QwLsSALRcgWjRo=
X-Google-Smtp-Source: ABdhPJwpHZDZ91owWQoTpMlESBLCeHg8NuUS9EMzPrkO+lVDZd6/NrsL86bqM72qrEUkcdUo9qL+h6YICos7y0g6pbU=
X-Received: by 2002:ad4:44a6:: with SMTP id n6mr2687847qvt.113.1593110928539;
 Thu, 25 Jun 2020 11:48:48 -0700 (PDT)
Date:   Thu, 25 Jun 2020 11:47:52 -0700
In-Reply-To: <20200622231536.7jcshis5mdn3vr54@google.com>
Message-Id: <20200625184752.73095-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200622231536.7jcshis5mdn3vr54@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v2] vmlinux.lds: add PGO and AutoFDO input sections
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "=?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?=" <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Basically, consider .text.{hot|unlikely|unknown}.* part of .text, too.

When compiling with profiling information (collected via PGO
instrumentations or AutoFDO sampling), Clang will separate code into
.text.hot, .text.unlikely, or .text.unknown sections based on profiling
information. After D79600 (clang-11), these sections will have a
trailing `.` suffix, ie.  .text.hot., .text.unlikely., .text.unknown..

When using -ffunction-sections together with profiling infomation,
either explicitly (FGKASLR) or implicitly (LTO), code may be placed in
sections following the convention:
.text.hot.<foo>, .text.unlikely.<bar>, .text.unknown.<baz>
where <foo>, <bar>, and <baz> are functions.  (This produces one section
per function; we generally try to merge these all back via linker script
so that we don't have 50k sections).

For the above cases, we need to teach our linker scripts that such
sections might exist and that we'd explicitly like them grouped
together, otherwise we can wind up with code outside of the
_stext/_etext boundaries that might not be mapped properly for some
architectures, resulting in boot failures.

If the linker script is not told about possible input sections, then
where the section is placed as output is a heuristic-laiden mess that's
non-portable between linkers (ie. BFD and LLD), and has resulted in many
hard to debug bugs.  Kees Cook is working on cleaning this up by adding
--orphan-handling=3Dwarn linker flag used in ARCH=3Dpowerpc to additional
architectures. In the case of linker scripts, borrowing from the Zen of
Python: explicit is better than implicit.

Also, ld.bfd's internal linker script considers .text.hot AND
.text.hot.* to be part of .text, as well as .text.unlikely and
.text.unlikely.*. I didn't see support for .text.unknown.*, and didn't
see Clang producing such code in our kernel builds, but I see code in
LLVM that can produce such section names if profiling information is
missing. That may point to a larger issue with generating or collecting
profiles, but I would much rather be safe and explicit than have to
debug yet another issue related to orphan section placement.

Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=3Da=
dd44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=3D1=
de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Link: https://bugs.chromium.org/p/chromium/issues/detail?id=3D1084760
Reported-by: Jian Cai <jiancai@google.com>
Debugged-by: Luis Lozano <llozano@google.com>
Suggested-by: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
Changes V1 -> V2:
* Add .text.unknown.*.  It's not strictly necessary for us yet, but I
  really worry that it could become a problem for us. Either way, I'm
  happy to drop for a V3, but I'm suggesting we not.
* Beef up commit message.
* Drop references to LLD; the LLVM change had nothing to do with LLD.
  I've realized I have a Pavlovian-response to changes from F=C4=81ng-ru=C3=
=AC
  that I associate with LLD.  I'm seeking professional help for my
  ailment. Forgive me.
* Add link to now public CrOS bug.

 include/asm-generic/vmlinux.lds.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index d7c7c7f36c4a..245c1af4c057 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -560,7 +560,10 @@
  */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		*(.text.hot .text.hot.*)				\
+		*(TEXT_MAIN .text.fixup)				\
+		*(.text.unlikely .text.unlikely.*)			\
+		*(.text.unknown .text.unknown.*)			\
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
--=20
2.27.0.111.gc72c7da667-goog

