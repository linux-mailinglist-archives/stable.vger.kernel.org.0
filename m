Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5082C9CBE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbgLAJAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388276AbgLAJAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF871221FF;
        Tue,  1 Dec 2020 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813177;
        bh=c9Opq6kGcTxHdUrCuVg3UmZQJpTW7wDaQAWEf+gQbgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YI9U27TOpksA03CXBN5NkJNPbuwE9fpUW92YEzNE3OC2dxJedNKvdR5nK4RcJXWhm
         cHBaMKXQP8uqxvHjlumlL4V6eHKDW13d3BjgeBUbm/OeL+Psm9+7KM9Vg96YFWgcN7
         YWhkbzaIKQcO20S/AFuC9+DQEK73Zg2GK1kM6gw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Dahl <ada@thorsis.com>
Subject: [PATCH 4.19 01/57] perf event: Check ref_reloc_sym before using it
Date:   Tue,  1 Dec 2020 09:53:06 +0100
Message-Id: <20201201084647.886759183@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Lubashev <ilubashe@akamai.com>

commit e9a6882f267a8105461066e3ea6b4b6b9be1b807 upstream.

Check for ref_reloc_sym before using it instead of checking
symbol_conf.kptr_restrict and relying solely on that check.

Reported-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Igor Lubashev <ilubashe@akamai.com>
Tested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1566869956-7154-2-git-send-email-ilubashe@akamai.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Dahl <ada@thorsis.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/event.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -912,11 +912,13 @@ static int __perf_event__synthesize_kern
 	int err;
 	union perf_event *event;
 
-	if (symbol_conf.kptr_restrict)
-		return -1;
 	if (map == NULL)
 		return -1;
 
+	kmap = map__kmap(map);
+	if (!kmap->ref_reloc_sym)
+		return -1;
+
 	/*
 	 * We should get this from /sys/kernel/sections/.text, but till that is
 	 * available use this, and after it is use this as a fallback for older
@@ -939,7 +941,6 @@ static int __perf_event__synthesize_kern
 		event->header.misc = PERF_RECORD_MISC_GUEST_KERNEL;
 	}
 
-	kmap = map__kmap(map);
 	size = snprintf(event->mmap.filename, sizeof(event->mmap.filename),
 			"%s%s", machine->mmap_name, kmap->ref_reloc_sym->name) + 1;
 	size = PERF_ALIGN(size, sizeof(u64));


