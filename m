Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5734413318A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgAGVBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbgAGVBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08026214D8;
        Tue,  7 Jan 2020 21:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430901;
        bh=1Wx8C2XCvaYqkGNttzgM3mP6mB/ZBZD1qkXNpbJxbdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmbnwgnZ+TpNSrSWnJyn1DEDfogNUdxjxCazMw4gwk6zCzpijGkg1n9HJzvi8Nj+u
         FX891KTGA3lYUI4cK3W3o8LLj6EKF0Or8hty6sY/cvLCUuerRqdggzmCUdmmPiSp04
         2zUJ9JDa5W6ud+e45hZJn4XbWtDwxdFjO6oWKDJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.4 143/191] perf callchain: Fix segfault in thread__resolve_callchain_sample()
Date:   Tue,  7 Jan 2020 21:54:23 +0100
Message-Id: <20200107205340.628805216@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit aceb98261ea7d9fe38f9c140c5531f0b13623832 upstream.

Do not dereference 'chain' when it is NULL.

  $ perf record -e intel_pt//u -e branch-misses:u uname
  $ perf report --itrace=l --branch-history
  perf: Segmentation fault

Fixes: e9024d519d89 ("perf callchain: Honour the ordering of PERF_CONTEXT_{USER,KERNEL,etc}")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20191114142538.4097-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2403,7 +2403,7 @@ static int thread__resolve_callchain_sam
 	}
 
 check_calls:
-	if (callchain_param.order != ORDER_CALLEE) {
+	if (chain && callchain_param.order != ORDER_CALLEE) {
 		err = find_prev_cpumode(chain, thread, cursor, parent, root_al,
 					&cpumode, chain->nr - first_call);
 		if (err)


