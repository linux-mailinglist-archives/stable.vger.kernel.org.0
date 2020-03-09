Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E98817E9F6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgCIUY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbgCIUYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 16:24:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CC324676;
        Mon,  9 Mar 2020 20:24:52 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jBOxH-00341Q-Na; Mon, 09 Mar 2020 16:24:51 -0400
Message-Id: <20200309202451.571226644@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 09 Mar 2020 16:22:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     "John Warthog9 Hawley" <warthog9@kernel.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 3/4] ktest: Add timeout for ssh sync testing
References: <20200309202231.580868511@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Before rebooting the box, a "ssh sync" is called to the test machine to see
if it is alive or not. But if the test machine is in a partial state, that
ssh may never actually finish, and the ktest test hangs.

Add a 10 second timeout to the sync test, which will fail after 10 seconds
and then cause the test to reboot the test machine.

Cc: stable@vger.kernel.org
Fixes: 6474ace999edd ("ktest.pl: Powercycle the box on reboot if no connection can be made")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6a605ba75dd6..8bdd7253c110 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1383,7 +1383,7 @@ sub reboot {
 
     } else {
 	# Make sure everything has been written to disk
-	run_ssh("sync");
+	run_ssh("sync", 10);
 
 	if (defined($time)) {
 	    start_monitor;
-- 
2.25.0


