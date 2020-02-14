Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B015F409
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389073AbgBNSRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730663AbgBNPvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E182467D;
        Fri, 14 Feb 2020 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695465;
        bh=DOLUhkEC2eTUW1gcZrWuJRXsZJDjvKNmWbzUie1rOVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1EL7MpgflCVolCsGcWF7cp9+0YC/cy34Ny/JtBSgsSvTonMylJbOdgeNYBD+gthk
         yrueqGfUGO53x/TJ4jQDjJ5Kqa0xPO0tttXUIbUNNoKCeGnRnIjWNqx9FR1bk4OtOn
         9Up+PY9KBs/02NdCCmcRbOvk6IVWxzwMaMHOYaAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <luis.henriques@canonical.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 101/542] tracing: Fix tracing_stat return values in error handling paths
Date:   Fri, 14 Feb 2020 10:41:33 -0500
Message-Id: <20200214154854.6746-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 874f1274cf999..2b4d6e674d876 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -280,18 +280,22 @@ static int tracing_stat_init(void)
 
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

