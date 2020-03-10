Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE617FDAA
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgCJN3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgCJMvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D8402468E;
        Tue, 10 Mar 2020 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844714;
        bh=uGyKNZJ9mfuzQG98Mnx6jhEwYZqdm+zI0xUevAxUfhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNiWCMOWHqgEQ9PEGMZLKcJSuywpiVDIvIxhmaXG8iCp/9BrT2gPVSKwu6+IE8msx
         AcDxPdfYc4cNGmHC6qTnijeLwvK8uupyUEoDosB1OiNErg9IkEOJNGIEAAzUUbtiNz
         S0ELnTs4Em03zwHnDgvVPKkLb4dsNUBK6DJu/o94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 092/168] perf intel-pt: Fix endless record after being terminated
Date:   Tue, 10 Mar 2020 13:38:58 +0100
Message-Id: <20200310123644.620521320@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

commit 2da4dd3d6973ffdfba4fa07f53240fda7ab22929 upstream.

In __cmd_record(), when receiving SIGINT(ctrl + c), a 'done' flag will
be set and the event list will be disabled by evlist__disable() once.

While in auxtrace_record.read_finish(), the related events will be
enabled again, if they are continuous, the recording seems to be endless.

If the intel_pt event is disabled, we don't enable it again here.

Before the patch:

  huawei@huawei-2288H-V5:~/linux-5.5-rc4/tools/perf$ ./perf record -e \
  intel_pt//u -p 46803
  ^C^C^C^C^C^C

After the patch:

  huawei@huawei-2288H-V5:~/linux-5.5-rc4/tools/perf$ ./perf record -e \
  intel_pt//u -p 48591
  ^C[ perf record: Woken up 0 times to write data ]
  Warning:
  AUX data lost 504 times out of 4816!

  [ perf record: Captured and wrote 2024.405 MB perf.data ]

Signed-off-by: Wei Li <liwei391@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-2-adrian.hunter@intel.com
[ ahunter: removed redundant 'else' after 'return' ]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/arch/x86/util/intel-pt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -1099,9 +1099,12 @@ static int intel_pt_read_finish(struct a
 	struct evsel *evsel;
 
 	evlist__for_each_entry(ptr->evlist, evsel) {
-		if (evsel->core.attr.type == ptr->intel_pt_pmu->type)
+		if (evsel->core.attr.type == ptr->intel_pt_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(ptr->evlist, evsel,
 							     idx);
+		}
 	}
 	return -EINVAL;
 }


