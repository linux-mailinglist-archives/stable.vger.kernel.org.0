Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7132E4027
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438090AbgL1OV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441252AbgL1OV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB4920731;
        Mon, 28 Dec 2020 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165302;
        bh=BZUg49SXJ9bvdj7cXdmmm46G9A4x6QGtph8VF/n4wwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwI8ZTFFYmTj2P/Opqf2TxysuAqMU8oERZePrc9pYC9f4oRDXIFwPn8CnhCMj5ohS
         TshD34FEi8/iQgbZgOCKO3Yec+xrnH4ZrljcvIo+1RjrpGJcBNO7IjqqH3x0YmUt2W
         ZC4wAR+G6ijpT24aF3aImRiBIo7yj0ZcXWyt1h3k=
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
Subject: [PATCH 5.10 485/717] =?UTF-8?q?perf=20record:=20Fix=20memory=20leak=20when=20using=20?= =?UTF-8?q?--user-regs=3D=3F=20to=20list=20registers?=
Date:   Mon, 28 Dec 2020 13:48:03 +0100
Message-Id: <20201228125044.198705734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index e687497b3aac0..a4a100425b3a2 100644
--- a/tools/perf/util/parse-regs-options.c
+++ b/tools/perf/util/parse-regs-options.c
@@ -54,7 +54,7 @@ __parse_regs(const struct option *opt, const char *str, int unset, bool intr)
 #endif
 				fputc('\n', stderr);
 				/* just printing available regs */
-				return -1;
+				goto error;
 			}
 #ifdef HAVE_PERF_REGS_SUPPORT
 			for (r = sample_reg_masks; r->name; r++) {
-- 
2.27.0



