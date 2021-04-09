Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43877359A8C
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhDIJ7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233804AbhDIJ6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C82356100B;
        Fri,  9 Apr 2021 09:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962283;
        bh=+lHF02eFdqqu+El0HIl+kBX03LVd1OQlFnoRE5Mg9xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sq9ZHOPhiYyYYRQWXPsPspLqqF8MhtQg9EQ9gcQtFlRRIN2qEfCaM1ZqVvdR2hk7l
         PY3Guk2Tz3a30Xv+sqH1gmL3fUvYnoxeDrbbiw0x+cWj5Fh3EzStH8R37OMSUXBuwX
         imcei5/3a9ZPXLgA9Fd8/CXWGVjwQuf6VTXfddLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KP Singh <kpsingh@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Terrell <terrelln@fb.com>,
        Quentin Perret <qperret@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 23/23] init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM
Date:   Fri,  9 Apr 2021 11:53:53 +0200
Message-Id: <20210409095303.631390808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
References: <20210409095302.894568462@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit ea29b20a828511de3348334e529a3d046a180416 upstream.

I read the commit log of the following two:

- bc083a64b6c0 ("init/Kconfig: make COMPILE_TEST depend on !UML")
- 334ef6ed06fa ("init/Kconfig: make COMPILE_TEST depend on !S390")

Both are talking about HAS_IOMEM dependency missing in many drivers.

So, 'depends on HAS_IOMEM' seems the direct, sensible solution to me.

This does not change the behavior of UML. UML still cannot enable
COMPILE_TEST because it does not provide HAS_IOMEM.

The current dependency for S390 is too strong. Under the condition of
CONFIG_PCI=y, S390 provides HAS_IOMEM, hence can enable COMPILE_TEST.

I also removed the meaningless 'default n'.

Link: https://lkml.kernel.org/r/20210224140809.1067582-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KP Singh <kpsingh@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -76,8 +76,7 @@ config INIT_ENV_ARG_LIMIT
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML && !S390
-	default n
+	depends on HAS_IOMEM
 	help
 	  Some drivers can be compiled on a different platform than they are
 	  intended to be run on. Despite they cannot be loaded there (or even


