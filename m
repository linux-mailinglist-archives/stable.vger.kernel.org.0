Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB73D6134
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhGZPaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238209AbhGZP1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:27:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C0C860FBF;
        Mon, 26 Jul 2021 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315604;
        bh=Fdqk3ztbbE/vk3sq2pTpdUpwhKruJ93bgYarkWirXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7pztsJhZa2rhwoqCsXrEv5pR54c1akwcDy7+MYR0U5UqzHIjlFkUJsi0JWjqiZXl
         +s7WPmzy/MR4GaTtoWJRPXi65fuhhERt9AGL99/1YqJuoN0XBAZczjZjKrpMjzcMrM
         brN8QYSycvB4ZEMUho1OMimUGO7fypZtwVsw8ZKE=
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
Subject: [PATCH 5.10 163/167] perf inject: Close inject.output on exit
Date:   Mon, 26 Jul 2021 17:39:56 +0200
Message-Id: <20210726153844.875747472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
@@ -906,8 +906,10 @@ int cmd_inject(int argc, const char **ar
 
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
@@ -949,5 +951,7 @@ int cmd_inject(int argc, const char **ar
 out_delete:
 	zstd_fini(&(inject.session->zstd_data));
 	perf_session__delete(inject.session);
+out_close_output:
+	perf_data__close(&inject.output);
 	return ret;
 }


