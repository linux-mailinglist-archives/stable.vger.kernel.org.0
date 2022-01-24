Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD44995AD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442237AbiAXUx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44502 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392408AbiAXUvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:51:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2663860C44;
        Mon, 24 Jan 2022 20:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E5AC340E5;
        Mon, 24 Jan 2022 20:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057467;
        bh=fhcehs13K324S4NcYX+VvjBRl1SSEGNfMfH7EvgCHdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7kLsUK20rDWue9Uyg1ZVFrQZ7nwBRiLVWup05cwTaffk4DFKiQhByxotCWEQpsKG
         BMFWgwW5wPbLWy9Lb9N+nRRfkG/R8nJk2+/Am5UfWDvwEcC4vKVa2jslN5J8NhQ4I7
         RFWWsyWZ/2lhgaasPBJyExU1gOzRawFEcjdSs+Qk=
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
Subject: [PATCH 5.15 821/846] perf tools: Drop requirement for libstdc++.so for libopencsd check
Date:   Mon, 24 Jan 2022 19:45:38 +0100
Message-Id: <20220124184129.225160788@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


