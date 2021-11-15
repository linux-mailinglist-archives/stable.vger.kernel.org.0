Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7388450493
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKOMnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhKOMm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:42:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6BA60FC2;
        Mon, 15 Nov 2021 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636980003;
        bh=Gh9k+N8CYjC+EmXEH95lceHOaQi1FaH0qDouS8XQzeE=;
        h=Subject:To:Cc:From:Date:From;
        b=C3kDWEjW2rZFTxm9H0F1dsfahTiRo+NETAx4TyK+Br22dROoyILEB/0d5CSmlH8UW
         +V9ztzoDTKAEt1RZ+R4oFdryvhktgKCAJb14yAz8aMgBnZh5QX7KYA6gjPGiEir3rk
         nfoAFyQwS470CQ/wTJcXoIS4EIlsoC8obUdId+9s=
Subject: FAILED: patch "[PATCH] MIPS: fix *-pkg builds for loongson2ef platform" failed to apply to 5.14-stable tree
To:     masahiroy@kernel.org, jason@bluehome.net, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 13:39:56 +0100
Message-ID: <163697999651153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0706f74f719e6e72c3a862ab2990796578fa73cc Mon Sep 17 00:00:00 2001
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 10 Nov 2021 00:01:45 +0900
Subject: [PATCH] MIPS: fix *-pkg builds for loongson2ef platform

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

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index ea3cd080a1c7..f7b58da2f388 100644
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

