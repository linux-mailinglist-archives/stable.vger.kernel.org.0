Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CF82E38FB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgL1NR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731548AbgL1NRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:17:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F93C22AAA;
        Mon, 28 Dec 2020 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161404;
        bh=aFf5JEWVvxQo8R81FyuTXrBlrMNqF3NmYTsE9QYvN8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+uLk2h1fEHUHcrteUIsz3ORPjljCwg8JpmnlOlxzkhGEj2TmnN2FJg+2+B68O5fS
         D+dmiFAsYzcwS1iU9dQoa+SK6wnCgxiZblGFstnoT77rUiuz7WZJ7/lWEFGqr8X2KC
         Z/XrO8EtwzG1cLyVsm+BzSC1rLL6/+suT8eTahx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Zengkai <zhengzengkai@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Li Bin <huawei.libin@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 173/242] =?UTF-8?q?perf=20record:=20Fix=20memory=20leak=20when=20using=20?= =?UTF-8?q?--user-regs=3D=3F=20to=20list=20registers?=
Date:   Mon, 28 Dec 2020 13:49:38 +0100
Message-Id: <20201228124913.216991023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Zengkai <zhengzengkai@huawei.com>

[ Upstream commit 2eb5dd418034ecea2f7031e3d33f2991a878b148 ]

When using 'perf record's option '-I' or '--user-regs=' along with
argument '?' to list available register names, memory of variable 'os'
allocated by strdup() needs to be released before __parse_regs()
returns, otherwise memory leak will occur.

Fixes: bcc84ec65ad1 ("perf record: Add ability to name registers to record")
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20200703093344.189450-1-zhengzengkai@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-regs-options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-regs-options.c b/tools/perf/util/parse-regs-options.c
index e6599e290f467..e5ad120e7f69a 100644
--- a/tools/perf/util/parse-regs-options.c
+++ b/tools/perf/util/parse-regs-options.c
@@ -41,7 +41,7 @@ parse_regs(const struct option *opt, const char *str, int unset)
 				}
 				fputc('\n', stderr);
 				/* just printing available regs */
-				return -1;
+				goto error;
 			}
 			for (r = sample_reg_masks; r->name; r++) {
 				if (!strcasecmp(s, r->name))
-- 
2.27.0



