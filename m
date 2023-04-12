Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107C46DEFAF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDLIxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjDLIxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5785B93EA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 722B663176
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B45BC433D2;
        Wed, 12 Apr 2023 08:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289548;
        bh=KWC4I4EMt7wAag3IpbqLcsuMvMad7yvicpsrw1qUVt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYtngLbmdhcbCawwD05Q8Ae42WAlU2iIIIf+RpaXB/mnwZXkqhE75WWx75m3+ugrc
         bp/oodqU/iAUFFV5mWPeo8SkJ8CUDUF+I8mzT9xhb+NZR7Lti4lHjUjHsP4jFOrkBw
         OnJsQ7lPVJ0Wc2L79+VlPKmvD83eZTelt5NDsQvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        kernel test robot <lkp@intel.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.2 141/173] tracing/synthetic: Make lastcmd_mutex static
Date:   Wed, 12 Apr 2023 10:34:27 +0200
Message-Id: <20230412082843.799762411@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 31c683967174b487939efaf65e41f5ff1404e141 upstream.

The lastcmd_mutex is only used in trace_events_synth.c and should be
static.

Link: https://lore.kernel.org/linux-trace-kernel/202304062033.cRStgOuP-lkp@intel.com/
Link: https://lore.kernel.org/linux-trace-kernel/20230406111033.6e26de93@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Fixes: 4ccf11c4e8a8e ("tracing/synthetic: Fix races on freeing last_cmd")
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -44,7 +44,7 @@ enum { ERRORS };
 
 static const char *err_text[] = { ERRORS };
 
-DEFINE_MUTEX(lastcmd_mutex);
+static DEFINE_MUTEX(lastcmd_mutex);
 static char *last_cmd;
 
 static int errpos(const char *str)


