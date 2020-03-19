Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E217B18B748
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgCSNP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbgCSNP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6396320787;
        Thu, 19 Mar 2020 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623758;
        bh=emAQ1ks/GIxq65CC1BJLH5x7t0QwPfOxG9+oR7i5p3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDHNb9//AxVPv2HXR4qEMz/qv2DUt02tNDUWZ4U+qIxauNMBE6uAypC2gl0uDftDz
         s3wYMKqYID/D4JmUzqjS9rvP5jxjoMk2oNR4rIFlj65K4d1L/QQbNGHQvr+Tu6R7js
         rrHDzqT6CHxrdm8ZnUrPyIr/mHY8QphE/puJKj7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 44/99] ktest: Add timeout for ssh sync testing
Date:   Thu, 19 Mar 2020 14:03:22 +0100
Message-Id: <20200319123955.231263884@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 4d00fc477a2ce8b6d2b09fb34ef9fe9918e7d434 upstream.

Before rebooting the box, a "ssh sync" is called to the test machine to see
if it is alive or not. But if the test machine is in a partial state, that
ssh may never actually finish, and the ktest test hangs.

Add a 10 second timeout to the sync test, which will fail after 10 seconds
and then cause the test to reboot the test machine.

Cc: stable@vger.kernel.org
Fixes: 6474ace999edd ("ktest.pl: Powercycle the box on reboot if no connection can be made")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1345,7 +1345,7 @@ sub reboot {
 
     } else {
 	# Make sure everything has been written to disk
-	run_ssh("sync");
+	run_ssh("sync", 10);
 
 	if (defined($time)) {
 	    start_monitor;


