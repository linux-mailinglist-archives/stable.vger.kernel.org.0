Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE466259416
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgIAPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbgIAPfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC1E205F4;
        Tue,  1 Sep 2020 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974529;
        bh=ukc1VTBXHuV1vIGsW9+ts5BRgWWZ/dWaSHlEnAGo6ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKXrBePnDMRTGJ+2xOPqQaQPjP5MvEMm+kGLv9V53pXfror8nn4otBqLVbzXd0+zS
         XlysnozBv2Rta2sri8deq6+0TLWJRpInJcRMMgtaSM0MZWa7Qnif58IzicGxIvloqw
         kAeNgbjdxjRrtsFl6JM8iAMPYLabQxPiEhXxGDHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.4 211/214] kbuild: fix broken builds because of GZIP,BZIP2,LZOP variables
Date:   Tue,  1 Sep 2020 17:11:31 +0200
Message-Id: <20200901151003.033890779@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit e4a42c82e943b97ce124539fcd7a47445b43fa0d upstream.

Redefine GZIP, BZIP2, LZOP variables as KGZIP, KBZIP2, KLZOP resp.
GZIP, BZIP2, LZOP env variables are reserved by the tools. The original
attempt to redefine them internally doesn't work in makefiles/scripts
intercall scenarios, e.g., "make GZIP=gzip bindeb-pkg" and results in
broken builds. There can be other broken build commands because of this,
so the universal solution is to use non-reserved env variables for the
compression tools.

Fixes: 8dfb61dcbace ("kbuild: add variables for compression tools")
Signed-off-by: Denis Efremov <efremov@linux.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile                          |   24 +++++-------------------
 arch/arm/boot/deflate_xip_data.sh |    2 +-
 arch/ia64/Makefile                |    2 +-
 arch/m68k/Makefile                |    8 ++++----
 arch/parisc/Makefile              |    2 +-
 scripts/Makefile.lib              |    6 +++---
 scripts/Makefile.package          |    6 +++---
 scripts/package/buildtar          |    4 ++--
 8 files changed, 20 insertions(+), 34 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -442,27 +442,13 @@ PYTHON		= python
 PYTHON3		= python3
 CHECK		= sparse
 BASH		= bash
-GZIP		= gzip
-BZIP2		= bzip2
-LZOP		= lzop
+KGZIP		= gzip
+KBZIP2		= bzip2
+KLZOP		= lzop
 LZMA		= lzma
 LZ4		= lz4c
 XZ		= xz
 
-# GZIP, BZIP2, LZOP env vars are used by the tools. Support them as the command
-# line interface, but use _GZIP, _BZIP2, _LZOP internally.
-_GZIP          := $(GZIP)
-_BZIP2         := $(BZIP2)
-_LZOP          := $(LZOP)
-
-# Reset GZIP, BZIP2, LZOP in this Makefile
-override GZIP=
-override BZIP2=
-override LZOP=
-
-# Reset GZIP, BZIP2, LZOP in recursive invocations
-MAKEOVERRIDES += GZIP= BZIP2= LZOP=
-
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
 NOSTDINC_FLAGS :=
@@ -510,7 +496,7 @@ CLANG_FLAGS :=
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP OBJSIZE READELF PAHOLE LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
-export _GZIP _BZIP2 _LZOP LZMA LZ4 XZ
+export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ
 export KBUILD_HOSTCXXFLAGS KBUILD_HOSTLDFLAGS KBUILD_HOSTLDLIBS LDFLAGS_MODULE
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS
@@ -1018,7 +1004,7 @@ export mod_strip_cmd
 mod_compress_cmd = true
 ifdef CONFIG_MODULE_COMPRESS
   ifdef CONFIG_MODULE_COMPRESS_GZIP
-    mod_compress_cmd = $(_GZIP) -n -f
+    mod_compress_cmd = $(KGZIP) -n -f
   endif # CONFIG_MODULE_COMPRESS_GZIP
   ifdef CONFIG_MODULE_COMPRESS_XZ
     mod_compress_cmd = $(XZ) -f
--- a/arch/arm/boot/deflate_xip_data.sh
+++ b/arch/arm/boot/deflate_xip_data.sh
@@ -56,7 +56,7 @@ trap 'rm -f "$XIPIMAGE.tmp"; exit 1' 1 2
 # substitute the data section by a compressed version
 $DD if="$XIPIMAGE" count=$data_start iflag=count_bytes of="$XIPIMAGE.tmp"
 $DD if="$XIPIMAGE"  skip=$data_start iflag=skip_bytes |
-$_GZIP -9 >> "$XIPIMAGE.tmp"
+$KGZIP -9 >> "$XIPIMAGE.tmp"
 
 # replace kernel binary
 mv -f "$XIPIMAGE.tmp" "$XIPIMAGE"
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -40,7 +40,7 @@ $(error Sorry, you need a newer version
 endif
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
+cmd_gzip = cat $(real-prereqs) | $(KGZIP) -n -f -9 > $@
 
 quiet_cmd_objcopy = OBJCOPY $@
 cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
--- a/arch/m68k/Makefile
+++ b/arch/m68k/Makefile
@@ -135,10 +135,10 @@ vmlinux.gz: vmlinux
 ifndef CONFIG_KGDB
 	cp vmlinux vmlinux.tmp
 	$(STRIP) vmlinux.tmp
-	$(_GZIP) -9c vmlinux.tmp >vmlinux.gz
+	$(KGZIP) -9c vmlinux.tmp >vmlinux.gz
 	rm vmlinux.tmp
 else
-	$(_GZIP) -9c vmlinux >vmlinux.gz
+	$(KGZIP) -9c vmlinux >vmlinux.gz
 endif
 
 bzImage: vmlinux.bz2
@@ -148,10 +148,10 @@ vmlinux.bz2: vmlinux
 ifndef CONFIG_KGDB
 	cp vmlinux vmlinux.tmp
 	$(STRIP) vmlinux.tmp
-	$(_BZIP2) -1c vmlinux.tmp >vmlinux.bz2
+	$(KBZIP2) -1c vmlinux.tmp >vmlinux.bz2
 	rm vmlinux.tmp
 else
-	$(_BZIP2) -1c vmlinux >vmlinux.bz2
+	$(KBZIP2) -1c vmlinux >vmlinux.bz2
 endif
 
 archclean:
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -156,7 +156,7 @@ vmlinuz: bzImage
 	$(OBJCOPY) $(boot)/bzImage $@
 else
 vmlinuz: vmlinux
-	@$(_GZIP) -cf -9 $< > $@
+	@$(KGZIP) -cf -9 $< > $@
 endif
 
 install:
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -230,7 +230,7 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS)
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-      cmd_gzip = cat $(real-prereqs) | $(_GZIP) -n -f -9 > $@
+      cmd_gzip = cat $(real-prereqs) | $(KGZIP) -n -f -9 > $@
 
 # DTC
 # ---------------------------------------------------------------------------
@@ -322,7 +322,7 @@ printf "%08x\n" $$dec_size |						\
 )
 
 quiet_cmd_bzip2 = BZIP2   $@
-      cmd_bzip2 = { cat $(real-prereqs) | $(_BZIP2) -9; $(size_append); } > $@
+      cmd_bzip2 = { cat $(real-prereqs) | $(KBZIP2) -9; $(size_append); } > $@
 
 # Lzma
 # ---------------------------------------------------------------------------
@@ -331,7 +331,7 @@ quiet_cmd_lzma = LZMA    $@
       cmd_lzma = { cat $(real-prereqs) | $(LZMA) -9; $(size_append); } > $@
 
 quiet_cmd_lzo = LZO     $@
-      cmd_lzo = { cat $(real-prereqs) | $(_LZOP) -9; $(size_append); } > $@
+      cmd_lzo = { cat $(real-prereqs) | $(KLZOP) -9; $(size_append); } > $@
 
 quiet_cmd_lz4 = LZ4     $@
       cmd_lz4 = { cat $(real-prereqs) | $(LZ4) -l -c1 stdin stdout; \
--- a/scripts/Makefile.package
+++ b/scripts/Makefile.package
@@ -45,7 +45,7 @@ if test "$(objtree)" != "$(srctree)"; th
 	false; \
 fi ; \
 $(srctree)/scripts/setlocalversion --save-scmversion; \
-tar -I $(_GZIP) -c $(RCS_TAR_IGNORE) -f $(2).tar.gz \
+tar -I $(KGZIP) -c $(RCS_TAR_IGNORE) -f $(2).tar.gz \
 	--transform 's:^:$(2)/:S' $(TAR_CONTENT) $(3); \
 rm -f $(objtree)/.scmversion
 
@@ -127,8 +127,8 @@ util/PERF-VERSION-GEN $(CURDIR)/$(perf-t
 tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
-$(if $(findstring bz2,$@),$(_BZIP2),                                 \
-$(if $(findstring gz,$@),$(_GZIP),                                  \
+$(if $(findstring bz2,$@),$(KBZIP2),                                 \
+$(if $(findstring gz,$@),$(KGZIP),                                  \
 $(if $(findstring xz,$@),$(XZ),                                     \
 $(error unknown target $@))))                                       \
 	-f -9 $(perf-tar).tar)
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -28,11 +28,11 @@ case "${1}" in
 		opts=
 		;;
 	targz-pkg)
-		opts="-I ${_GZIP}"
+		opts="-I ${KGZIP}"
 		tarball=${tarball}.gz
 		;;
 	tarbz2-pkg)
-		opts="-I ${_BZIP2}"
+		opts="-I ${KBZIP2}"
 		tarball=${tarball}.bz2
 		;;
 	tarxz-pkg)


