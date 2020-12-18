Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4052DE799
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgLRQqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 11:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbgLRQqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Dec 2020 11:46:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B5523B28;
        Fri, 18 Dec 2020 16:45:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kqIsc-0019XE-Hz; Fri, 18 Dec 2020 11:45:22 -0500
Message-ID: <20201218164522.337181702@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 18 Dec 2020 11:44:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     "John Warthog9 Hawley" <warthog9@kernel.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 1/2] ktest.pl: If size of log is too big to email, email error message
References: <20201218164442.597085865@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the size of the error log is too big to send via email, and the sending
fails, it wont email any result. This can be confusing for the user who is
waiting for an email on the completion of the tests.

If it fails to send email, then try again without the log file stating that
it failed to send an email. Obviously this will not be of use if the sending
of email failed for some other reasons, but it will at least give the user
some information when it fails for the most common reason.

Cc: stable@vger.kernel.org
Fixes: c2d84ddb338c8 ("ktest.pl: Add MAIL_COMMAND option to define how to send email")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 54188ee16c48..54f7d008e840 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4253,7 +4253,12 @@ sub do_send_mail {
     $mail_command =~ s/\$SUBJECT/$subject/g;
     $mail_command =~ s/\$MESSAGE/$message/g;
 
-    run_command $mail_command;
+    my $ret = run_command $mail_command;
+    if (!$ret && defined($file)) {
+	# try again without the file
+	$message .= "\n\n*** FAILED TO SEND LOG ***\n\n";
+	do_send_email($subject, $message);
+    }
 }
 
 sub send_email {
-- 
2.29.2


