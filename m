Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5472E68D4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgL1M6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbgL1M6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F67208B6;
        Mon, 28 Dec 2020 12:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160253;
        bh=kmKTwJU+y/AriljcmM4AbU3V6gGFjKgHfwPjSqyxeXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ml2Jl+iF0fac/jxFUmwbbHbmUpS+Y5eOlx5+i/lWLpcYn+gahV6ApocxJZ6UgOn/v
         q82NoGxMwowQfr5eytWgAdoi723w4gre+5t4hwacLwJtnwy9aDElTeBnh8BtiIxGWM
         2ZLQ47BpD8H7IS2UtIT/Qzag9SzKFEMonTZBqoPQ=
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
Subject: [PATCH 4.4 091/132] =?UTF-8?q?perf=20record:=20Fix=20memory=20leak=20when=20using=20?= =?UTF-8?q?--user-regs=3D=3F=20to=20list=20registers?=
Date:   Mon, 28 Dec 2020 13:49:35 +0100
Message-Id: <20201228124850.826997087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 4f2c1c255d818..a8865d1c3e818 100644
--- a/tools/perf/util/parse-regs-options.c
+++ b/tools/perf/util/parse-regs-options.c
@@ -40,7 +40,7 @@ parse_regs(const struct option *opt, const char *str, int unset)
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



