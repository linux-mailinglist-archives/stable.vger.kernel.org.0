Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45298475F05
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245672AbhLOR0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbhLORZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E167C061D72;
        Wed, 15 Dec 2021 09:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D285A619EE;
        Wed, 15 Dec 2021 17:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B537CC36AE0;
        Wed, 15 Dec 2021 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589110;
        bh=5wMsU4kwQkGiWgdPJDITvVB5VakPNjIDnkQA+I1wXKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY2s7n0Cb8NQaJ1O98RffjUenbmTOpkVrw0Cr3Ib6xbJhxDbu83doFLFmxwJL/0SD
         9e0m+oRcfNzzgJ14+OFe2b0hDBujU40EQy/XQmTJ88i4DENMfDn3JMH6lpy8Hgsw+N
         LJXrYsv8m3ozNWpWhIiczXeMeK5Yvx04b6MBQIjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 23/33] perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
Date:   Wed, 15 Dec 2021 18:21:21 +0100
Message-Id: <20211215172025.564551949@linuxfoundation.org>
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

commit ad106a26aef3a95ac7ca88d033b431661ba346ce upstream.

When syncing, it may be that branch packet generation is not enabled at
that point, in which case there will not immediately be a control-flow
packet, so some packets before a control flow packet turns up, get
ignored.  However, the decoder is in sync as soon as a PSB is found, so
the state should be set accordingly.

Fixes: f4aa081949e7b6 ("perf tools: Add Intel PT decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2733,7 +2733,7 @@ leap:
 		return err;
 
 	decoder->have_last_ip = true;
-	decoder->pkt_state = INTEL_PT_STATE_NO_IP;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 
 	err = intel_pt_walk_psb(decoder);
 	if (err)


