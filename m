Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610EF35C09C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbhDLJPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240971AbhDLJLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E2B6613C3;
        Mon, 12 Apr 2021 09:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218455;
        bh=0M6bUyhgdNHpt68OuYjW4TnIh3Hjh4bN64JdvKs3lzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehEv/o4OFRJiTst7baBbNfFzX8otFs2FE7kg6CUkpEdAYd1lId6ne/Emz69yKLJLa
         k0TgqXlwMIEyRQU1ZC7TUAmXmDhQa0q98zW04MC6V3mX7RLs9RcaLuiKHlj8jBtWDR
         bQUAZUQ2NnX50TK5eWjMPQgd1WugHFk+xIZciQco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrew Vagin <avagin@openvz.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 170/210] perf inject: Fix repipe usage
Date:   Mon, 12 Apr 2021 10:41:15 +0200
Message-Id: <20210412084021.687066121@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 026334a3bb6a3919b42aba9fc11843db2b77fd41 ]

Since commit 14d3d54052539a1e ("perf session: Try to read pipe data from
file") 'perf inject' has started printing "PERFILE2h" when not processing
pipes.

The commit exposed perf to the possiblity that the input is not a pipe
but the 'repipe' parameter gets used. That causes the printing because
perf inject sets 'repipe' to true always.

The 'repipe' parameter of perf_session__new() is used by 2 functions:

	- perf_file_header__read_pipe()
	- trace_report()

In both cases, the functions copy data to STDOUT_FILENO when 'repipe' is
true.

Fix by setting 'repipe' to true only if the output is a pipe.

Fixes: e558a5bd8b74aff4 ("perf inject: Work with files")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andrew Vagin <avagin@openvz.org>
Link: http://lore.kernel.org/lkml/20210401103605.9000-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 43937f4b399a..c0be51b95713 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -906,7 +906,7 @@ int cmd_inject(int argc, const char **argv)
 	}
 
 	data.path = inject.input_name;
-	inject.session = perf_session__new(&data, true, &inject.tool);
+	inject.session = perf_session__new(&data, inject.output.is_pipe, &inject.tool);
 	if (IS_ERR(inject.session))
 		return PTR_ERR(inject.session);
 
-- 
2.30.2



