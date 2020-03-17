Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AD188200
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCQK6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgCQK6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:58:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E9420735;
        Tue, 17 Mar 2020 10:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442718;
        bh=66/bLf6Hi1EaCyAFrklBvcq42gI8ICTXvyQYaCRAOkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FE+jM8ZcjBAlrTvqtbepqjb/7gbPHJr920Bf0T/Eic8P7WUdo2f2JOGj2TScgyfPx
         cAy6irT3AaI/9v5No/yC2UKsW2s150bgNByN/gEtqOkqHup/7CCIldOyZ7Rvs7DEPd
         TZN7BZoGu6n15KAfDK/zr2u8dBN2AhDjR2SqXG2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 57/89] ktest: Add timeout for ssh sync testing
Date:   Tue, 17 Mar 2020 11:55:06 +0100
Message-Id: <20200317103306.457163324@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
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
@@ -1372,7 +1372,7 @@ sub reboot {
 
     } else {
 	# Make sure everything has been written to disk
-	run_ssh("sync");
+	run_ssh("sync", 10);
 
 	if (defined($time)) {
 	    start_monitor;


