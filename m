Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83951499BB7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379657AbiAXVyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52814 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359781AbiAXVnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F0EBB811A2;
        Mon, 24 Jan 2022 21:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826F0C340E4;
        Mon, 24 Jan 2022 21:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060598;
        bh=fhcehs13K324S4NcYX+VvjBRl1SSEGNfMfH7EvgCHdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YEfBIsJmChaWyJWJeyJ1/ODb2a+6fEVafLWI/hwXtK/4VTSu0GWl1z5m0DdviLqi
         oWmlaWBbywz6G26BWgTt2Ox1LgyK/PRwvEu8mDgpaWypcxg95dzNXFWLXanSPmGVou
         1N9n7++DJznG9mzeLSC6DQdmWDc5h0wztUiucREI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Adrian Bunk <bunk@debian.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Branislav Rankov <branislav.rankov@arm.com>,
        Diederik de Haas <didi.debian@cknow.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 1001/1039] perf tools: Drop requirement for libstdc++.so for libopencsd check
Date:   Mon, 24 Jan 2022 19:46:30 +0100
Message-Id: <20220124184158.935216954@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <uwe@kleine-koenig.org>

commit ed17b1914978eddb2b01f2d34577f1c82518c650 upstream.

It's possible to link against libopencsd_c_api without having
libstdc++.so available, only libstdc++.so.6.0.28 (or whatever version is
in use) needs to be available. The same holds true for libopencsd.so.
When -lstdc++ (or -lopencsd) is explicitly passed to the linker however
the .so file must be available.

So wrap adding the dependencies into a check for static linking that
actually requires adding them all. The same construct is already used
for some other tests in the same file to reduce dependencies in the
dynamic linking case.

Fixes: 573cf5c9a152 ("perf build: Add missing -lstdc++ when linking with libopencsd")
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: Adrian Bunk <bunk@debian.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Branislav Rankov <branislav.rankov@arm.com>
Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/all/20211203210544.1137935-1-uwe@kleine-koenig.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -143,7 +143,10 @@ FEATURE_CHECK_LDFLAGS-libcrypto = -lcryp
 ifdef CSINCLUDES
   LIBOPENCSD_CFLAGS := -I$(CSINCLUDES)
 endif
-OPENCSDLIBS := -lopencsd_c_api -lopencsd -lstdc++
+OPENCSDLIBS := -lopencsd_c_api
+ifeq ($(findstring -static,${LDFLAGS}),-static)
+  OPENCSDLIBS += -lopencsd -lstdc++
+endif
 ifdef CSLIBS
   LIBOPENCSD_LDFLAGS := -L$(CSLIBS)
 endif


