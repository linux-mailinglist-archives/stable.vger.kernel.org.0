Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A5E475F0C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbhLOR10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42824 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245693AbhLORZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A16FB82027;
        Wed, 15 Dec 2021 17:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A6EC36AE0;
        Wed, 15 Dec 2021 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589144;
        bh=MbA6CpBOXetaOjPOOd7O1G9xcLFpcFBIwbO7AxokYCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtPjA9FUbMsciCn9P0xFFCvSgSkSXKO2flsB3G5UBo8D+UJdOpY65szJuTLKtxYkh
         6PuJPEIiPBCB/OrUMJcOOKRe0cca56DYertzf814kqUXKH24TRMbvOfi7i4kvyN0Rs
         EffuRa7P8BgU15yMeUuVY/AwS9vfVF/34XZUincQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 28/33] perf intel-pt: Fix error timestamp setting on the decoder error path
Date:   Wed, 15 Dec 2021 18:21:26 +0100
Message-Id: <20211215172025.748329692@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 6665b8e4836caa8023cbc7e53733acd234969c8c upstream.

An error timestamp shows the last known timestamp for the queue, but this
is not updated on the error path. Fix by setting it.

Fixes: f4aa081949e7b6 ("perf tools: Add Intel PT decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-8-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2271,6 +2271,7 @@ static int intel_pt_run_decoder(struct i
 				ptq->sync_switch = false;
 				intel_pt_next_tid(pt, ptq);
 			}
+			ptq->timestamp = state->est_timestamp;
 			if (pt->synth_opts.errors) {
 				err = intel_ptq_synth_error(ptq, state);
 				if (err)


