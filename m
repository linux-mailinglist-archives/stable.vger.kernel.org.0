Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59632DEEF3
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgLSM4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgLSM4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:56:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 02/16] ktest.pl: If size of log is too big to email, email error message
Date:   Sat, 19 Dec 2020 13:57:09 +0100
Message-Id: <20201219125339.197932744@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
References: <20201219125339.066340030@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 8cd6bc0359deebd8500e6de95899a8a78d3ec4ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/ktest/ktest.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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


