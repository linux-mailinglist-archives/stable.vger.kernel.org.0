Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9617010E
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgBZOVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 09:21:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57954 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgBZOU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 09:20:56 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j6xYF-00080e-Lm; Wed, 26 Feb 2020 15:20:39 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 577081C2156;
        Wed, 26 Feb 2020 15:20:39 +0100 (CET)
Date:   Wed, 26 Feb 2020 14:20:39 -0000
From:   "tip-bot2 for Wei Li" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf intel-pt: Fix endless record after being terminated
Cc:     Wei Li <liwei391@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, 5.4+@tip-bot2.tec.linutronix.de,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200214132654.20395-2-adrian.hunter@intel.com>
References: <20200214132654.20395-2-adrian.hunter@intel.com>
MIME-Version: 1.0
Message-ID: <158272683905.28353.4992287081120700782.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     2da4dd3d6973ffdfba4fa07f53240fda7ab22929
Gitweb:        https://git.kernel.org/tip/2da4dd3d6973ffdfba4fa07f53240fda7ab22929
Author:        Wei Li <liwei391@huawei.com>
AuthorDate:    Fri, 14 Feb 2020 15:26:50 +02:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Tue, 18 Feb 2020 10:13:29 -03:00

perf intel-pt: Fix endless record after being terminated

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
---
 tools/perf/arch/x86/util/intel-pt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 20df442..be07d68 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -1173,9 +1173,12 @@ static int intel_pt_read_finish(struct auxtrace_record *itr, int idx)
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
