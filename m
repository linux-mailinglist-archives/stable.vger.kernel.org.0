Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35C3D5FD8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhGZPTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236616AbhGZPTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E1360FD7;
        Mon, 26 Jul 2021 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315187;
        bh=npH5eqlpatA98/12plTXrBIf/CfD70hux0lUZ+i+ESw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsvvblNsirSoGpcjUeZEBFSP3S/2f6alv3jCZaFIFNoJ1aMP/pqC9blI9MOGL1APZ
         kIaSRO3+20erMcuAl+JaSEWofF4p2XxLM+/yqwVBdXwTUYE8LpJRq81yFMphn+IrVs
         mCBcK/dsJhdnlwzMn39qgDpwPcUauRtR9d7R/CcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 107/108] perf inject: Close inject.output on exit
Date:   Mon, 26 Jul 2021 17:39:48 +0200
Message-Id: <20210726153835.103060624@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

commit 02e6246f5364d5260a6ea6f92ab6f409058b162f upstream.

ASan reports a memory leak when running:

  # perf test "83: Zstd perf.data compression/decompression"

which happens inside 'perf inject'.

The bug is caused by inject.output never being closed.

This patch adds the missing perf_data__close().

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 6ef81c55a2b6584c ("perf session: Return error code for perf_session__new() function on failure")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/c06f682afa964687367cf6e92a64ceb49aec76a5.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -836,8 +836,10 @@ int cmd_inject(int argc, const char **ar
 
 	data.path = inject.input_name;
 	inject.session = perf_session__new(&data, inject.output.is_pipe, &inject.tool);
-	if (IS_ERR(inject.session))
-		return PTR_ERR(inject.session);
+	if (IS_ERR(inject.session)) {
+		ret = PTR_ERR(inject.session);
+		goto out_close_output;
+	}
 
 	if (zstd_init(&(inject.session->zstd_data), 0) < 0)
 		pr_warning("Decompression initialization failed.\n");
@@ -874,5 +876,7 @@ int cmd_inject(int argc, const char **ar
 out_delete:
 	zstd_fini(&(inject.session->zstd_data));
 	perf_session__delete(inject.session);
+out_close_output:
+	perf_data__close(&inject.output);
 	return ret;
 }


