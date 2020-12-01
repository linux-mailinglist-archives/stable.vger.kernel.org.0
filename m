Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829E82C9A9B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbgLAI7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388094AbgLAI7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:59:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B2021D7F;
        Tue,  1 Dec 2020 08:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813113;
        bh=S2hOqoDlK5MPvLUKCjduU+DTQ9JNcGnXtpFB+KJ6Wfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5pkbvq+JYrJiGw4+Ky/JdhQ0/jTg6A1LjHLU7i3PnaR27lbXJVKPdqlUrN3gwK1h
         oCO/904NsdkIUH/ouXaJL3WdgaIiR8vYBPBwV5+w6F9HpYPUR+B6u60tzGKmN+zRE9
         mKq4DegdnZJkKKCeJ9aGx3qncYcPdca7wKHnlFIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/50] proc: dont allow async path resolution of /proc/self components
Date:   Tue,  1 Dec 2020 09:53:19 +0100
Message-Id: <20201201084647.650735416@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
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
index 398cdf9a9f0c6..eba167e1700ef 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -15,6 +15,13 @@ static const char *proc_self_get_link(struct dentry *dentry,
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



