Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EADD2C9CA0
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgLAIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:55:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgLAIzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:55:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FBEF22244;
        Tue,  1 Dec 2020 08:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606812875;
        bh=p56lrdY5ZhqQEjuwgoXjBLvEgDUWDJPeSLi/zSLGKIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKsqCa/jIQMHebZGzKiyqRj4pX5Hjzv5r//G27yUjlvgvedcERPV4SiOc/wm6RwVw
         4FINx0SoGVyNHhQc5c+F/IBaoVfFt7vofMLLUf3cBmoPVCVixAFvJZ76/WBqSZQwwm
         5nnzB4SSCHHougyZVAvyYwDn7Q22aOkZzJRxCz1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/24] proc: dont allow async path resolution of /proc/self components
Date:   Tue,  1 Dec 2020 09:53:14 +0100
Message-Id: <20201201084638.166527632@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084637.754785180@linuxfoundation.org>
References: <20201201084637.754785180@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19 ]

If this is attempted by a kthread, then return -EOPNOTSUPP as we don't
currently support that. Once we can get task_pid_ptr() doing the right
thing, then this can go away again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/self.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index 2dcc2558b3aa7..dffbe533d53fc 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -24,6 +24,13 @@ static const char *proc_self_follow_link(struct dentry *dentry, void **cookie)
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
+	/*
+	 * Not currently supported. Once we can inherit all of struct pid,
+	 * we can allow this.
+	 */
+	if (current->flags & PF_KTHREAD)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	/* 11 for max length of signed int in decimal + NULL term */
-- 
2.27.0



