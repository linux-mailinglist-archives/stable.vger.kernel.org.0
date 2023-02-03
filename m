Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C701689630
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjBCKaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjBCK3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:29:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0FDA2A44
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:28:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64411B82A6B
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFBCC433D2;
        Fri,  3 Feb 2023 10:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420093;
        bh=tMi/I2IQP7Y1fVtCtwAubQHLyulTqFBBke+i7It+p7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTXXpkcB7rVaYNBDzF1/s2mfiMNa7FpRBKEzosQn/qA5B9I1sAf6noqhkhSMMuRbB
         Ns2IcFxdbyX3C3CMZDaBaYUFfQhEQbp90Oq0DBPjzd43yeecytH3k27vYayAw4viLc
         gVHX3MupZwFRiE48IywUoNmRpziPjuB1v9bmH/CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 077/134] ftrace/scripts: Update the instructions for ftrace-bisect.sh
Date:   Fri,  3 Feb 2023 11:13:02 +0100
Message-Id: <20230203101027.326234440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 7ae4ba7195b1bac04a4210a499da9d8c63b0ba9c upstream.

The instructions for the ftrace-bisect.sh script, which is used to find
what function is being traced that is causing a kernel crash, and possibly
a triple fault reboot, uses the old method. In 5.1, a new feature was
added that let the user write in the index into available_filter_functions
that maps to the function a user wants to set in set_ftrace_filter (or
set_ftrace_notrace). This takes O(1) to set, as suppose to writing a
function name, which takes O(n) (where n is the number of functions in
available_filter_functions).

The ftrace-bisect.sh requires setting half of the functions in
available_filter_functions, which is O(n^2) using the name method to enable
and can take several minutes to complete. The number method is O(n) which
takes less than a second to complete. Using the number method for any
kernel 5.1 and after is the proper way to do the bisect.

Update the usage to reflect the new change, as well as using the
/sys/kernel/tracing path instead of the obsolete debugfs path.

Link: https://lkml.kernel.org/r/20230123112252.022003dd@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Fixes: f79b3f338564e ("ftrace: Allow enabling of filters via index of available_filter_functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/tracing/ftrace-bisect.sh |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/scripts/tracing/ftrace-bisect.sh
+++ b/scripts/tracing/ftrace-bisect.sh
@@ -12,7 +12,7 @@
 #   (note, if this is a problem with function_graph tracing, then simply
 #    replace "function" with "function_graph" in the following steps).
 #
-#  # cd /sys/kernel/debug/tracing
+#  # cd /sys/kernel/tracing
 #  # echo schedule > set_ftrace_filter
 #  # echo function > current_tracer
 #
@@ -20,22 +20,40 @@
 #
 #  # echo nop > current_tracer
 #
-#  # cat available_filter_functions > ~/full-file
+# Starting with v5.1 this can be done with numbers, making it much faster:
+#
+# The old (slow) way, for kernels before v5.1.
+#
+# [old-way] # cat available_filter_functions > ~/full-file
+#
+# [old-way] *** Note ***  this process will take several minutes to update the
+# [old-way] filters. Setting multiple functions is an O(n^2) operation, and we
+# [old-way] are dealing with thousands of functions. So go have coffee, talk
+# [old-way] with your coworkers, read facebook. And eventually, this operation
+# [old-way] will end.
+#
+# The new way (using numbers) is an O(n) operation, and usually takes less than a second.
+#
+# seq `wc -l available_filter_functions | cut -d' ' -f1` > ~/full-file
+#
+# This will create a sequence of numbers that match the functions in
+# available_filter_functions, and when echoing in a number into the
+# set_ftrace_filter file, it will enable the corresponding function in
+# O(1) time. Making enabling all functions O(n) where n is the number of
+# functions to enable.
+#
+# For either the new or old way, the rest of the operations remain the same.
+#
 #  # ftrace-bisect ~/full-file ~/test-file ~/non-test-file
 #  # cat ~/test-file > set_ftrace_filter
 #
-# *** Note *** this will take several minutes. Setting multiple functions is
-# an O(n^2) operation, and we are dealing with thousands of functions. So go
-# have  coffee, talk with your coworkers, read facebook. And eventually, this
-# operation will end.
-#
 #  # echo function > current_tracer
 #
 # If it crashes, we know that ~/test-file has a bad function.
 #
 #   Reboot back to test kernel.
 #
-#     # cd /sys/kernel/debug/tracing
+#     # cd /sys/kernel/tracing
 #     # mv ~/test-file ~/full-file
 #
 # If it didn't crash.


