Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931453599F7
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhDIJzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:55:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233043AbhDIJzF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E755361182;
        Fri,  9 Apr 2021 09:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962087;
        bh=r+em3lp58j5sL5Sag0dbfT13hKuA67iS9h1Kl0XKhXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeosdHhYANjuFMPDxx8uyeB4iP7HyReRPYlhbLtZRNbpdg0UWinUKM5vkChJMWG3D
         ozDnYQ+1ggzpezgK5M3LT/eLHRl3iehcKOvNSQ8lVNTSmsy6cCnGvHmLe/c75DU+xn
         o3g4NWL/rZOuAOAZ6akJ3n/xJhz5eMvqmDTLLqhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 18/20] init/Kconfig: make COMPILE_TEST depend on !UML
Date:   Fri,  9 Apr 2021 11:53:24 +0200
Message-Id: <20210409095300.531289850@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
References: <20210409095259.957388690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit bc083a64b6c035135c0f80718f9e9192cc0867c6 upstream.

UML is a bit special since it does not have iomem nor dma.  That means a
lot of drivers will not build if they miss a dependency on HAS_IOMEM.
s390 used to have the same issues but since it gained PCI support UML is
the only stranger.

We are tired of patching dozens of new drivers after every merge window
just to un-break allmod/yesconfig UML builds.  One could argue that a
decent driver has to know on what it depends and therefore a missing
HAS_IOMEM dependency is a clear driver bug.  But the dependency not
obvious and not everyone does UML builds with COMPILE_TEST enabled when
developing a device driver.

A possible solution to make these builds succeed on UML would be
providing stub functions for ioremap() and friends which fail upon
runtime.  Another one is simply disabling COMPILE_TEST for UML.  Since
it is the least hassle and does not force use to fake iomem support
let's do the latter.

Link: http://lkml.kernel.org/r/1466152995-28367-1-git-send-email-richard@nod.at
Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -65,6 +65,7 @@ config CROSS_COMPILE
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
+	depends on !UML
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are


