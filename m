Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A712472734
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbhLMJ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45818 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238974AbhLMJ4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76266CE0E6B;
        Mon, 13 Dec 2021 09:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232E8C34603;
        Mon, 13 Dec 2021 09:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389372;
        bh=ybFAwcSXdIy4tT/s09golkOAvRym3nZx/tRRa4EusaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWopd8IBUDUWuD8xQdJoAbse8o6FzcRusNZdDAXzsDJbclu7LFHVVMfrx6oc1tILG
         7iCEJjegjPt+iI1QY/RH7o0CzgW7aDqfAXSYbUuO95TbbkO9fc2xR0+6TgdHjUq8xX
         5Az5xqQhfLcJ+nExpSc3c8K8fBY4vuptjupsPwpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 077/171] perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
Date:   Mon, 13 Dec 2021 10:29:52 +0100
Message-Id: <20211213092947.663677024@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -3607,7 +3607,7 @@ static int intel_pt_sync(struct intel_pt
 	}
 
 	decoder->have_last_ip = true;
-	decoder->pkt_state = INTEL_PT_STATE_NO_IP;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 
 	err = intel_pt_walk_psb(decoder);
 	if (err)


