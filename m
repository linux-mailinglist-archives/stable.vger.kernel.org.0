Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD6598296
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244197AbiHRLyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243934AbiHRLyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:54:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EAC7FFAD;
        Thu, 18 Aug 2022 04:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660823693; x=1692359693;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HsOPy0Z5++etcYrSFF3B5HZWLyK0D1O3GxxmVs0sLSg=;
  b=izyX/pymDfYB4qgMUZIUpYDra3Q5fIx9SBuvGGtXRIl7YOA6reXREuJ+
   2Z5u61uAx/IWtTAcnTcGOmMoVpDPQletoO37RJBC2Pg3Sb8b90oqxH8ot
   Y6/3XiBf/IW6dWPu/fQSASTm0FqHAgT5fl2px+tiYw4vxVMwh9gJHZsEh
   tKzTTRyCWr5Q9duXXtH/so2M+UiqsbmOIzZDsuhOaPdWE60FzsLol9AZJ
   vhgc3NKwDLAXBNSQHsBsk92dpeQkLNiB8hTqm2f/Kzdg1qlqnwpXx6nyF
   kOYwIszSRth9S0rlrlElor6b1WWVlB3J1yBC9tNVq3JOtqd2ucdPLQ7+B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290304652"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="290304652"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="935783750"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2022 04:54:49 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IBsmfr013911;
        Thu, 18 Aug 2022 12:54:48 +0100
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
Subject: [RFC PATCH 0/3] kallsyms: add option to include relative filepaths into kallsyms
Date:   Thu, 18 Aug 2022 13:53:03 +0200
Message-Id: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an early RFC to not rewrite stuff one more time later on if
the implementation is not acceptable or any major design changes are
required. For the TODO list, please scroll to the end.

Make kallsyms independent of symbols positions in vmlinux (or module)
by including relative filepath in each symbol's kallsyms value. I.e.

dev_gro_receive -> net/core/gro.c:dev_gro_receive

For the implementation details, please look at the patch 3/3.
Patch 2/3 is just a stub, I plan to reuse kallsyms enhancement from
the Rust series for it.
Patch 1/3 is a fix of one modpost macro straight from 2.6.12-rc2.

A nice side effect is that it's now easier to debug the kernel, as
stacktraces will now tell every call's place in the file tree:

[    0.733191] Call Trace:
[    0.733668]  <TASK>
[    0.733980]  lib/dump_stack.c:dump_stack_lvl+0x48/0x68
[    0.734689]  kernel/panic.c:panic+0xf8/0x2ae
[    0.735291]  init/do_mounts.c:mount_block_root+0x143/0x1ea
[    0.736046]  init/do_mounts.c:prepare_namespace+0x13f/0x16e
[    0.736798]  init/main.c:kernel_init_freeable+0x240/0x24f
[    0.737549]  ? init/main.c:rest_init+0xc0/0xc0
[    0.738171]  init/main.c:kernel_init+0x1a/0x140
[    0.738765]  arch/x86/entry/entry_64.S:ret_from_fork+0x1f/0x30
[    0.739529]  </TASK>

Here are some stats:

Despite running a small utility on each object file and a script on
each built-in.a plus one at the kallsyms generation process, it adds
only 3 seconds to the whole clean build time:

make -j$(($(nproc) + 1)) all compile_commands.json  19071.12s user 3481.97s system 4587% cpu 8:11.64 total
make -j$(($(nproc) + 1)) all compile_commands.json  19202.88s user 3598.80s system 4607% cpu 8:14.85 total

Compressed kallsyms become bigger by 1.4 Mbytes on x86_64 standard
distroconfig - 60% of the kallsyms and 2.4% of the decompressed
vmlinux in the memory:

ffffffff8259ab30 D kallsyms_offsets
ffffffff82624ed0 D kallsyms_relative_base
ffffffff82624ed8 D kallsyms_num_syms
ffffffff82624ee0 D kallsyms_names
ffffffff827e9c68 D kallsyms_markers
ffffffff827ea510 D kallsyms_token_table
ffffffff827ea8c0 D kallsyms_token_index
ffffffff827eaac0 d .LC1

->

ffffffff8259ac30 D kallsyms_offsets
ffffffff82624fb8 D kallsyms_relative_base
ffffffff82624fc0 D kallsyms_num_syms
ffffffff82624fc8 D kallsyms_names
ffffffff8294de50 D kallsyms_markers
ffffffff8294e6f8 D kallsyms_token_table
ffffffff8294eac8 D kallsyms_token_index
ffffffff8294ecc8 d .LC1

TODO:
 * ELF rel and MIPS relocation support (only rela currently, just
   to test on x86_64);
 * modules support. Currently, the kernel reuses standard ELF strtab
   for module kallsyms. My plan is to create a new section which will
   have the same symbol order as symtab, but point to new complete
   strings with filepaths, and use this section solely for kallsyms
   (leaving symtab alone);
 * LTO support (now relies on that object files are ELFs);
 * the actual kallsyms/livepatching/probes code which will use
   filepaths instead of indexes/positions.

Have fun!

Alexander Lobakin (3):
  modpost: fix TO_NATIVE() with expressions and consts
  [STUB] increase kallsyms length limit
  kallsyms: add option to include relative filepaths into kallsyms

 .gitignore                |   1 +
 Makefile                  |   2 +-
 include/linux/kallsyms.h  |   2 +-
 init/Kconfig              |  26 ++-
 kernel/livepatch/core.c   |   4 +-
 scripts/Makefile.build    |   7 +-
 scripts/Makefile.lib      |  10 +-
 scripts/Makefile.modfinal |   3 +-
 scripts/gen_sympaths.pl   | 270 ++++++++++++++++++++++++++
 scripts/kallsyms.c        |  89 +++++++--
 scripts/link-vmlinux.sh   |  14 +-
 scripts/mod/.gitignore    |   1 +
 scripts/mod/Makefile      |   9 +
 scripts/mod/modpost.h     |   7 +-
 scripts/mod/sympath.c     | 385 ++++++++++++++++++++++++++++++++++++++
 15 files changed, 796 insertions(+), 34 deletions(-)
 create mode 100755 scripts/gen_sympaths.pl
 create mode 100644 scripts/mod/sympath.c

-- 
2.37.2

