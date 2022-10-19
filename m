Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3B6043EE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJSLyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiJSLxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:53:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6474624BD3;
        Wed, 19 Oct 2022 04:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC79B822F0;
        Wed, 19 Oct 2022 08:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33E0C433B5;
        Wed, 19 Oct 2022 08:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169207;
        bh=w7qwQBLy+nCzJ16X8E1IqSPvcC1H6D9kimjmDJhC2Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK+C1YqZgnMT2/+V84zyk+A3OSVEYfzdCwoaP3CJewYRrODcVSdKmOPZG4xlvsivd
         49xbPxIGMkdzBIvCdhIiJkB5bi7mmro/DqsKAaigsVP6M4WoesT8W4lRbY13Q4HpQG
         N6gh13cotZO4NrCy34b25Nj8NsLQ07GPea9EONCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Tao Chen <chentao.kernel@linux.alibaba.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 157/862] tracing/eprobe: Fix alloc event dir failed when event name no set
Date:   Wed, 19 Oct 2022 10:24:04 +0200
Message-Id: <20221019083256.907955488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Chen <chentao.kernel@linux.alibaba.com>

commit dc399adecd4e2826868e5d116a58e33071b18346 upstream.

The event dir will alloc failed when event name no set, using the
command:
"echo "e:esys/ syscalls/sys_enter_openat file=\$filename:string"
>> dynamic_events"
It seems that dir name="syscalls/sys_enter_openat" is not allowed
in debugfs. So just use the "sys_enter_openat" as the event name.

Link: https://lkml.kernel.org/r/1664028814-45923-1-git-send-email-chentao.kernel@linux.alibaba.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Linyu Yuan <quic_linyyuan@quicinc.com>
Cc: Tao Chen <chentao.kernel@linux.alibaba.com
Cc: stable@vger.kernel.org
Fixes: 95c104c378dc ("tracing: Auto generate event name when creating a group of events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -968,8 +968,7 @@ static int __trace_eprobe_create(int arg
 	}
 
 	if (!event) {
-		strscpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
-		sanitize_event_name(buf1);
+		strscpy(buf1, sys_event, MAX_EVENT_NAME_LEN);
 		event = buf1;
 	}
 


