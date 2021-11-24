Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D5D45C126
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347035AbhKXNPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346035AbhKXNLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E20F61A80;
        Wed, 24 Nov 2021 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757715;
        bh=tnqyqeyXW3Bwsd24Il137clZkPiw8fFv9CZzmxu8VcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzp0r9mjUI6jFr1Cz9KMs5a4OSnsqEd8EmZHzNvp2GsjIIc7v+kBCxfFaOEvK/V8x
         /S80gytFvFPoD3U91XNZHzXV9v1mKZgLEnGh3dD9E0F0z/5w0HADNNpdZtdPQcsglM
         eCqL0MNpsyRSrA8Ijbfxd1c2kXPnuvvp2AOwxoew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19 252/323] fortify: Explicitly disable Clang support
Date:   Wed, 24 Nov 2021 12:57:22 +0100
Message-Id: <20211124115727.406344540@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
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


