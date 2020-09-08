Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDBC26189A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbgIHR6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbgIHQMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:12:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A4ED24870;
        Tue,  8 Sep 2020 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580321;
        bh=sWJaq8QYvsce1oJxSLE8SvodMP0gjPjJJzb5HPrDNxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAn2EDB3jWGueXSU5dNYIxv/7COG9ceZy6hGbmaK3MHwsWK4qVDkTKmwPnEL6bVka
         fRVqAhKrWt5qDvF9pH108Ot0sb7ERhz6W0EWgm4m3ufvsRtcGtZszVKIwwWLJinXoe
         MwZ2+Nr0oKk+qeTMeSCaOAgyZo39BGB/Pas6r8zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@arm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/65] perf tools: Correct SNOOPX field offset
Date:   Tue,  8 Sep 2020 17:26:15 +0200
Message-Id: <20200908152218.580691687@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Grant <al.grant@foss.arm.com>

[ Upstream commit 39c0a53b114d0317e5c4e76b631f41d133af5cb0 ]

perf_event.h has macros that define the field offsets in the data_src
bitmask in perf records. The SNOOPX and REMOTE offsets were both 37.

These are distinct fields, and the bitfield layout in perf_mem_data_src
confirms that SNOOPX should be at offset 38.

Committer notes:

This was extracted from a larger patch that also contained kernel
changes.

Fixes: 52839e653b5629bd ("perf tools: Add support for printing new mem_info encodings")
Signed-off-by: Al Grant <al.grant@arm.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/9974f2d0-bf7f-518e-d9f7-4520e5ff1bb0@foss.arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/uapi/linux/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 362493a2f950b..3b733511bb2b3 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -1033,7 +1033,7 @@ union perf_mem_data_src {
 
 #define PERF_MEM_SNOOPX_FWD	0x01 /* forward */
 /* 1 free */
-#define PERF_MEM_SNOOPX_SHIFT	37
+#define PERF_MEM_SNOOPX_SHIFT	38
 
 /* locked instruction */
 #define PERF_MEM_LOCK_NA	0x01 /* not available */
-- 
2.25.1



