Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D08283867
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgJEOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgJEOp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071B42137B;
        Mon,  5 Oct 2020 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909121;
        bh=bmW6TavF5t18pyWbvSlHlMYSsFkzlNgIPbx8MmuyRms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfM6XgiLV53fZa0Vnxct94wW/6hz6YS7W43R2cu7bPIXzbo4Xb6qyzG3sXu6lHm/p
         BRWfKyOf4r4/eWWij6dSExrPtH5YYMlGWl0Zc7XeZv7rzrkwppez8hZ8PxXIstHGNr
         XFzgYrMfThalMa7arxPVUY+x3E3QQ0ENbIqhmMkE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/4] ep_create_wakeup_source(): dentry name can change under you...
Date:   Mon,  5 Oct 2020 10:45:16 -0400
Message-Id: <20201005144517.2527627-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144517.2527627-1-sashal@kernel.org>
References: <20201005144517.2527627-1-sashal@kernel.org>
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
index f70df53666ed1..1c9f1486e5cf9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1455,7 +1455,7 @@ static int reverse_path_check(void)
 
 static int ep_create_wakeup_source(struct epitem *epi)
 {
-	const char *name;
+	struct name_snapshot n;
 	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
@@ -1464,8 +1464,9 @@ static int ep_create_wakeup_source(struct epitem *epi)
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

