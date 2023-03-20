Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202596C0E61
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCTKMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCTKMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:12:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C66A70
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75314CE1130
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3442C433AE;
        Mon, 20 Mar 2023 10:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307125;
        bh=VpOPbPCgeZiMhZfr+/1JXhiHjGV5C/rk46n/r3ln0J8=;
        h=Subject:To:Cc:From:Date:From;
        b=nqlA8mU6a5VK5d+RqmYQcJQiAPvYtR1bEtSFM12WaXZ9MN9/j2rtvPZ1u9u4TGC/l
         XNj0cZvJilHFKu7eOUTjOPa7K0KXW2PtFN93iyRg3Be50bfcXPK4FgrGI3kUBjzaod
         aKKwOvBF9vmW0zfM4KA5OvrgvF6vVPAP1xje7xfA=
Subject: FAILED: patch "[PATCH] tracing: Check field value in hist_field_name()" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, akpm@linux-foundation.org,
        mark.rutland@arm.com, mhiramat@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:12:02 +0100
Message-ID: <1679307122237220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 9f116f76fa8c04c81aef33ad870dbf9a158e5b70
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679307122237220@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

9f116f76fa8c ("tracing: Check field value in hist_field_name()")
85013256cf01 ("tracing: Add hist_field_name() accessor")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f116f76fa8c04c81aef33ad870dbf9a158e5b70 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Wed, 1 Mar 2023 20:00:53 -0500
Subject: [PATCH] tracing: Check field value in hist_field_name()

The function hist_field_name() cannot handle being passed a NULL field
parameter. It should never be NULL, but due to a previous bug, NULL was
passed to the function and the kernel crashed due to a NULL dereference.
Mark Rutland reported this to me on IRC.

The bug was fixed, but to prevent future bugs from crashing the kernel,
check the field and add a WARN_ON() if it is NULL.

Link: https://lkml.kernel.org/r/20230302020810.762384440@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Fixes: c6afad49d127f ("tracing: Add hist trigger 'sym' and 'sym-offset' modifiers")
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 6e8ab726a7b5..486cca3c2b75 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1331,6 +1331,9 @@ static const char *hist_field_name(struct hist_field *field,
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 

