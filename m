Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775CB3D6075
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhGZPW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237319AbhGZPWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C6E60E09;
        Mon, 26 Jul 2021 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315372;
        bh=cVGMIjXiW9ylHd/dFnWgStv+fD3pZiwnVCRzOXd5xK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCqzEZR0iDvk3qqvTpQTEgCssD6bZuTjEZ1xVP0UvdmCkSejg9IkmsVRVVurP7sOZ
         kGYhLikzulIf16aAmKeo+7CYOf+hAVm0+uC3APVPXF8egqveJTMsV0MaxrslpnbVNg
         oI0Ct9ZcOMoaJOzYDiW1i32+scRbES75PlDGXoo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/167] perf env: Fix sibling_dies memory leak
Date:   Mon, 26 Jul 2021 17:37:49 +0200
Message-Id: <20210726153840.593524943@linuxfoundation.org>
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

[ Upstream commit 42db3d9ded555f7148b5695109a7dc8d66f0dde4 ]

ASan reports a memory leak in perf_env while running:

  # perf test "41: Session topology"

Caused by sibling_dies not being freed.

This patch adds the required free.

Fixes: acae8b36cded0ee6 ("perf header: Add die information in CPU topology")
Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/2140d0b57656e4eb9021ca9772250c24c032924b.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/env.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index fadc59708ece..744e51c4a6bd 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -178,6 +178,7 @@ void perf_env__exit(struct perf_env *env)
 	zfree(&env->cpuid);
 	zfree(&env->cmdline);
 	zfree(&env->cmdline_argv);
+	zfree(&env->sibling_dies);
 	zfree(&env->sibling_cores);
 	zfree(&env->sibling_threads);
 	zfree(&env->pmu_mappings);
-- 
2.30.2



