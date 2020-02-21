Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7483167285
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731412AbgBUIEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731588AbgBUIEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:04:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9ECF222C4;
        Fri, 21 Feb 2020 08:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272254;
        bh=J6ZA5zhmLHjSnqGLjJAepvomCyU6cfVMPbDp9X4Wd9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNPIU845KRNMHL0SE6X9Fwp5cFY8Q7fydRM8e2zzL2vB3ZgPmp1SSIrgEQXUvnkew
         2jPMilzV1/POAVGNoRY371BKUSq/pXCbnLHt/jAz5DeEpI5gLAtE8onIurs8M4ssw7
         Blum5K0s4KuK/0hfFdv7zuzVN4bf6Fl/wiKfLdLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/344] tracing: Fix tracing_stat return values in error handling paths
Date:   Fri, 21 Feb 2020 08:37:53 +0100
Message-Id: <20200221072355.716162238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <luis.henriques@canonical.com>

[ Upstream commit afccc00f75bbbee4e4ae833a96c2d29a7259c693 ]

tracing_stat_init() was always returning '0', even on the error paths.  It
now returns -ENODEV if tracing_init_dentry() fails or -ENOMEM if it fails
to created the 'trace_stat' debugfs directory.

Link: http://lkml.kernel.org/r/1410299381-20108-1-git-send-email-luis.henriques@canonical.com

Fixes: ed6f1c996bfe4 ("tracing: Check return value of tracing_init_dentry()")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
[ Pulled from the archeological digging of my INBOX ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_stat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 9ab0a1a7ad5ee..1257dc6c07796 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -282,18 +282,22 @@ static int tracing_stat_init(void)
 
 	d_tracing = tracing_init_dentry();
 	if (IS_ERR(d_tracing))
-		return 0;
+		return -ENODEV;
 
 	stat_dir = tracefs_create_dir("trace_stat", d_tracing);
-	if (!stat_dir)
+	if (!stat_dir) {
 		pr_warn("Could not create tracefs 'trace_stat' entry\n");
+		return -ENOMEM;
+	}
 	return 0;
 }
 
 static int init_stat_file(struct stat_session *session)
 {
-	if (!stat_dir && tracing_stat_init())
-		return -ENODEV;
+	int ret;
+
+	if (!stat_dir && (ret = tracing_stat_init()))
+		return ret;
 
 	session->file = tracefs_create_file(session->ts->name, 0644,
 					    stat_dir,
-- 
2.20.1



