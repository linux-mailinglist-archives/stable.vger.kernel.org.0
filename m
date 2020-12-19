Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E832DEEF4
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgLSM4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgLSM4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:56:53 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 03/16] ktest.pl: Fix the logic for truncating the size of the log file for email
Date:   Sat, 19 Dec 2020 13:57:10 +0100
Message-Id: <20201219125339.238687837@linuxfoundation.org>
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

commit 170f4869e66275f498ae4736106fb54c0fdcd036 upstream.

The logic for truncating the log file for emailing based on the
MAIL_MAX_SIZE option is confusing and incorrect. Simplify it and have the
tail of the log file truncated to the max size specified in the config.

Cc: stable@vger.kernel.org
Fixes: 855d8abd2e8ff ("ktest.pl: Change the logic to control the size of the log file emailed")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/ktest/ktest.pl |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

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


