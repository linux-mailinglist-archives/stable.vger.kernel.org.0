Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15DF35BEBD
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhDLJBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238383AbhDLI5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE2E4611F0;
        Mon, 12 Apr 2021 08:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217799;
        bh=bn7xk2587tf5u0SIBmuae28JcTsJnThvn5v5KEIqttI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYCvA82QQzm9NJSvzL+/uCrBHJXi+L6K9Jw0YAqpFnIAD3IKGz7eDiLM0eOWubU0g
         mojiQJ1Fz27rV+IEkG+rT+rqnG8B++oBlYjMrWYYDaoyAqgaDQEJYqVG5ZPrUbjdqj
         TRs1Um4l/0p4HhAIrxwj2ZdHAI5VGlaFDcBZOUis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrew Vagin <avagin@openvz.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/188] perf inject: Fix repipe usage
Date:   Mon, 12 Apr 2021 10:41:04 +0200
Message-Id: <20210412084018.603261337@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 0462dc8db2e3..5320ac1b1285 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -904,7 +904,7 @@ int cmd_inject(int argc, const char **argv)
 	}
 
 	data.path = inject.input_name;
-	inject.session = perf_session__new(&data, true, &inject.tool);
+	inject.session = perf_session__new(&data, inject.output.is_pipe, &inject.tool);
 	if (IS_ERR(inject.session))
 		return PTR_ERR(inject.session);
 
-- 
2.30.2



