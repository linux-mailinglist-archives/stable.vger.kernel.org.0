Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22894FD800
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351834AbiDLHdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354452AbiDLH0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B59345ACB;
        Tue, 12 Apr 2022 00:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFDE616B5;
        Tue, 12 Apr 2022 07:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1491C385AB;
        Tue, 12 Apr 2022 07:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747175;
        bh=PYNQeBE5FIvK7ttjTSwyhrldUg+LR6Jt9gF2vnHvEZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWOlPl46JTPHtC0j7/D+wKMEh6lQYjxfwGkqzH6EziJRVVfRS8bRcFRwF35gpjQj2
         3CjGD4qLDghYcAOU7qG5q+Wme3TTUSH5vRlfoWww0TIV61de47f4D/Sd9mdLR4SvMt
         fvWnOuQmPAxzM8P6k7UovauMddTBhLAKMLb6THGg=
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
Subject: [PATCH 5.16 270/285] tools build: Use $(shell ) instead of `` to get embedded libperls ccopts
Date:   Tue, 12 Apr 2022 08:32:07 +0200
Message-Id: <20220412062951.450971380@linuxfoundation.org>
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

commit 541f695cbcb6932c22638b06e0cbe1d56177e2e9 upstream.

Just like its done for ldopts and for both in tools/perf/Makefile.config.

Using `` to initialize PERL_EMBED_CCOPTS somehow precludes using:

  $(filter-out SOMETHING_TO_FILTER,$(PERL_EMBED_CCOPTS))

And we need to do it to allow for building with versions of clang where
some gcc options selected by distros are not available.

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
Link: http://lore.kernel.org/lkml/YktYX2OnLtyobRYD@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -217,7 +217,7 @@ strip-libs = $(filter-out -l%,$(1))
 PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
 PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
 PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+PERL_EMBED_CCOPTS = $(shell perl -MExtUtils::Embed -e ccopts 2>/dev/null)
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 ifeq ($(CC_NO_CLANG), 0)


