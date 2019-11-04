Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022AFEEF50
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfKDWUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388732AbfKDV7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:47 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDB6214E0;
        Mon,  4 Nov 2019 21:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904786;
        bh=sv3AcplPh/x/HJ/H3hvgJUOAaTDB7KXd0y7Ec48YC/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmWco2UYYpvEN740KhddW5W/5ehxFWuoDvvtmVoerANUkrItqOK5AGkEYwmZTOMsF
         v3UbqpEWRx3kkAX9AuZ9vEfByrXov9A+Xf9hpyCjzOu66XzXtYUFyxGp/64KpQshpY
         juSBwZhRFiRu9dtfLlIAgakVU6LVo9BmiXGYrltw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.19 069/149] perf annotate: Return appropriate error code for allocation failures
Date:   Mon,  4 Nov 2019 22:44:22 +0100
Message-Id: <20191104212141.555401467@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 16ed3c1e91159e28b02f11f71ff4ce4cbc6f99e4 ]

We should return errno or the annotation extra range understood by
symbol__strerror_disassemble() instead of -1, fix it, returning ENOMEM
instead.

Reported-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/n/tip-8of1cmj3rz0mppfcshc9bbqq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 83a3ad4256c5b..6958d7eed5bed 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1614,7 +1614,7 @@ static int dso__disassemble_filename(struct dso *dso, char *filename, size_t fil
 
 	build_id_path = strdup(filename);
 	if (!build_id_path)
-		return -1;
+		return ENOMEM;
 
 	/*
 	 * old style build-id cache has name of XX/XXXXXXX.. while
@@ -2732,7 +2732,7 @@ int symbol__annotate2(struct symbol *sym, struct map *map, struct perf_evsel *ev
 
 	notes->offsets = zalloc(size * sizeof(struct annotation_line *));
 	if (notes->offsets == NULL)
-		return -1;
+		return ENOMEM;
 
 	if (perf_evsel__is_group_event(evsel))
 		nr_pcnt = evsel->nr_members;
-- 
2.20.1



