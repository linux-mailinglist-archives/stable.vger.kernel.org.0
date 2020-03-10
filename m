Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A620B17F8E0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgCJMv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgCJMv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C96922468F;
        Tue, 10 Mar 2020 12:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844717;
        bh=qWAc4lkmnx7MFeaEj37pRCLigJTuMPeW3Vz6mPUmO8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeHllDNN3YvHUsvj4KUVH4AE7afcORrGmzCYzyneHVgAH6xvOalGeCmvGwpBAyeQx
         b/Hd/9NPHEOm4gmnfDOHphte0KY0iatYZmMB5GnSbT4VT70QiY/OmzZSlmWL3VmXee
         mCuAdFuU/S7Ksmki0TIRl4DBxV7P0i7IdE/HxqLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 093/168] perf intel-bts: Fix endless record after being terminated
Date:   Tue, 10 Mar 2020 13:38:59 +0100
Message-Id: <20200310123644.714147403@linuxfoundation.org>
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

commit 783fed2f35e2a6771c8dc6ee29b8c4b9930783ce upstream.

In __cmd_record(), when receiving SIGINT(ctrl + c), a 'done' flag will
be set and the event list will be disabled by evlist__disable() once.

While in auxtrace_record.read_finish(), the related events will be
enabled again, if they are continuous, the recording seems to be
endless.

If the intel_bts event is disabled, we don't enable it again here.

Note: This patch is NOT tested since i don't have such a machine with
intel_bts feature, but the code seems buggy same as arm-spe and
intel-pt.

Signed-off-by: Wei Li <liwei391@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-3-adrian.hunter@intel.com
[ahunter: removed redundant 'else' after 'return']
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/arch/x86/util/intel-bts.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/arch/x86/util/intel-bts.c
+++ b/tools/perf/arch/x86/util/intel-bts.c
@@ -415,9 +415,12 @@ static int intel_bts_read_finish(struct
 	struct evsel *evsel;
 
 	evlist__for_each_entry(btsr->evlist, evsel) {
-		if (evsel->core.attr.type == btsr->intel_bts_pmu->type)
+		if (evsel->core.attr.type == btsr->intel_bts_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(btsr->evlist,
 							     evsel, idx);
+		}
 	}
 	return -EINVAL;
 }


