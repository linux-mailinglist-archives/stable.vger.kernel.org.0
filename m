Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12D43D6028
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhGZPVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237108AbhGZPVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AFC860F38;
        Mon, 26 Jul 2021 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315292;
        bh=AEcizyHU+/c5oQ14TgiR8P1PpRbnAJdqQA5p4hEGReA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud5XbpIbziaxaNeip5ATXcg02EcUGkocsrm4WCgb1M+Z8+BMIN/Y0CIKfh4o9CwfM
         ePVPI55KBLhObYhx2Ga51QSbtcEPnej+1AZhpdZFNKKKzoNTc94c1q68gipsbFqT62
         YGFamUOPyx82HcHD4rqjqbt4hGcMFBBMKkxLF9f8=
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
Subject: [PATCH 5.10 040/167] perf test maps__merge_in: Fix memory leak of maps
Date:   Mon, 26 Jul 2021 17:37:53 +0200
Message-Id: <20210726153840.736590102@linuxfoundation.org>
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

[ Upstream commit 244d1797c8c8e850b8de7992af713aa5c70d5650 ]

ASan reports a memory leak when running:

  # perf test "65: maps__merge_in"

This is the second and final patch addressing these memory leaks.

This time, the problem is simply that the maps object is never
destructed.

This patch adds the missing maps__exit call.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 79b6bb73f888933c ("perf maps: Merge 'struct maps' with 'struct map_groups'")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/a1a29b97a58738987d150e94d4ebfad0282fb038.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/maps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/tests/maps.c b/tools/perf/tests/maps.c
index edcbc70ff9d6..1ac72919fa35 100644
--- a/tools/perf/tests/maps.c
+++ b/tools/perf/tests/maps.c
@@ -116,5 +116,7 @@ int test__maps__merge_in(struct test *t __maybe_unused, int subtest __maybe_unus
 
 	ret = check_maps(merged3, ARRAY_SIZE(merged3), &maps);
 	TEST_ASSERT_VAL("merge check failed", !ret);
+
+	maps__exit(&maps);
 	return TEST_OK;
 }
-- 
2.30.2



