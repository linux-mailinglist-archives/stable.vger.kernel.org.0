Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6A12DE798
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731478AbgLRQqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 11:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgLRQqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Dec 2020 11:46:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5D8223B5D;
        Fri, 18 Dec 2020 16:45:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kqIsc-0019Xi-Of; Fri, 18 Dec 2020 11:45:22 -0500
Message-ID: <20201218164522.595074552@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 18 Dec 2020 11:44:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     "John Warthog9 Hawley" <warthog9@kernel.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 2/2] ktest.pl: Fix the logic for truncating the size of the log file for
 email
References: <20201218164442.597085865@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The logic for truncating the log file for emailing based on the
MAIL_MAX_SIZE option is confusing and incorrect. Simplify it and have the
tail of the log file truncated to the max size specified in the config.

Cc: stable@vger.kernel.org
Fixes: 855d8abd2e8ff ("ktest.pl: Change the logic to control the size of the log file emailed")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 54f7d008e840..4e2450964517 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1499,17 +1499,16 @@ sub dodie {
 	my $log_file;
 
 	if (defined($opt{"LOG_FILE"})) {
-	    my $whence = 0; # beginning of file
-	    my $pos = $test_log_start;
+	    my $whence = 2; # End of file
+	    my $log_size = tell LOG;
+	    my $size = $log_size - $test_log_start;
 
 	    if (defined($mail_max_size)) {
-		my $log_size = tell LOG;
-		$log_size -= $test_log_start;
-		if ($log_size > $mail_max_size) {
-		    $whence = 2; # end of file
-		    $pos = - $mail_max_size;
+		if ($size > $mail_max_size) {
+		    $size = $mail_max_size;
 		}
 	    }
+	    my $pos = - $size;
 	    $log_file = "$tmpdir/log";
 	    open (L, "$opt{LOG_FILE}") or die "Can't open $opt{LOG_FILE} to read)";
 	    open (O, "> $tmpdir/log") or die "Can't open $tmpdir/log\n";
-- 
2.29.2


