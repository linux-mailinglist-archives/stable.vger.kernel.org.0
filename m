Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D388753E608
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiFFMVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbiFFMU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA729753F
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E078E611B8
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93F4C34119;
        Mon,  6 Jun 2022 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518057;
        bh=GHajSNOgHeNe81vArVECI18M84OxJUHEL1rpL8T42V4=;
        h=Subject:To:Cc:From:Date:From;
        b=RyFchqRqi+xX6wGJ17ItuSjm+kNMU9Zc3jjswLW3Htf/1L6F2Xs5DXHSNl0UP0Rz6
         R6QDH+m8AinNxXj82Z7tVx8KK0zS5Tsq3zLwgpWR1cW0/850gc4saWZ8eKvLoY/ikD
         zSyDdeO1gMUHqVXXOOWszaMVY76dFVBHU8xu5Tno=
Subject: FAILED: patch "[PATCH] tracing: Fix return value of trace_pid_write()" failed to apply to 4.9-stable tree
To:     vvghjk1234@gmail.com, bsahn@etri.re.kr, kimhy@etri.re.kr,
        mingo@redhat.com, rostedt@goodmis.org, taeung@reallinux.co.kr
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:20:41 +0200
Message-ID: <165451804148184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b27f266f74fbda4ee36c2b2b04d15992860cf23b Mon Sep 17 00:00:00 2001
From: Wonhyuk Yang <vvghjk1234@gmail.com>
Date: Tue, 3 May 2022 14:05:46 +0900
Subject: [PATCH] tracing: Fix return value of trace_pid_write()

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

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 498ae22d4ffa..4825883b2ffd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -721,13 +721,16 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
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
@@ -753,7 +756,6 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	if (!nr_pids) {
 		/* Cleared the list of pids */
 		trace_pid_list_free(pid_list);
-		read = ret;
 		pid_list = NULL;
 	}
 

