Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CBF1FD6AC
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 23:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgFQVGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 17:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgFQVGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 17:06:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6D5C06174E
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 14:06:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 186so3964632yby.19
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 14:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=d0+Tzz9YePJeli6i74FfEPDYMLFJV/dTb97VxgPARRM=;
        b=s65S27c/KhuLOWAdWfLs8FLqZHfP5cSau7W+PswhE2Jr9spEw3hA0lbGxcJUfsJDgL
         mAg1ZrtF5oypvB0HM5sogq1N0s+ug/nOQ7/yvOxlCJKtbxguewHBg5KloSP4CbqEmOo/
         CCfvgxIrTsbIgLi7app8Hb6phNzgxKWbo4yQaEraDSljNMKaz1NJi3vx1Inw0SLHgTkj
         Ydvhkhn5cNvUjUH0z+DbN8O+kgn6bq/RF3WHmr0EpT4CuGQ0tZEY8j6N5T+4VDqMnsQ/
         qIPbR2yOvnBShQupKjFVRYYp3QPIG7dYj6mR2rfqMkjJqxnBtGoebDFB75f69nfKfNnR
         NHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=d0+Tzz9YePJeli6i74FfEPDYMLFJV/dTb97VxgPARRM=;
        b=suoCWPTCdAy/gxVAI2ldr8xmlCElKevB8YCzzHDe85HR5Ky8qqYHPODEhn4GAJA0t7
         Gqugu24c1BbrsFvVNs5MzN1uTvIPOADDj3kz7u6vNwGIYew8AzhFo9HQhuIMEYLNT6B5
         7cyiEMt4QUEPbCcKZTa7vOAYECW70/2ldCseurVWccauTynntCjOo5jfI0EuAMmQhR3x
         pjtdUZJG2fmPbmQLJm3K8ooJ9vZmGqzDk1D+RF8+wUOFfRU9v76ns5QbZnUISLMzCcmP
         0zMflT04reNK4yP1QnBC+IAydL74axHtKAKfUDOnz61ssjaBIsqrdc6D0JTaahrtGe0S
         8rtg==
X-Gm-Message-State: AOAM533e0jsNtEY0Rj+RwTrZ/Nri8SvIVCIqwwCwzXL4FwqDAzTaUNxi
        h2HyhJHWX1jc5u4pq1nH7oH0nYOrtKrNx8ZLais=
X-Google-Smtp-Source: ABdhPJz3iUzXFbAwSyuVvZKrE5dzrRwvPcbwlwoM2ZlgX9XqOxcOVvPsjbnvuxuVNelpg9On3Hff/YteVPpHN7/XyRA=
X-Received: by 2002:a25:7086:: with SMTP id l128mr1423806ybc.34.1592427983669;
 Wed, 17 Jun 2020 14:06:23 -0700 (PDT)
Date:   Wed, 17 Jun 2020 14:06:13 -0700
Message-Id: <20200617210613.95432-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] vmlinux.lds: consider .text.{hot|unlikely}.* part of .text too
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     clang-built-linux@googlegroups.com,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Jian Cai <jiancai@google.com>,
        Luis Lozano <llozano@google.com>,
        "=?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?=" <maskray@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ld.bfd's internal linker script considers .text.hot AND .text.hot.* to
be part of .text, as well as .text.unlikely and .text.unlikely.*. ld.lld
will produce .text.hot.*/.text.unlikely.* sections. Make sure to group
these together.  Otherwise these orphan sections may be placed outside
of the the _stext/_etext boundaries.

Cc: stable@vger.kernel.org
Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=3Da=
dd44f8d5c5c05e08b11e033127a744d61c26aee
Link: https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommitdiff;h=3D1=
de778ed23ce7492c523d5850c6c6dbb34152655
Link: https://reviews.llvm.org/D79600
Reported-by: Jian Cai <jiancai@google.com>
Debugged-by: Luis Lozano <llozano@google.com>
Suggested-by: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
Tested-by: Luis Lozano <llozano@google.com>
Tested-by: Manoj Gupta <manojgupta@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/asm-generic/vmlinux.lds.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index d7c7c7f36c4a..fe5aaef169e3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -560,7 +560,9 @@
  */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		*(.text.hot .text.hot.*)				\
+		*(TEXT_MAIN .text.fixup)				\
+		*(.text.unlikely .text.unlikely.*)			\
 		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
--=20
2.27.0.290.gba653c62da-goog

