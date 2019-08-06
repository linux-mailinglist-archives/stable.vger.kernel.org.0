Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8AAF83C04
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfHFVh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfHFVhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:37:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7423B20C01;
        Tue,  6 Aug 2019 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127444;
        bh=Iq98oOKoHJJwRc5AANOrAlLmSZS5/8uWOUXH8bP2Zho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXdjxR1aIr/Ez58JU4rXeAlQC2AfYhtsoMf5vyG8wyonkDnghbPILzsI+jiN48pmK
         Z/DOTTpWUnAFR0VK7pjD5yCmaF7l9WMENx48kJNxjnClfFcEDlgG+Wb6LnFD/KPRc2
         buYAE/O2ykppX/LZCkK/1KkDDsXAYcIeci4MMeAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 04/17] perf header: Fix divide by zero error if f_header.attr_size==0
Date:   Tue,  6 Aug 2019 17:37:01 -0400
Message-Id: <20190806213715.20487-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213715.20487-1-sashal@kernel.org>
References: <20190806213715.20487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vince Weaver <vincent.weaver@maine.edu>

[ Upstream commit 7622236ceb167aa3857395f9bdaf871442aa467e ]

So I have been having lots of trouble with hand-crafted perf.data files
causing segfaults and the like, so I have started fuzzing the perf tool.

First issue found:

If f_header.attr_size is 0 in the perf.data file, then perf will crash
with a divide-by-zero error.

Committer note:

Added a pr_err() to tell the user why the command failed.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.21.1907231100440.14532@macbook-air
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 283148104ffbe..693dcd4ea6a38 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2854,6 +2854,13 @@ int perf_session__read_header(struct perf_session *session)
 			   file->path);
 	}
 
+	if (f_header.attr_size == 0) {
+		pr_err("ERROR: The %s file's attr size field is 0 which is unexpected.\n"
+		       "Was the 'perf record' command properly terminated?\n",
+		       data->file.path);
+		return -EINVAL;
+	}
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
-- 
2.20.1

