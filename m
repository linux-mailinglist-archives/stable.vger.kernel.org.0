Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF11F38314A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhEQOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240304AbhEQOdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B7661923;
        Mon, 17 May 2021 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260987;
        bh=PHv2KvDy2IsXL+3VSPa4nrcKmdcnjm1hesbTOs07WOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq24qAp3+fK62qZd3FlxNfjwUnk/jaeJBVEAT/dbbvHpVLlS+QL8ESwoqkaUv/kIl
         foYRswgCsQ1XlWTnIUNgyqLf5+RO01ajPELPnxycfbWgJK7+d7c1xxxbb+XuZLoNNJ
         JlyoFgd6UPPMWBYFxbDpC+jA2HEBMH4OKXaMqXsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Justin M. Forbes" <jforbes@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 284/363] perf tools: Fix dynamic libbpf link
Date:   Mon, 17 May 2021 16:02:30 +0200
Message-Id: <20210517140312.207744252@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit ad1237c30d975535a669746496cbed136aa5a045 ]

Justin reported broken build with LIBBPF_DYNAMIC=1.

When linking libbpf dynamically we need to use perf's
hashmap object, because it's not exported in libbpf.so
(only in libbpf.a).

Following build is now passing:

  $ make LIBBPF_DYNAMIC=1
    BUILD:   Doing 'make -j8' parallel build
    ...
  $ ldd perf | grep libbpf
        libbpf.so.0 => /lib64/libbpf.so.0 (0x00007fa7630db000)

Fixes: eee19501926d ("perf tools: Grab a copy of libbpf's hashmap")
Reported-by: Justin M. Forbes <jforbes@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210508205020.617984-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 1 +
 tools/perf/util/Build      | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index d8e59d31399a..c955cd683e22 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -530,6 +530,7 @@ ifndef NO_LIBELF
       ifdef LIBBPF_DYNAMIC
         ifeq ($(feature-libbpf), 1)
           EXTLIBS += -lbpf
+          $(call detected,CONFIG_LIBBPF_DYNAMIC)
         else
           dummy := $(error Error: No libbpf devel library found, please install libbpf-devel);
         endif
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index e3e12f9d4733..5a296ac69415 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -141,7 +141,14 @@ perf-$(CONFIG_LIBELF) += symbol-elf.o
 perf-$(CONFIG_LIBELF) += probe-file.o
 perf-$(CONFIG_LIBELF) += probe-event.o
 
+ifdef CONFIG_LIBBPF_DYNAMIC
+  hashmap := 1
+endif
 ifndef CONFIG_LIBBPF
+  hashmap := 1
+endif
+
+ifdef hashmap
 perf-y += hashmap.o
 endif
 
-- 
2.30.2



