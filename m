Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC7DD3C9
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393759AbfJRWUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732044AbfJRWGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF7A2222D2;
        Fri, 18 Oct 2019 22:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436410;
        bh=PYVlkSe364IsMEE5iJc7n0T9JVHw1//hqeU7d9B3O7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdavSRDmwwwlUcN7tRP/KbONuVnJHUbuseQ+2TF76ECeOFI7ggsyngNdjr5vNAz/5
         zE1S5gzcU2Yby/8AxCPTHoB3CzQox9xXRqdMRLx3v62wKoUZq7ogeMKC3k4j1lNUSx
         EBGVb/iv2Fnoyyy9qfYF52fsru7/elmX+j3RazqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 056/100] perf jevents: Fix period for Intel fixed counters
Date:   Fri, 18 Oct 2019 18:04:41 -0400
Message-Id: <20191018220525.9042-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 6bdfd9f118bd59cf0f85d3bf4b72b586adea17c1 ]

The Intel fixed counters use a special table to override the JSON
information.

During this override the period information from the JSON file got
dropped, which results in inst_retired.any and similar running with
frequency mode instead of a period.

Just specify the expected period in the table.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20190927233546.11533-2-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index 6b36b71106695..6cd9623ebc93b 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -446,12 +446,12 @@ static struct fixed {
 	const char *name;
 	const char *event;
 } fixed[] = {
-	{ "inst_retired.any", "event=0xc0" },
-	{ "inst_retired.any_p", "event=0xc0" },
-	{ "cpu_clk_unhalted.ref", "event=0x0,umask=0x03" },
-	{ "cpu_clk_unhalted.thread", "event=0x3c" },
-	{ "cpu_clk_unhalted.core", "event=0x3c" },
-	{ "cpu_clk_unhalted.thread_any", "event=0x3c,any=1" },
+	{ "inst_retired.any", "event=0xc0,period=2000003" },
+	{ "inst_retired.any_p", "event=0xc0,period=2000003" },
+	{ "cpu_clk_unhalted.ref", "event=0x0,umask=0x03,period=2000003" },
+	{ "cpu_clk_unhalted.thread", "event=0x3c,period=2000003" },
+	{ "cpu_clk_unhalted.core", "event=0x3c,period=2000003" },
+	{ "cpu_clk_unhalted.thread_any", "event=0x3c,any=1,period=2000003" },
 	{ NULL, NULL},
 };
 
-- 
2.20.1

