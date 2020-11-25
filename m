Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217BC2C438A
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgKYPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbgKYPiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:38:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F48021D91;
        Wed, 25 Nov 2020 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318696;
        bh=p56lrdY5ZhqQEjuwgoXjBLvEgDUWDJPeSLi/zSLGKIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cS3HRlE9oRbCP+T/0fKjGoTduqXCpo5zL6X6RH45oriuRabyrinbhU4cMwoLlliLO
         CAp+U6Bpv2Nz2GYmPSome2reOon7tOkijUuhLF5l2ok3474bfLsUyMKC8ft+ZPswTq
         f3wWMA66d6sUOd4y9YAurquvZoj1wG/VOb065GF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/8] proc: don't allow async path resolution of /proc/self components
Date:   Wed, 25 Nov 2020 10:38:05 -0500
Message-Id: <20201125153808.811104-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153808.811104-1-sashal@kernel.org>
References: <20201125153808.811104-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

