Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D44FD428
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351798AbiDLHdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354379AbiDLH0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911BC457A8;
        Tue, 12 Apr 2022 00:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17BC0616AB;
        Tue, 12 Apr 2022 07:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC555C385A6;
        Tue, 12 Apr 2022 07:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747172;
        bh=X/BtyyXbbqto7e/ymegP/7sT2/2Xne4gHenRZLCdUYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmSor6S7XNisNtZBXta65b2Qm7VQZDwnbq1VUTd+Ot+RVeQ1ZeiPCgkndieXqa9xh
         GZBKlfPTj0SlQ3qndTyR6sSkoJJiSglX9Doau+xmQi4SaEhAzGWH37pcTQPxVSjhe3
         r0WUm0zIXC8Fii/GcNdScJtU2Br0bul6j2ZKVPFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Fangrui Song <maskray@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        John Keeping <john@metanate.com>, Leo Yan <leo.yan@linaro.org>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.16 269/285] tools build: Filter out options and warnings not supported by clang
Date:   Tue, 12 Apr 2022 08:32:06 +0200
Message-Id: <20220412062951.421335021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 41caff459a5b956b3e23ba9ca759dd0629ad3dda upstream.

These make the feature check fail when using clang, so remove them just
like is done in tools/perf/Makefile.config to build perf itself.

Adding -Wno-compound-token-split-by-macro to tools/perf/Makefile.config
when building with clang is also necessary to avoid these warnings
turned into errors (-Werror):

    CC      /tmp/build/perf/util/scripting-engines/trace-event-perl.o
  In file included from util/scripting-engines/trace-event-perl.c:35:
  In file included from /usr/lib64/perl5/CORE/perl.h:4085:
  In file included from /usr/lib64/perl5/CORE/hv.h:659:
  In file included from /usr/lib64/perl5/CORE/hv_func.h:34:
  In file included from /usr/lib64/perl5/CORE/sbox32_hash.h:4:
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: error: '(' and '{' tokens introducing statement expression appear in different macro expansion contexts [-Werror,-Wcompound-token-split-by-macro]
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:80:38: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  #define ZAPHOD32_SCRAMBLE32(v,prime) STMT_START {  \
                                       ^~~~~~~~~~
  /usr/lib64/perl5/CORE/perl.h:737:29: note: expanded from macro 'STMT_START'
  #   define STMT_START   (void)( /* gcc supports "({ STATEMENTS; })" */
                                ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: note: '{' token is here
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:80:49: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  #define ZAPHOD32_SCRAMBLE32(v,prime) STMT_START {  \
                                                  ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: error: '}' and ')' tokens terminating statement expression appear in different macro expansion contexts [-Werror,-Wcompound-token-split-by-macro]
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:87:41: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
      v ^= (v>>23);                       \
                                          ^
  /usr/lib64/perl5/CORE/zaphod32_hash.h:150:5: note: ')' token is here
      ZAPHOD32_SCRAMBLE32(state[0],0x9fade23b);
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/lib64/perl5/CORE/zaphod32_hash.h:88:3: note: expanded from macro 'ZAPHOD32_SCRAMBLE32'
  } STMT_END
    ^~~~~~~~
  /usr/lib64/perl5/CORE/perl.h:738:21: note: expanded from macro 'STMT_END'
  #   define STMT_END     )
                          ^

Please refer to the discussion on the Link: tag below, where Nathan
clarifies the situation:

<quote>
acme> And then get to the problems at the end of this message, which seem
acme> similar to the problem described here:
acme>
acme> From  Nathan Chancellor <>
acme> Subject	[PATCH] mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
acme>
acme> https://lkml.org/lkml/2020/9/1/135
acme>
acme> So perhaps in this case its better to disable that
acme> -Werror,-Wcompound-token-split-by-macro when building with clang?

Yes, I think that is probably the best solution. As far as I can tell,
at least in this file and context, the warning appears harmless, as the
"create a GNU C statement expression from two different macros" is very
much intentional, based on the presence of PERL_USE_GCC_BRACE_GROUPS.
The warning is fixed in upstream Perl by just avoiding creating GNU C
statement expressions using STMT_START and STMT_END:

  https://github.com/Perl/perl5/issues/18780
  https://github.com/Perl/perl5/pull/18984

If I am reading the source code correctly, an alternative to disabling
the warning would be specifying -DPERL_GCC_BRACE_GROUPS_FORBIDDEN but it
seems like that might end up impacting more than just this site,
according to the issue discussion above.
</quote>

Based-on-a-patch-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Debian/Selfmade LLVM-14 (x86-64)
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Keeping <john@metanate.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: http://lore.kernel.org/lkml/YkxWcYzph5pC1EK8@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/Makefile |    7 +++++++
 tools/perf/Makefile.config   |    3 +++
 2 files changed, 10 insertions(+)

--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -220,6 +220,13 @@ PERL_EMBED_LIBADD = $(call grep-libs,$(P
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
+ifeq ($(CC_NO_CLANG), 0)
+  PERL_EMBED_LDOPTS := $(filter-out -specs=%,$(PERL_EMBED_LDOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -flto=auto -ffat-lto-objects, $(PERL_EMBED_CCOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -specs=%,$(PERL_EMBED_CCOPTS))
+  FLAGS_PERL_EMBED += -Wno-compound-token-split-by-macro
+endif
+
 $(OUTPUT)test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -788,6 +788,9 @@ else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
     CFLAGS += -DHAVE_LIBPERL_SUPPORT
+    ifeq ($(CC_NO_CLANG), 0)
+      CFLAGS += -Wno-compound-token-split-by-macro
+    endif
     $(call detected,CONFIG_LIBPERL)
   endif
 endif


