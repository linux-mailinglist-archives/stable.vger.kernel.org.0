Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404FA451EB9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344608AbhKPAhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344911AbhKOTZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25D3636EF;
        Mon, 15 Nov 2021 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003210;
        bh=xkNXZnfRkDHImgWeZ+JwqpqBj6sFaI/DIYiZhQFDFgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whZO8vWqI5FzVaJNauu5WqBEiMXrAQr9nRKsJtCxdzuTxHIX7f66We970WTK2WNEv
         cHZOBBHheSB04iKIftuiw7kZzvbNqdv48pBbHEOXsxHrInOAvLFilFIgf4kSxhPX8P
         VxJi8oXo8pzbAKhCfiEbfJLjKKqowKkkxE62kcCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Self <jason@bluehome.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 852/917] MIPS: fix *-pkg builds for loongson2ef platform
Date:   Mon, 15 Nov 2021 18:05:47 +0100
Message-Id: <20211115165457.921703551@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 0706f74f719e6e72c3a862ab2990796578fa73cc upstream.

Since commit 805b2e1d427a ("kbuild: include Makefile.compiler only when
compiler is needed"), package builds for the loongson2f platform fail.

  $ make ARCH=mips CROSS_COMPILE=mips64-linux- lemote2f_defconfig bindeb-pkg
    [ snip ]
  sh ./scripts/package/builddeb
  arch/mips/loongson2ef//Platform:36: *** only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.  Stop.
  cp: cannot stat '': No such file or directory
  make[5]: *** [scripts/Makefile.package:87: intdeb-pkg] Error 1
  make[4]: *** [Makefile:1558: intdeb-pkg] Error 2
  make[3]: *** [debian/rules:13: binary-arch] Error 2
  dpkg-buildpackage: error: debian/rules binary subprocess returned exit status 2
  make[2]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
  make[1]: *** [Makefile:1558: bindeb-pkg] Error 2
  make: *** [Makefile:350: __build_one_by_one] Error 2

The reason is because "make image_name" fails.

  $ make ARCH=mips CROSS_COMPILE=mips64-linux- image_name
  arch/mips/loongson2ef//Platform:36: *** only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.  Stop.

In general, adding $(error ...) in the parse stage is troublesome,
and it is pointless to check toolchains even if we are not building
anything. Do not include Kbuild.platform in such cases.

Fixes: 805b2e1d427a ("kbuild: include Makefile.compiler only when compiler is needed")
Reported-by: Jason Self <jason@bluehome.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -254,7 +254,9 @@ endif
 #
 # Board-dependent options and extra files
 #
+ifdef need-compiler
 include $(srctree)/arch/mips/Kbuild.platforms
+endif
 
 ifdef CONFIG_PHYSICAL_START
 load-y					= $(CONFIG_PHYSICAL_START)


