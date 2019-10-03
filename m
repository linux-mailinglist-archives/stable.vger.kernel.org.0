Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98819CACC7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfJCR30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388100AbfJCQMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597E520865;
        Thu,  3 Oct 2019 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119163;
        bh=FB4XVy2jvCqmDjccoNIb7z5U4Sf68+Zu8TPjSSL5quA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ljPvCoHqJ/m+25ckhFZYrkAL6I5jyFPoCQEkn4jQtHdH/hiw6NwKsNTCdt6+aTqL
         JaazPO0Jmhhx5/fO6nJlRdOp3+F5yiBQLVq/gx6iBZuzfWxShH4Ir0Q7MzzTlecRa6
         oAZiIQEx0M/PMXdc5V/P5bbo0Ug6iQEB/tvneoLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, x86@kernel.org,
        clang-built-linux@googlegroups.com, Nathan Chancellor" 
        <natechancellor@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.14 149/185] x86/retpolines: Fix up backport of a9d57ef15cbe
Date:   Thu,  3 Oct 2019 17:53:47 +0200
Message-Id: <20191003154512.704851856@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Commit a9d57ef15cbe ("x86/retpolines: Disable switch jump tables when
retpolines are enabled") added -fno-jump-tables to workaround a GCC issue
while deliberately avoiding adding this flag when CONFIG_CC_IS_CLANG is
set, which is defined by the kconfig system when CC=clang is provided.

However, this symbol was added in 4.18 in commit 469cb7376c06 ("kconfig:
add CC_IS_CLANG and CLANG_VERSION") so it is always undefined in 4.14,
meaning -fno-jump-tables gets added when using Clang.

Fix this up by using the equivalent $(cc-name) comparison, which matches
what upstream did until commit 076f421da5d4 ("kbuild: replace cc-name
test with CONFIG_CC_IS_CLANG").

Fixes: e28951100515 ("x86/retpolines: Disable switch jump tables when retpolines are enabled")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -249,7 +249,7 @@ ifdef CONFIG_RETPOLINE
   # retpoline builds, however, gcc does not for x86. This has
   # only been fixed starting from gcc stable version 8.4.0 and
   # onwards, but not for older ones. See gcc bug #86952.
-  ifndef CONFIG_CC_IS_CLANG
+  ifneq ($(cc-name), clang)
     KBUILD_CFLAGS += $(call cc-option,-fno-jump-tables)
   endif
 endif


