Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF481541DCC
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385492AbiFGWVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383736AbiFGWSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5026273B;
        Tue,  7 Jun 2022 12:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1941B823D5;
        Tue,  7 Jun 2022 19:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555E8C385A5;
        Tue,  7 Jun 2022 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629607;
        bh=Tem+o6lhnk3u6n4qq+jmQ3aT0Hf1azAIzJZfIeFJADE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeIXa9DbexgVV1DXzlCyGSnQYUDu/4NZv+TlKvMvdonWREJhi1ShLaO6/KIcJ9g9P
         w3w5N+QMirscn5bmaZKB5cs1d52yrSUYayywna25cHoyqgeeCJefqQ5U/EnncMo2Xx
         0etH81JtKKtxSV65VaP7eWA/SJ+niPTUv4dqMW7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Baik Song An <bsahn@etri.re.kr>,
        Hong Yeon Kim <kimhy@etri.re.kr>,
        Taeung Song <taeung@reallinux.co.kr>, linuxgeek@linuxgeek.io,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.18 751/879] tracing: Fix return value of trace_pid_write()
Date:   Tue,  7 Jun 2022 19:04:29 +0200
Message-Id: <20220607165024.659732528@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wonhyuk Yang <vvghjk1234@gmail.com>

commit b27f266f74fbda4ee36c2b2b04d15992860cf23b upstream.

Setting set_event_pid with trailing whitespace lead to endless write
system calls like below.

    $ strace echo "123 " > /sys/kernel/debug/tracing/set_event_pid
    execve("/usr/bin/echo", ["echo", "123 "], ...) = 0
    ...
    write(1, "123 \n", 5)                   = 4
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    write(1, "\n", 1)                       = 0
    ....

This is because, the result of trace_get_user's are not returned when it
read at least one pid. To fix it, update read variable even if
parser->idx == 0.

The result of applied patch is below.

    $ strace echo "123 " > /sys/kernel/debug/tracing/set_event_pid
    execve("/usr/bin/echo", ["echo", "123 "], ...) = 0
    ...
    write(1, "123 \n", 5)                   = 5
    close(1)                                = 0

Link: https://lkml.kernel.org/r/20220503050546.288911-1-vvghjk1234@gmail.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Baik Song An <bsahn@etri.re.kr>
Cc: Hong Yeon Kim <kimhy@etri.re.kr>
Cc: Taeung Song <taeung@reallinux.co.kr>
Cc: linuxgeek@linuxgeek.io
Cc: stable@vger.kernel.org
Fixes: 4909010788640 ("tracing: Add set_event_pid directory for future use")
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -721,13 +721,16 @@ int trace_pid_write(struct trace_pid_lis
 		pos = 0;
 
 		ret = trace_get_user(&parser, ubuf, cnt, &pos);
-		if (ret < 0 || !trace_parser_loaded(&parser))
+		if (ret < 0)
 			break;
 
 		read += ret;
 		ubuf += ret;
 		cnt -= ret;
 
+		if (!trace_parser_loaded(&parser))
+			break;
+
 		ret = -EINVAL;
 		if (kstrtoul(parser.buffer, 0, &val))
 			break;
@@ -753,7 +756,6 @@ int trace_pid_write(struct trace_pid_lis
 	if (!nr_pids) {
 		/* Cleared the list of pids */
 		trace_pid_list_free(pid_list);
-		read = ret;
 		pid_list = NULL;
 	}
 


