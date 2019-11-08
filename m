Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56E5F5501
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389261AbfKHS7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389229AbfKHS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:59:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB81822519;
        Fri,  8 Nov 2019 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239592;
        bh=9iLboRNviI4kP0eBoLnyYVoI/5dVWOoyG59fJ9GyWRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7vI6cVFiK2JTMH94P9FqL5qE6odjL2PWZehWZTInzmNF41jZ0Wc6ZIn6uP9mOvNW
         eLDAv87OCVl8dtSv06zg0V7q9HCdrILgk3MdrzelRM48zPvCcAfjDaWjjtVlxiWxk3
         UWsdSKya37ID9bJ+5tZfDQPtozVWeBD5nqsLGuUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Hu Shiyuan <hushiyuan@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/62] perf kmem: Fix memory leak in compact_gfp_flags()
Date:   Fri,  8 Nov 2019 19:50:02 +0100
Message-Id: <20191108174732.632147123@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 1abecfcaa7bba21c9985e0136fa49836164dd8fd ]

The memory @orig_flags is allocated by strdup(), it is freed on the
normal path, but leak to free on the error path.

Fix this by adding free(orig_flags) on the error path.

Fixes: 0e11115644b3 ("perf kmem: Print gfp flags in human readable string")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/f9e9f458-96f3-4a97-a1d5-9feec2420e07@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 9e693ce4b73b0..ce786f363476e 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -687,6 +687,7 @@ static char *compact_gfp_flags(char *gfp_flags)
 			new = realloc(new_flags, len + strlen(cpt) + 2);
 			if (new == NULL) {
 				free(new_flags);
+				free(orig_flags);
 				return NULL;
 			}
 
-- 
2.20.1



