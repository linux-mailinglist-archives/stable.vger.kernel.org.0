Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D0BCAB43
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389493AbfJCRTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388457AbfJCQTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:19:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1589220865;
        Thu,  3 Oct 2019 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119563;
        bh=nrvU+TCofrQxh44dgJtqKNLuAH30NreF7C0BN1Tm5+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZU869fvbZwslV3lxe/DrUSsOISH4kqIYiSzyBgYE7tgf9YsN3t0+b+cV//PzUW/5
         FFHRISMwP5nL/H5lxIB2oWcXo9FOQ16iSW+FbyI7/EzbzQKJcasaBz5806AoOeAMGs
         cD22DbXpxVETKniJ8m9ymM1KaSD52I2PL9TO2MC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tan Xiaojun <tanxiaojun@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/211] perf record: Support aarch64 random socket_id assignment
Date:   Thu,  3 Oct 2019 17:52:20 +0200
Message-Id: <20191003154504.715208544@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tan Xiaojun <tanxiaojun@huawei.com>

[ Upstream commit 0a4d8fb229dd78f9e0752817339e19e903b37a60 ]

Same as in the commit 01766229533f ("perf record: Support s390 random
socket_id assignment"), aarch64 also have this problem.

Without this fix:

  [root@localhost perf]# ./perf report --header -I -v
  ...
  socket_id number is too big.You may need to upgrade the perf tool.

  # ========
  # captured on    : Thu Aug  1 22:58:38 2019
  # header version : 1
  ...
  # Core ID and Socket ID information is not available
  ...

With this fix:
  [root@localhost perf]# ./perf report --header -I -v
  ...
  cpumask list: 0-31
  cpumask list: 32-63
  cpumask list: 64-95
  cpumask list: 96-127

  # ========
  # captured on    : Thu Aug  1 22:58:38 2019
  # header version : 1
  ...
  # CPU 0: Core ID 0, Socket ID 36
  # CPU 1: Core ID 1, Socket ID 36
  ...
  # CPU 126: Core ID 126, Socket ID 8442
  # CPU 127: Core ID 127, Socket ID 8442
  ...

Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Link: http://lkml.kernel.org/r/1564717737-21602-1-git-send-email-tanxiaojun@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 54c34c107cab5..0c70788593c8d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2184,8 +2184,10 @@ static int process_cpu_topology(struct feat_fd *ff, void *data __maybe_unused)
 	/* On s390 the socket_id number is not related to the numbers of cpus.
 	 * The socket_id number might be higher than the numbers of cpus.
 	 * This depends on the configuration.
+	 * AArch64 is the same.
 	 */
-	if (ph->env.arch && !strncmp(ph->env.arch, "s390", 4))
+	if (ph->env.arch && (!strncmp(ph->env.arch, "s390", 4)
+			  || !strncmp(ph->env.arch, "aarch64", 7)))
 		do_core_id_test = false;
 
 	for (i = 0; i < (u32)cpu_nr; i++) {
-- 
2.20.1



