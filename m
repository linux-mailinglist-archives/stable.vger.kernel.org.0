Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1DE28382C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgJEOpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgJEOpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F92208B6;
        Mon,  5 Oct 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909107;
        bh=mFnyq0uxT6aNGNU2RGIso9hOeLqRjgPZIYTTWfIpyl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCQj1ulWus65ethmGaTPquIdfQz9M7cscM4ixcYxIdZVwXFmujrwlCp8tLgcoDCEq
         9gqhLhY57su/ZBnCLd0GK/YJWk8r6wAiDujCQLhscHXhk5ng7RGn8zbWehdbtyCft8
         CJ+wiqSuZuoNyN/7ReLwwJiAWRHaIeicLVX5SmsQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 05/12] ep_create_wakeup_source(): dentry name can change under you...
Date:   Mon,  5 Oct 2020 10:44:53 -0400
Message-Id: <20201005144501.2527477-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 3701cb59d892b88d569427586f01491552f377b1 ]

or get freed, for that matter, if it's a long (separately stored)
name.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 16313180e4c16..4df61129566d4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1448,7 +1448,7 @@ static int reverse_path_check(void)
 
 static int ep_create_wakeup_source(struct epitem *epi)
 {
-	const char *name;
+	struct name_snapshot n;
 	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
@@ -1457,8 +1457,9 @@ static int ep_create_wakeup_source(struct epitem *epi)
 			return -ENOMEM;
 	}
 
-	name = epi->ffd.file->f_path.dentry->d_name.name;
-	ws = wakeup_source_register(NULL, name);
+	take_dentry_name_snapshot(&n, epi->ffd.file->f_path.dentry);
+	ws = wakeup_source_register(NULL, n.name.name);
+	release_dentry_name_snapshot(&n);
 
 	if (!ws)
 		return -ENOMEM;
-- 
2.25.1

