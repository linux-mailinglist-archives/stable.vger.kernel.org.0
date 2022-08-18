Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E573459829A
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiHRLzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244387AbiHRLzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:55:01 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1876B85FC9;
        Thu, 18 Aug 2022 04:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660823697; x=1692359697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S6Fzv4o9sIgKI0zY5fL+w7RumdIJ61orDTr8icR3RAM=;
  b=XNQVjD5kLXxp1ubRbZ/WMyig9qGLuJWb/W3qDX/uOLmAj8V4tEHS9Von
   E9xBGDmntupariaH4Vk3YIK5tmOuNSNscguMXR4/yUbkrcb5TGETnOaKx
   uh8arVhYU+KebW3rYkc9VYhXbtZ74dkZnM9x5FjbHuDcRGb8vePFlkEBZ
   lheUVuuv2VRcYfqcSnxRFqSTtos7tYCCz9yKQa0oWnaP3v71eUphBj5/F
   iwKPu+PfndEVIXwECH6++3rkwWN40ut70Vv+9/AQbqXO4G2YEb+BftpKP
   +wg5L17K4pdXJBGQaVq2z1QQEYqLERi/UsdxgjAz3oSYzWzB6El5fv3bN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="279703588"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="279703588"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="783756716"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 18 Aug 2022 04:54:52 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IBsmfu013911;
        Thu, 18 Aug 2022 12:54:51 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [RFC PATCH 3/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Thu, 18 Aug 2022 13:53:06 +0200
Message-Id: <20220818115306.1109642-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, kallsyms kernel code copes with symbols with the same
name by indexing them according to their position in vmlinux and
requiring to provide an index of the desired symbol. This is not
really quite reliable and is fragile to any features performing
symbol or section manipulations such as FG-KASLR.
So, in order to make kallsyms immune to object code modification
and independent of symbol positions and indexing, make them really
unique by including the file path corresponding to the symbol in
its kallsym. The paths are relative to $(srctree) to keep build
reproducible, so that looks like:

dev_gro_receive -> net/core/gro.c:dev_gro_receive

This is achieved by introducing two new utilities which will run
during the build process:

* 'sympath' - C utility that is being run on each created object
   file. It replaces STT_FILE symbol name in strtab to a given
   string, in our case target relative file path.
* 'gen_sympaths.pl' - Perl script which saves a list of symbols per
  each 'built-in.a' and then collects them back during the kallsyms
  step.

The first one is needed for local symbols. Compilers usually place
a special STT_FILE symbol in each object file and leave a source
file name there. It can be later obtained via 'nm vmlinux' or any
other symbol dumping utility for each local symbol, but just a file
name is not enough, as there's a pack of functions with the same
name placed in the files with the same name. OTOH, path such as
'net/core/dev.c' is unique across the tree.
The second one performs the main paths processing and is being
called on kallsyms generating step instead of 'nm'. Additionally,
it maintains a symbol list per each AR thin archive, so that it's
then possible to get file paths for global symbols, as globals are
being placed by compilers after locals and there's no way to get
the corresponding STT_FILE symbol for a global symbol. So it makes
use of that global symbols have unique names across the whole object
and just does a simple lookup in a previously generated list.
One list per each AR archive is needed to parallelize the process.

This feature is hidden behind CONFIG_KALLSYMS_PATHS and is off by
default. It costs about 3 seconds of total build time and about
1-2% of vmlinux size. 'kallsyms' and 'modpost' are taught to be able
to parse new format correctly.
With this option enabled, kallsyms are now unique in 100% cases and
the filepaths are correct in 100% cases too. To be double-sure, the
script performs searching for duplicates and fails the build if any
is found. So it makes it possible for kallsyms code to not rely on
any indexes/positions anymore.

Note: 'sympath' is placed into scripts/mod as it depends on
auto-generated scripts/mod/elfconfig.h (needs to know target bitness
and Endianness).

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 .gitignore                |   1 +
 Makefile                  |   2 +-
 init/Kconfig              |  26 ++-
 scripts/Makefile.build    |   7 +-
 scripts/Makefile.lib      |  10 +-
 scripts/Makefile.modfinal |   3 +-
 scripts/gen_sympaths.pl   | 270 ++++++++++++++++++++++++++
 scripts/kallsyms.c        |  87 +++++++--
 scripts/link-vmlinux.sh   |  14 +-
 scripts/mod/.gitignore    |   1 +
 scripts/mod/Makefile      |   9 +
 scripts/mod/sympath.c     | 385 ++++++++++++++++++++++++++++++++++++++
 12 files changed, 788 insertions(+), 27 deletions(-)
 create mode 100755 scripts/gen_sympaths.pl
 create mode 100644 scripts/mod/sympath.c

diff --git a/.gitignore b/.gitignore
index 265959544978..7e01f95de7df 100644
--- a/.gitignore
+++ b/.gitignore
@@ -41,6 +41,7 @@
 *.so
 *.so.dbg
 *.su
+*.syms
 *.symtypes
 *.symversions
 *.tab.[ch]
diff --git a/Makefile b/Makefile
index f09673b6c11d..819ab3b355da 100644
--- a/Makefile
+++ b/Makefile
@@ -1867,7 +1867,7 @@ clean: $(clean-dirs)
 		\( -name '*.[aios]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '*.ko.*' \
 		-o -name '*.dtb' -o -name '*.dtbo' -o -name '*.dtb.S' -o -name '*.dt.yaml' \
-		-o -name '*.dwo' -o -name '*.lst' \
+		-o -name '*.dwo' -o -name '*.lst' -o -name '*.syms' \
 		-o -name '*.su' -o -name '*.mod' -o -name '*.usyms' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.lex.c' -o -name '*.tab.[ch]' \
diff --git a/init/Kconfig b/init/Kconfig
index 80fe60fa77fb..27c8036e6d4f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1720,9 +1720,11 @@ config KALLSYMS
 	  symbolic stack backtraces. This increases the size of the kernel
 	  somewhat, as all symbols have to be loaded into the kernel image.
 
+if KALLSYMS
+
 config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
-	depends on DEBUG_KERNEL && KALLSYMS
+	depends on DEBUG_KERNEL
 	help
 	  Normally kallsyms only contains the symbols of functions for nicer
 	  OOPS messages and backtraces (i.e., symbols from the text and inittext
@@ -1740,12 +1742,10 @@ config KALLSYMS_ALL
 
 config KALLSYMS_ABSOLUTE_PERCPU
 	bool
-	depends on KALLSYMS
 	default X86_64 && SMP
 
 config KALLSYMS_BASE_RELATIVE
 	bool
-	depends on KALLSYMS
 	default !IA64
 	help
 	  Instead of emitting them as absolute values in the native word size,
@@ -1761,6 +1761,26 @@ config KALLSYMS_BASE_RELATIVE
 	  time constants, and no relocation pass is required at runtime to fix
 	  up the entries based on the runtime load address of the kernel.
 
+config KALLSYMS_PATHS
+	bool "Include relative source file paths into kallsyms"
+	depends on KALLSYMS
+	depends on MODULES_USE_ELF_RELA # RFC: no rel support in sympath util
+	help
+	  This option makes kallsyms contain not only symbol name, but also
+	  its source file path relative to the kernel root. I.e.
+
+	  dev_gro_receive -> net/core/gro.c:dev_gro_receive
+
+	  Apart from giving more useful debugging info, this makes kallsyms
+	  values unique, and thus subsystems relying on kallsyms lookup
+	  (livepatch, probes) more reliable (due to not having to differ
+	  symbols with the same name by their positions in vmlinux).
+	  Enabling it makes kallsyms size ~1.5 times bigger, which means
+	  slightly bigger kernel size, with no noticeable impact on total
+	  compilation time.
+
+endif # KALLSYMS
+
 # end of the "standard kernel features (expert users)" menu
 
 # syscall, maps, verifier
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 784f46d41959..576b4b48246a 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -159,7 +159,8 @@ endif
 quiet_cmd_cc_o_c = CC $(quiet_modtag)  $@
       cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $< \
 		$(cmd_ld_single_m) \
-		$(cmd_objtool)
+		$(cmd_objtool) \
+		$(cmd_sympath)
 
 ifdef CONFIG_MODVERSIONS
 # When module versioning is enabled the following steps are executed:
@@ -307,7 +308,7 @@ $(obj)/%.s: $(src)/%.S FORCE
 	$(call if_changed_dep,cpp_s_S)
 
 quiet_cmd_as_o_S = AS $(quiet_modtag)  $@
-      cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $< $(cmd_objtool)
+      cmd_as_o_S = $(CC) $(a_flags) -c -o $@ $< $(cmd_objtool) $(cmd_sympath)
 
 ifdef CONFIG_ASM_MODVERSIONS
 
@@ -359,7 +360,7 @@ $(subdir-modorder): $(obj)/%/modules.order: $(obj)/% ;
 quiet_cmd_ar_builtin = AR      $@
       cmd_ar_builtin = rm -f $@; \
 	$(if $(real-prereqs), printf "$(obj)/%s " $(patsubst $(obj)/%,%,$(real-prereqs)) | xargs) \
-	$(AR) cDPrST $@
+	$(AR) cDPrST $@ $(cmd_symlist)
 
 $(obj)/built-in.a: $(real-obj-y) FORCE
 	$(call if_changed,ar_builtin)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3fb6a99e78c4..fc2ce44e8d34 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -252,6 +252,14 @@ cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(o
 
 endif # CONFIG_OBJTOOL
 
+ifdef CONFIG_KALLSYMS_PATHS
+cmd_sympath = $(if $(skip-sympath),, ; $(objtree)/scripts/mod/sympath -p "$<" $@)
+
+cmd_symlist =  ; \
+	$(if $(real-prereqs), printf "$(obj)/%s " $(patsubst $(obj)/%,%,$(real-prereqs)) | xargs) \
+	$(PERL) $(srctree)/scripts/gen_sympaths.pl gen > $(@:%.a=%.syms)
+endif # CONFIG_KALLSYMS_PATHS
+
 # Useful for describing the dependency of composite objects
 # Usage:
 #   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
@@ -293,7 +301,7 @@ quiet_cmd_ld = LD      $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_ar = AR      $@
-      cmd_ar = rm -f $@; $(AR) cDPrsT $@ $(real-prereqs)
+      cmd_ar = rm -f $@; $(AR) cDPrsT $@ $(real-prereqs) $(cmd_symlist)
 
 # Objcopy
 # ---------------------------------------------------------------------------
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 35100e981f4a..4aab6e90e0e5 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -23,7 +23,8 @@ modname = $(notdir $(@:.mod.o=))
 part-of-module = y
 
 quiet_cmd_cc_o_c = CC [M]  $@
-      cmd_cc_o_c = $(CC) $(filter-out $(CC_FLAGS_CFI), $(c_flags)) -c -o $@ $<
+      cmd_cc_o_c = $(CC) $(filter-out $(CC_FLAGS_CFI), $(c_flags)) -c -o $@ $< \
+		$(cmd_sympath)
 
 %.mod.o: %.mod.c FORCE
 	$(call if_changed_dep,cc_o_c)
diff --git a/scripts/gen_sympaths.pl b/scripts/gen_sympaths.pl
new file mode 100755
index 000000000000..7a63b0c03bcd
--- /dev/null
+++ b/scripts/gen_sympaths.pl
@@ -0,0 +1,270 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# The script generates a list of symbols per each AR thin archive and then
+# collects them back during the final linking to obtain symbol filepaths.
+# For local symbols, STT_FILE symbols are being used.
+#
+
+use strict;
+use warnings;
+
+my $symlist = {};
+my $fh;
+
+sub put_list
+{
+	my $name = $_[0];
+	my $path = $_[1];
+	my $type = $_[2];
+	my $elem;
+	my @arr;
+
+	$elem = $symlist->{$name};
+
+	if (!defined($elem)) {
+		$arr[0] = $path;
+
+		$symlist->{$name} = {
+			'arr'	=> \@arr,
+			'count'	=> 1,
+		};
+
+		$elem = $symlist->{$name};
+	} else {
+		$elem->{'arr'}->[$elem->{'count'}++] = $path;
+	}
+
+	if ($type =~ /^[[:lower:]]$/) {
+		return;
+	}
+
+	if (!defined($elem->{'type'}) ||
+	    ($elem->{'type'} eq "V" && !($type eq "V")) ||
+	    ($elem->{'type'} eq "W" && !($type eq "V") && !($type eq "W"))) {
+		$elem->{'type'} = $type;
+		$elem->{'widx'} = $elem->{'count'} - 1;
+	}
+}
+
+sub process_obj
+{
+	my $final = $_[1];
+	my $start = 0;
+	my $path;
+
+	open(my $fh, "\"$ENV{NM}\" -ap \"$_[0]\" 2>/dev/null |")
+		or die "Failed to execute \"$ENV{NM}\" -ap \"$_[0]\": $!";
+
+	while (<$fh>) {
+		my $type;
+		my $name;
+
+		($type, $name) = $_ =~ /^[0-9a-fA-F\s]+\s(.)\s(\S+)\n$/;
+
+		if (!defined($type) || !defined($name)) {
+			next;
+		}
+
+		if (!$start && $type eq "a") {
+			$start = 1;
+		}
+
+		if (!$start || substr($name, 0, 3) eq ".LC") {
+			next;
+		}
+
+		if ($type eq "a" && rindex($name, ".") > 0) {
+			if ($final) {
+				$path = $name;
+			} else {
+				print "F $name\n";
+			}
+
+			next;
+		}
+
+		if ($type eq "U" || $type eq "u") {
+			next;
+		}
+
+		if ($final) {
+			put_list($name, $path, $type);
+		} else {
+			print "$type $name\n";
+		}
+	}
+
+	close($fh);
+}
+
+sub drop_list
+{
+	my $name = $_[0];
+	my $path = $_[1];
+	my $elem;
+
+	$elem = $symlist->{$name};
+
+	if (!defined($elem)) {
+		return;
+	}
+
+	my ($index) = grep { $elem->{'arr'}->[$_] eq $path }
+		      0 .. $elem->{'count'} - 1;
+
+	if (defined($index)) {
+		if ($elem->{'count'} == 1) {
+			delete($symlist->{$name});
+		} else {
+			splice(@{$elem->{'arr'}}, $index, 1);
+			$elem->{'count'}--;
+
+			if (defined($elem->{'widx'}) &&
+			    $elem->{'widx'} > $index) {
+				$elem->{'widx'}--;
+			}
+		}
+	}
+}
+
+sub get_list
+{
+	my $elem;
+
+	$elem = $symlist->{$_[0]};
+
+	if (!defined($elem)) {
+		return undef;
+	}
+
+	if ($elem->{'count'} == 1) {
+		return $elem->{'arr'}->[0];
+	}
+
+	if (!defined($elem->{'type'})) {
+		return undef;
+	}
+
+	return $elem->{'arr'}->[$elem->{'widx'}];
+}
+
+sub gen_sym_file
+{
+	for my $i (1 .. $#ARGV) {
+		my $file = $ARGV[$i];
+
+		if ($file =~ /^.*\.a$/) {
+			$file =~ s/.$/syms/;
+
+			open $fh, "$file" or die "Failed to open $file: $!";
+			print <$fh>;
+			close $fh;
+		} else {
+			process_obj($file, 0);
+		}
+	}
+}
+
+if ($ARGV[0] eq "gen") {
+	gen_sym_file();
+	exit;
+}
+
+for my $i (1 .. $#ARGV) {
+	my $file = $ARGV[$i];
+
+	if ($file =~ /^.*\.a$/) {
+		my $path;
+
+		$file =~ s/.$/syms/;
+
+		open $fh, "$file" or die "Failed to open $file: $!";
+
+		while (<$fh>) {
+			my $type;
+			my $name;
+
+			($type, $name) = $_ =~ /^(.) (.+)\n$/;
+
+			if ($type eq "F") {
+				$path = $name;
+			} else {
+				put_list($name, $path, $type);
+			}
+		}
+
+		close $fh;
+	} else {
+		process_obj($file, 1);
+	}
+}
+
+my @ksyms = ();
+my $start = 0;
+my $path;
+
+open($fh, "\"$ENV{NM}\" -ap \"$ARGV[0]\" 2>/dev/null |")
+	or die "Failed to execute \"$ENV{NM}\" -ap \"$ARGV[0]\": $!";
+
+while (<$fh>) {
+	my $vmlinux_lds = "$ENV{KBUILD_LDS}.S";
+	my $address;
+	my $type;
+	my $name;
+	my $file;
+
+	($address, $type, $name) = $_ =~ /^([0-9a-fA-F]+) (.) (.+)\n$/;
+
+	if (!defined($address) || !defined($type) || !defined($name)) {
+		next;
+	}
+
+	if (!$start && $type eq "a") {
+		$start = 1;
+	}
+
+	if (!$start || substr($name, 0, 3) eq ".LC") {
+		next;
+	}
+
+	if ($type eq "a" && rindex($name, ".") > 0) {
+		$path = $name;
+		next;
+	}
+
+	if ($type =~ /^[[:lower:]]$/) {
+		drop_list($name, $path);
+		$file = $path;
+	} else {
+		$path = undef;
+		$file = get_list($name);
+	}
+
+	if (!defined($file)) {
+		if ($ARGV[0] =~ /^\.tmp_vmlinux.*$/) {
+			$file = $vmlinux_lds;
+		} else {
+			$file = "$ARGV[0]";
+			$file =~ s/.$/ko/;
+		}
+	}
+
+	push(@ksyms, "$address $type $file:$name");
+}
+
+close($fh);
+
+my $last = "";
+
+for my $ksym (sort { substr($a, 19) cmp substr($b, 19) } @ksyms) {
+	my $curr = substr($ksym, 19);
+
+	die "Ambiguous kallsym $curr may break kernel, aborting" if $curr eq $last;
+	$last = $curr;
+}
+
+for my $ksym (sort { substr($a, 0, 18) . substr($a, rindex($a, ":") + 1) cmp
+		     substr($b, 0, 18) . substr($b, rindex($b, ":") + 1) } @ksyms) {
+	print "$ksym\n";
+}
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 445c7fe0ccfe..8a8cd325b812 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -28,6 +28,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
 #define KSYM_NAME_LEN		256
+#define KSYM_NAME_DELIM		':'
 
 struct sym_entry {
 	unsigned long long addr;
@@ -80,6 +81,61 @@ static char *sym_name(const struct sym_entry *s)
 	return (char *)s->sym + 1;
 }
 
+static bool sym_starts(const char *name, const char *str)
+{
+	const char *start;
+
+	start = strchr(name, KSYM_NAME_DELIM);
+	if (!start)
+		start = name;
+	else
+		start++;
+
+	return !strncmp(start, str, strlen(str));
+}
+
+static bool sym_matches(const char *name, const char *str)
+{
+	const char *start;
+
+	start = strchr(name, KSYM_NAME_DELIM);
+	if (!start)
+		start = name;
+	else
+		start++;
+
+	return !strcmp(start, str);
+}
+
+static bool sym_ends(const char *name, const char *str)
+{
+	const char *start;
+	int len;
+
+	start = strchr(name, KSYM_NAME_DELIM);
+	if (!start)
+		start = name;
+	else
+		start++;
+
+	len = strlen(start) - strlen(str);
+
+	return len >= 0 && !strcmp(start + len, str);
+}
+
+static bool sym_contains(const char *name, const char *str)
+{
+	const char *start;
+
+	start = strchr(name, KSYM_NAME_DELIM);
+	if (!start)
+		start = name;
+	else
+		start++;
+
+	return !!strstr(start, str);
+}
+
 static bool is_ignored_symbol(const char *name, char type)
 {
 	/* Symbol names that exactly match to the following are ignored.*/
@@ -140,22 +196,19 @@ static bool is_ignored_symbol(const char *name, char type)
 	const char * const *p;
 
 	for (p = ignored_symbols; *p; p++)
-		if (!strcmp(name, *p))
+		if (sym_matches(name, *p))
 			return true;
 
 	for (p = ignored_prefixes; *p; p++)
-		if (!strncmp(name, *p, strlen(*p)))
+		if (sym_starts(name, *p))
 			return true;
 
-	for (p = ignored_suffixes; *p; p++) {
-		int l = strlen(name) - strlen(*p);
-
-		if (l >= 0 && !strcmp(name + l, *p))
+	for (p = ignored_suffixes; *p; p++)
+		if (sym_ends(name, *p))
 			return true;
-	}
 
 	for (p = ignored_matches; *p; p++) {
-		if (strstr(name, *p))
+		if (sym_contains(name, *p))
 			return true;
 	}
 
@@ -167,10 +220,10 @@ static bool is_ignored_symbol(const char *name, char type)
 
 	if (toupper(type) == 'A') {
 		/* Keep these useful absolute symbols */
-		if (strcmp(name, "__kernel_syscall_via_break") &&
-		    strcmp(name, "__kernel_syscall_via_epc") &&
-		    strcmp(name, "__kernel_sigtramp") &&
-		    strcmp(name, "__gp"))
+		if (!sym_matches(name, "__kernel_syscall_via_break") &&
+		    !sym_matches(name, "__kernel_syscall_via_epc") &&
+		    !sym_matches(name, "__kernel_sigtramp") &&
+		    !sym_matches(name, "__gp"))
 			return true;
 	}
 
@@ -186,10 +239,10 @@ static void check_symbol_range(const char *sym, unsigned long long addr,
 	for (i = 0; i < entries; ++i) {
 		ar = &ranges[i];
 
-		if (strcmp(sym, ar->start_sym) == 0) {
+		if (sym_matches(sym, ar->start_sym)) {
 			ar->start = addr;
 			return;
-		} else if (strcmp(sym, ar->end_sym) == 0) {
+		} else if (sym_matches(sym, ar->end_sym)) {
 			ar->end = addr;
 			return;
 		}
@@ -217,7 +270,7 @@ static struct sym_entry *read_symbol(FILE *in)
 		return NULL;
 	}
 
-	if (strcmp(name, "_text") == 0)
+	if (sym_matches(name, "_text"))
 		_text = addr;
 
 	/* Ignore most absolute/undefined (?) symbols. */
@@ -280,9 +333,9 @@ static int symbol_valid(const struct sym_entry *s)
 		 * rules.
 		 */
 		if ((s->addr == text_range_text->end &&
-		     strcmp(name, text_range_text->end_sym)) ||
+		     !sym_matches(name, text_range_text->end_sym)) ||
 		    (s->addr == text_range_inittext->end &&
-		     strcmp(name, text_range_inittext->end_sym)))
+		     !sym_matches(name, text_range_inittext->end_sym)))
 			return 0;
 	}
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index eecc1863e556..8aa9f9170b7c 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -157,7 +157,19 @@ kallsyms()
 	fi
 
 	info KSYMS ${2}
-	${NM} -n ${1} | scripts/kallsyms ${kallsymopt} > ${2}
+
+	if is_enabled CONFIG_KALLSYMS_PATHS; then
+		local objs="${KBUILD_VMLINUX_OBJS} ${KBUILD_VMLINUX_LIBS}"
+
+		if is_enabled CONFIG_MODULES; then
+			objs="${objs} .vmlinux.export.o"
+		fi
+
+		"${PERL}" "${srctree}/scripts/gen_sympaths.pl" ${1} ${objs} | \
+			scripts/kallsyms ${kallsymopt} > ${2}
+	else
+		${NM} -n ${1} | scripts/kallsyms ${kallsymopt} > ${2}
+	fi
 }
 
 # Perform one step in kallsyms generation, including temporary linking of
diff --git a/scripts/mod/.gitignore b/scripts/mod/.gitignore
index 0465ec33c9bf..a33874fca10b 100644
--- a/scripts/mod/.gitignore
+++ b/scripts/mod/.gitignore
@@ -3,3 +3,4 @@
 /elfconfig.h
 /mk_elfconfig
 /modpost
+/sympath
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index c9e38ad937fd..d94ad6bbead5 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -26,3 +26,12 @@ $(obj)/elfconfig.h: $(obj)/empty.o $(obj)/mk_elfconfig FORCE
 	$(call if_changed,elfconfig)
 
 targets += elfconfig.h
+
+# sympath: used to rewrite STT_FILE in object files from just filenames
+# to paths relative to $(srctree)
+hostprogs-always-$(CONFIG_KALLSYMS_PATHS)	+= sympath
+
+$(obj)/sympath: $(obj)/elfconfig.h
+
+# skip sympath for empty.o: makes no sense and creates a circular dependency
+$(obj)/empty.o: skip-sympath := 1
diff --git a/scripts/mod/sympath.c b/scripts/mod/sympath.c
new file mode 100644
index 000000000000..a25392afae1c
--- /dev/null
+++ b/scripts/mod/sympath.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * The utility finds %STT_FILE symbol in an object file and rewrites its name
+ * in strtab to the provided string. If no symbol is found, it adds a new one.
+ * Used to replace plain filenames with relative paths to use them for kallsyms
+ * later on.
+ */
+
+#define _GNU_SOURCE 1 /* fstat64() */
+
+#include <linux/const.h>
+#include <errno.h>
+#include <getopt.h>
+
+#include "modpost.h"
+
+#define Elf_Off		Elf_Addr
+#define h(x)		TO_NATIVE(x)
+#define t(x)		TO_NATIVE(x)
+
+#define LOCAL_EXISTS	(1UL << 0)
+#define LOCAL_FIXED	(1UL << 1)
+
+static const struct option longopts[] = {
+	{ "path",	required_argument,	NULL,	'p' },
+	{ /* Sentinel */ },
+};
+
+struct state {
+	void		*buf;
+	void		*pos;
+
+	Elf_Ehdr	*eh;
+	Elf_Shdr	*sh;
+
+	Elf_Shdr	*symh;
+	Elf_Shdr	*strh;
+
+	void		*symtab;
+	void		*strtab;
+};
+
+struct opts {
+	const char	*path;
+	const char	*target;
+};
+
+static int parse_args(struct opts *opts, int argc, char *argv[])
+{
+	while (1) {
+		int opt, idx;
+
+		opt = getopt_long(argc, argv, "p:", longopts, &idx);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'p':
+			opts->target = optarg;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (optind != argc - 1)
+		return -EINVAL;
+
+	opts->path = argv[optind];
+
+	return 0;
+}
+
+static size_t move_code(struct state *st, void *start, Elf_Off off)
+{
+	Elf_Off addralign = sizeof(addralign);
+	Elf_Ehdr *eh = st->eh;
+
+	/*
+	 * Find the largest alignment across the sections going after the
+	 * target address and pick one that would work for all of them.
+	 */
+	for (Elf_Shdr *iter = st->sh,
+	     *end = (void *)st->sh + h(eh->e_shnum) * h(eh->e_shentsize);
+	     iter < end; iter = (void *)iter + h(eh->e_shentsize)) {
+		if (h(iter->sh_offset) >= start - st->buf &&
+		    h(iter->sh_addralign) > addralign)
+			addralign = h(iter->sh_addralign);
+	}
+
+	off = __ALIGN_KERNEL(off, addralign);
+
+	if ((void *)st->symh > start)
+		st->symh = (void *)st->symh + off;
+
+	if ((void *)st->strh > start)
+		st->strh = (void *)st->strh + off;
+
+	if (h(eh->e_shoff) > start - st->buf)
+		eh->e_shoff = t(h(eh->e_shoff) + off);
+
+	if (h(eh->e_phoff) > start - st->buf)
+		eh->e_phoff = t(h(eh->e_phoff) + off);
+
+	memmove(start + off, start, st->pos - start);
+	memset(start, 0, off);
+
+	st->pos += off;
+	st->sh = st->buf + h(eh->e_shoff);
+
+	for (Elf_Shdr *iter = st->sh,
+	     *end = (void *)st->sh + h(eh->e_shnum) * h(eh->e_shentsize);
+	     iter < end; iter = (void *)iter + h(eh->e_shentsize)) {
+		if (h(iter->sh_offset) >= start - st->buf)
+			iter->sh_offset = t(h(iter->sh_offset) + off);
+	}
+
+	st->symtab = st->buf + h(st->symh->sh_offset);
+	st->strtab = st->buf + h(st->strh->sh_offset);
+
+	return off;
+}
+
+static void fix_strtab(struct state *st, const char *target, Elf_Sym *sym)
+{
+	Elf_Off off = h(st->strh->sh_size);
+	Elf_Off len = strlen(target) + 1;
+
+	sym->st_name = t(off);
+
+	move_code(st, st->strtab + off, len);
+	st->strh->sh_size = t(h(st->strh->sh_size) + len);
+
+	memcpy(st->strtab + off, target, len);
+}
+
+static void add_file_sym(struct state *st, const char *target)
+{
+	const Elf_Ehdr *eh = st->eh;
+	Elf_Sym *pos = NULL;
+
+	/*
+	 * Num:    Value          Size Type    Bind   Vis      Ndx Name
+	 *   0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
+	 *   1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS usr/initramfs_data.S
+	 *   2: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    4 __irf_start
+	 */
+	for (Elf_Sym *iter = st->symtab,
+	     *end = st->symtab + h(st->symh->sh_size);
+	     iter < end; iter = (void *)iter + h(st->symh->sh_entsize)) {
+		if (iter->st_shndx) {
+			pos = iter;
+			break;
+		}
+	}
+
+	if (!pos)
+		return;
+
+	/* Move all the sections after symtab by the aligned entsize */
+	move_code(st, st->symtab + h(st->symh->sh_size),
+		  h(st->symh->sh_entsize));
+
+	/* Move all the symtab symbols starting from @pos by the entsize */
+	memmove((void *)pos + h(st->symh->sh_entsize), pos,
+		h(st->symh->sh_size) - ((void *)pos - st->symtab));
+	memset(pos, 0, h(st->symh->sh_entsize));
+
+	st->symh->sh_size = t(h(st->symh->sh_size) + h(st->symh->sh_entsize));
+	st->symh->sh_info = t(h(st->symh->sh_info) + 1);
+
+	pos->st_info = t((STB_LOCAL << 4) | STT_FILE);
+	pos->st_shndx = t(SHN_ABS);
+	fix_strtab(st, target, pos);
+
+	for (Elf_Shdr *iter = st->sh,
+	     *end = (void *)st->sh + h(eh->e_shnum) * h(eh->e_shentsize);
+	     iter < end; iter = (void *)iter + h(eh->e_shentsize)) {
+		if (h(iter->sh_type) != SHT_RELA)
+			continue;
+
+		for (Elf_Rela *rela = st->buf + h(iter->sh_offset),
+		     *rend = st->buf + h(iter->sh_offset) + h(iter->sh_size);
+		     rela < rend; rela = (void *)rela + h(iter->sh_entsize)) {
+			Elf_Off info = h(rela->r_info);
+			__u32 shift = sizeof(info) * 4;
+			__u32 idx = info >> shift;
+
+			if (idx >= pos - (typeof(pos))st->symtab) {
+				info &= (Elf_Off)~0ULL >> shift;
+				info |= ((Elf_Off)idx + 1) << shift;
+
+				rela->r_info = t(info);
+			}
+		}
+	}
+}
+
+static int mangle_elf(const struct opts *opts)
+{
+	Elf_Sym *file_loc = NULL;
+	struct stat64 stat = { };
+	struct state st = { };
+	Elf_Off readlen;
+	Elf_Off maxoff;
+	size_t state;
+	ssize_t ret;
+	int fd;
+
+	fd = open(opts->path, O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	ret = fstat64(fd, &stat);
+	if (ret)
+		return -errno;
+
+	st.buf = malloc(stat.st_size + 32768);
+	if (!st.buf) {
+		ret = -ENOMEM;
+		goto close;
+	}
+
+	readlen = sizeof(*st.eh);
+
+	ret = read(fd, st.buf, readlen);
+	if (ret != readlen) {
+		ret = -ENODATA;
+		goto free;
+	}
+
+	st.pos = st.buf + readlen;
+	st.eh = st.buf;
+	ret = -EINVAL;
+
+	if (memcmp(st.eh->e_ident, ELFMAG, SELFMAG))
+		goto free;
+
+	if (st.eh->e_ident[EI_CLASS] != ELFCLASS64) {
+		ret = 0;
+		goto free;
+	}
+
+	if (h(st.eh->e_type) != ET_REL)
+		goto free;
+
+	if (!st.eh->e_shnum || !st.eh->e_shentsize)
+		goto free;
+
+	readlen = h(st.eh->e_shoff);
+	readlen += h(st.eh->e_shnum) * h(st.eh->e_shentsize);
+	readlen -= st.pos - st.buf;
+
+	ret = read(fd, st.pos, readlen);
+	if (ret != readlen) {
+		ret = -ENODATA;
+		goto free;
+	}
+
+	st.pos += readlen;
+	st.sh = st.buf + h(st.eh->e_shoff);
+	ret = -EINVAL;
+
+	for (Elf_Shdr *iter = st.sh,
+	     *end = (void *)st.sh + h(st.eh->e_shnum) * h(st.eh->e_shentsize);
+	     iter < end; iter = (void *)iter + h(st.eh->e_shentsize)) {
+		switch (h(iter->sh_type)) {
+		case SHT_SYMTAB:
+			if (st.symh)
+				goto free;
+
+			st.symh = iter;
+			break;
+		case SHT_STRTAB:
+			if (!st.strh)
+				st.strh = iter;
+
+			break;
+		}
+	}
+
+	if (!st.symh || !st.strh) {
+		ret = 0;
+		goto free;
+	}
+
+	maxoff = st.pos - st.buf;
+	if (maxoff < h(st.symh->sh_offset) + h(st.symh->sh_size))
+		maxoff = h(st.symh->sh_offset) + h(st.symh->sh_size);
+	if (maxoff < h(st.strh->sh_offset) + h(st.strh->sh_size))
+		maxoff = h(st.strh->sh_offset) + h(st.strh->sh_size);
+
+	if (maxoff == st.pos - st.buf)
+		goto look;
+
+	readlen = maxoff - (st.pos - st.buf);
+
+	ret = read(fd, st.pos, readlen);
+	if (ret != readlen) {
+		ret = -ENODATA;
+		goto free;
+	}
+
+	st.pos += readlen;
+
+look:
+	st.symtab = st.buf + h(st.symh->sh_offset);
+	st.strtab = st.buf + h(st.strh->sh_offset);
+	ret = -EINVAL;
+
+	for (Elf_Sym *iter = st.symtab, *end = st.symtab + h(st.symh->sh_size);
+	     iter < end; iter = (void *)iter + h(st.symh->sh_entsize)) {
+		if (ELF_ST_TYPE(h(iter->st_info)) == STT_FILE &&
+		    ELF_ST_BIND(h(iter->st_info)) == STB_LOCAL) {
+			if (file_loc)
+				goto free;
+
+			file_loc = iter;
+		}
+	}
+
+	state = 0;
+	if (file_loc)
+		state |= LOCAL_EXISTS;
+	if (file_loc && !strcmp(st.strtab + h(file_loc->st_name),
+				opts->target))
+		state |= LOCAL_FIXED;
+
+	switch (state) {
+	case 0:
+		add_file_sym(&st, opts->target);
+		break;
+	case LOCAL_EXISTS:
+		fix_strtab(&st, opts->target, file_loc);
+		break;
+	case LOCAL_EXISTS | LOCAL_FIXED:
+		break;
+	default:
+		goto free;
+	}
+
+	readlen = stat.st_size - maxoff;
+
+	ret = read(fd, st.pos, readlen);
+	if (ret != readlen) {
+		ret = -ENODATA;
+		goto free;
+	}
+
+	st.pos += readlen;
+
+	ret = pwrite(fd, st.buf, st.pos - st.buf, 0);
+	if (ret != st.pos - st.buf) {
+		ret = -EAGAIN;
+		goto free;
+	}
+
+	ret = 0;
+
+free:
+	free(st.buf);
+close:
+	close(fd);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct opts opts = { };
+	int ret;
+
+	ret = parse_args(&opts, argc, argv);
+	if (ret)
+		return ret;
+
+	if (!opts.path || !opts.target)
+		return -EINVAL;
+
+	ret = mangle_elf(&opts);
+	if (ret)
+		return ret;
+
+	return 0;
+}
-- 
2.37.2

