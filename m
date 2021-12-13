Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2102472722
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbhLMJ6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:58:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43310 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239047AbhLMJ43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24F51B80E0C;
        Mon, 13 Dec 2021 09:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672F3C34601;
        Mon, 13 Dec 2021 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389387;
        bh=uB8cIxYoipcCABWNf7cRsg9wS1m0XY4xes92Yctg9kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKANlz9wfiOnotRQf8Jdgjw++q4N59WnEYQAoRo7TqkFEC4SiD8ts8aL8Jl4r3AUF
         E944YomUzhJxCJ1ZvlTbO6AhBCMsRH2QTMclubI1PMJO9KdNqpDy1hfAwrIs+meOV9
         oitRg3PPygSdZmtg7x3YiH7+9mdGcvjyBOf/3DTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 082/171] perf intel-pt: Fix error timestamp setting on the decoder error path
Date:   Mon, 13 Dec 2021 10:29:57 +0100
Message-Id: <20211213092947.820108410@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2510,6 +2510,7 @@ static int intel_pt_run_decoder(struct i
 				ptq->sync_switch = false;
 				intel_pt_next_tid(pt, ptq);
 			}
+			ptq->timestamp = state->est_timestamp;
 			if (pt->synth_opts.errors) {
 				err = intel_ptq_synth_error(ptq, state);
 				if (err)


