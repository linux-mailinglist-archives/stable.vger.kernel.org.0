Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD97452810
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379266AbhKPCyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:54:08 -0500
Received: from condef-02.nifty.com ([202.248.20.67]:51737 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379030AbhKPCv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 21:51:58 -0500
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-02.nifty.com with ESMTP id 1AG2Xox8025398
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:33:50 +0900
Received: from grover.. (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id 1AG2X8RI017055;
        Tue, 16 Nov 2021 11:33:09 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 1AG2X8RI017055
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1637029989;
        bh=wbHvChGqxHcvQLSOIL54mFOcZVf7VxLbblZeMjyNgrA=;
        h=From:To:Cc:Subject:Date:From;
        b=OADpqclAk38tK/ubfuSHGqU0UHtvW0H7ZIeitogQN27uI0JN2JLL/53p86tm2NWvX
         v/4pUsoJWANDzBmC2PLHeeTLv5PlMG3vFdmR9kUe6we5298VndXMI+crVQjhajgNLX
         Yk/IW6TjLfW0UwENSdvW/PzhEdVi083BiDbWNkyjufkOs5MH7ocZsSYVmRZw9c4jVt
         jRE8fTT7Sfs8yIutI3QfwKdnEgBleekUZGwM70rf6bxEW9WBs2UwedURBBYLVT7SGP
         hNtXw31YRFOIIIXLxXzHt+86X0uH/ZW350qewGRcOOadBheli2AVlu6wUFWJPnf6IW
         WzsnuT9U+/RGg==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     jason@bluehome.net, tsbogend@alpha.franken.de,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH stable 5.14.y] MIPS: fix *-pkg builds for loongson2ef platform
Date:   Tue, 16 Nov 2021 11:33:04 +0900
Message-Id: <20211116023304.976034-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

 arch/mips/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 653befc1b176..0dfef0beaaaa 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -254,7 +254,9 @@ endif
 #
 # Board-dependent options and extra files
 #
+ifdef need-compiler
 include arch/mips/Kbuild.platforms
+endif
 
 ifdef CONFIG_PHYSICAL_START
 load-y					= $(CONFIG_PHYSICAL_START)
-- 
2.30.2

