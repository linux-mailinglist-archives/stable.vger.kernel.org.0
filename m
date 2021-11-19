Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9E9457594
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhKSRlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236575AbhKSRlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C4261A3A;
        Fri, 19 Nov 2021 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343479;
        bh=tnqyqeyXW3Bwsd24Il137clZkPiw8fFv9CZzmxu8VcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlbSjM1oOvGCep3OplatJOguzSO6pe+aR+AMwk0cbCWPdcxsbCywTXY+jKx+Jq441
         cGW41M8s4YC3CRBaWf/vR1scNanMS3vNizAKMojYLsnNZDkzW0+rDIuxH4Thzukvb5
         pR6DYneqJ/OVacYOGA9agaH7HS0t31golyukgEl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 01/21] fortify: Explicitly disable Clang support
Date:   Fri, 19 Nov 2021 18:37:36 +0100
Message-Id: <20211119171443.942886211@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit a52f8a59aef46b59753e583bf4b28fccb069ce64 upstream.

Clang has never correctly compiled the FORTIFY_SOURCE defenses due to
a couple bugs:

	Eliding inlines with matching __builtin_* names
	https://bugs.llvm.org/show_bug.cgi?id=50322

	Incorrect __builtin_constant_p() of some globals
	https://bugs.llvm.org/show_bug.cgi?id=41459

In the process of making improvements to the FORTIFY_SOURCE defenses, the
first (silent) bug (coincidentally) becomes worked around, but exposes
the latter which breaks the build. As such, Clang must not be used with
CONFIG_FORTIFY_SOURCE until at least latter bug is fixed (in Clang 13),
and the fortify routines have been rearranged.

Update the Kconfig to reflect the reality of the current situation.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/lkml/CAKwvOd=A+ueGV2ihdy5GtgR2fQbcXjjAtVxv3=cPjffpebZB7A@mail.gmail.com
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/Kconfig
+++ b/security/Kconfig
@@ -191,6 +191,9 @@ config HARDENED_USERCOPY_PAGESPAN
 config FORTIFY_SOURCE
 	bool "Harden common str/mem functions against buffer overflows"
 	depends on ARCH_HAS_FORTIFY_SOURCE
+	# https://bugs.llvm.org/show_bug.cgi?id=50322
+	# https://bugs.llvm.org/show_bug.cgi?id=41459
+	depends on !CC_IS_CLANG
 	help
 	  Detect overflows of buffers in common string and memory functions
 	  where the compiler can determine and validate the buffer sizes.


