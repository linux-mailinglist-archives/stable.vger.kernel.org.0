Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A145559D9B6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbiHWKAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242892AbiHWJ6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:58:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FEFA1D4A;
        Tue, 23 Aug 2022 01:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E3D5B81C3A;
        Tue, 23 Aug 2022 08:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAE6C433C1;
        Tue, 23 Aug 2022 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244475;
        bh=OiF9Vciiallwzx+M+oH/zhtKHR7aGt/6vvnZGDtF6Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFQSIxUGVQflSEoQWPU7SDJojrP9HrBpgXxlSbXBPw/siSOIZKOlc2onbkfeQ3k8O
         ox2FDtdi8EK5ap5ap+rbXNNVCZmLU9qVak2W6Y1o0txNpnC6dpFj7TCESbg+Uh15iE
         GWC+EjTt4QBL9kLIfy64sAj70ul/V1OjluhlbOtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        kernel-janitors@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 099/244] perf probe: Fix an error handling path in parse_perf_probe_command()
Date:   Tue, 23 Aug 2022 10:24:18 +0200
Message-Id: <20220823080102.334584924@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 4bf6dcaa93bcd083a13c278a91418fe10e6d23a0 upstream.

If a memory allocation fail, we should branch to the error handling path
in order to free some resources allocated a few lines above.

Fixes: 15354d54698648e2 ("perf probe: Generate event name with line number")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: kernel-janitors@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/b71bcb01fa0c7b9778647235c3ab490f699ba278.1659797452.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/probe-event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1775,8 +1775,10 @@ int parse_perf_probe_command(const char
 	if (!pev->event && pev->point.function && pev->point.line
 			&& !pev->point.lazy_line && !pev->point.offset) {
 		if (asprintf(&pev->event, "%s_L%d", pev->point.function,
-			pev->point.line) < 0)
-			return -ENOMEM;
+			pev->point.line) < 0) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/* Copy arguments and ensure return probe has no C argument */


