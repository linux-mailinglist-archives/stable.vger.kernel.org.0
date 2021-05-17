Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B0F3837BD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhEQPqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344301AbhEQPoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4FBD61406;
        Mon, 17 May 2021 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262595;
        bh=fBCwBoQIBu1Z/Im+ck+WQ9ZRSffBq64U6W6k0+CiYPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mThKyBUQFBjv60FKsTXXCDn+c/Eno/+iS7uvHYCXTGpLDmZ2hwCUcI2hzYYPNPYRO
         m80+7jc7M58EEuLwQIu7GhKm/mYRnJexnheVwapZ5WeKrFJ4rERdLGX8QRXmebrwXA
         W9K5tqNnyStePm1bNVODnNOIygCpoL+niPfRmgVg=
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
Subject: [PATCH 5.10 221/289] perf tools: Fix dynamic libbpf link
Date:   Mon, 17 May 2021 16:02:26 +0200
Message-Id: <20210517140312.594711262@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index ce8516e4de34..2abbd75fbf2e 100644
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
index e2563d0154eb..0cf27354aa45 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -140,7 +140,14 @@ perf-$(CONFIG_LIBELF) += symbol-elf.o
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



