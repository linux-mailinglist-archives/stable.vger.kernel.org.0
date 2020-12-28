Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14E32E393D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387886AbgL1NV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387659AbgL1NU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3CDA206ED;
        Mon, 28 Dec 2020 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161640;
        bh=vl8Si2iHFW1qiSh0gt6YoAeGaFNEYL7Fhj2joEczyRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1gXK3vKBtqqsJfk5C3CPcQDyAGNCltecbV+TGTdWvdzkicU6yuY4eEc6Z37n65lK
         OEmFqbjvluTX4mxKMwWcrNZp4jp7mtnbB8YhNuhstKDjss8NSwr81XOJ3hBdJ29T7W
         4y5k7cSIk/HmnNA8XBsiepBlf1tyPS9Uy30sgpBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 038/346] ktest.pl: If size of log is too big to email, email error message
Date:   Mon, 28 Dec 2020 13:45:57 +0100
Message-Id: <20201228124921.626883918@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
@@ -4177,7 +4177,12 @@ sub do_send_mail {
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


