Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B4615EE8C
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389841AbgBNRlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389728AbgBNQDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BC024654;
        Fri, 14 Feb 2020 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696223;
        bh=J6ZA5zhmLHjSnqGLjJAepvomCyU6cfVMPbDp9X4Wd9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGjJpbcSgc8vbmG39Pp+Hoc3S+qCReTr79KLVyVBozCf8rBcYhT724/e92csOLYof
         Lqh5cXBjrtdS3JA0tWRVDxIdo6Wb2jNtJ594tL1F5h9kIBi4XkVF7W8lYkp/NI6iN8
         A3hxjDul5GdCTznll5HOfBWUS2zfLesDKTZDIe5E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <luis.henriques@canonical.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 086/459] tracing: Fix tracing_stat return values in error handling paths
Date:   Fri, 14 Feb 2020 10:55:36 -0500
Message-Id: <20200214160149.11681-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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

