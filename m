Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD22F767
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbfD3Lq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbfD3Lqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A512177B;
        Tue, 30 Apr 2019 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624813;
        bh=S5a57pgBbNhWtuYvTvpD2TIOjnaqE6tBXM5Uuq70EZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HeqBsFLMpohduiKYkQu+18YgGGfOJcGLKYEQWKOC8UKMtaNc6U0kWWu8Yn/RJK/9Z
         Q2fREE6mpP0jft1L9cZ+P0KcqjEHUCgFWgDtVAvABCQjHICU/ErVjsGZOPq1dcI9Wj
         1xbnR0mTT/DLbEKx6Tf5RIh6qQ0ZlxW47Gnc2yR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 081/100] x86/retpolines: Disable switch jump tables when retpolines are enabled
Date:   Tue, 30 Apr 2019 13:38:50 +0200
Message-Id: <20190430113612.580015455@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a9d57ef15cbe327fe54416dd194ee0ea66ae53a4 upstream.

Commit ce02ef06fcf7 ("x86, retpolines: Raise limit for generating indirect
calls from switch-case") raised the limit under retpolines to 20 switch
cases where gcc would only then start to emit jump tables, and therefore
effectively disabling the emission of slow indirect calls in this area.

After this has been brought to attention to gcc folks [0], Martin Liska
has then fixed gcc to align with clang by avoiding to generate switch jump
tables entirely under retpolines. This is taking effect in gcc starting
from stable version 8.4.0. Given kernel supports compilation with older
versions of gcc where the fix is not being available or backported anymore,
we need to keep the extra KBUILD_CFLAGS around for some time and generally
set the -fno-jump-tables to align with what more recent gcc is doing
automatically today.

More than 20 switch cases are not expected to be fast-path critical, but
it would still be good to align with gcc behavior for versions < 8.4.0 in
order to have consistency across supported gcc versions. vmlinux size is
slightly growing by 0.27% for older gcc. This flag is only set to work
around affected gcc, no change for clang.

  [0] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=86952

Suggested-by: Martin Liska <mliska@suse.cz>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Björn Töpel<bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lkml.kernel.org/r/20190325135620.14882-1-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -227,8 +227,12 @@ ifdef CONFIG_RETPOLINE
   # Additionally, avoid generating expensive indirect jumps which
   # are subject to retpolines for small number of switch cases.
   # clang turns off jump table generation by default when under
-  # retpoline builds, however, gcc does not for x86.
-  KBUILD_CFLAGS += $(call cc-option,--param=case-values-threshold=20)
+  # retpoline builds, however, gcc does not for x86. This has
+  # only been fixed starting from gcc stable version 8.4.0 and
+  # onwards, but not for older ones. See gcc bug #86952.
+  ifndef CONFIG_CC_IS_CLANG
+    KBUILD_CFLAGS += $(call cc-option,-fno-jump-tables)
+  endif
 endif
 
 archscripts: scripts_basic


