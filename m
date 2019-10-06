Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D6CD840
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfJFR0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbfJFR0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:26:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9786320867;
        Sun,  6 Oct 2019 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382773;
        bh=GofdUfSQXIx0DjaZGvqWXBDxkWOXKOib6pKnwDPKu3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juXSnZSRA/psNmyiX5qdA6qXIousfPQLZbSxwZInnr/4wd6lFIb4FsQf84q7JqxXc
         rMQ9x1Tl8DC0JsvP1QdruIOVcE2Iy+Iuu4VcWe7YLybOTl1zb56tCQA3a7UNVV/A5O
         ZBKAW4TjzPI1AMveVUQvTA8r5AfqkdWJMA2vdCps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/68] livepatch: Nullify obj->mod in klp_module_coming()s error path
Date:   Sun,  6 Oct 2019 19:21:09 +0200
Message-Id: <20191006171124.321287020@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

[ Upstream commit 4ff96fb52c6964ad42e0a878be8f86a2e8052ddd ]

klp_module_coming() is called for every module appearing in the system.
It sets obj->mod to a patched module for klp_object obj. Unfortunately
it leaves it set even if an error happens later in the function and the
patched module is not allowed to be loaded.

klp_is_object_loaded() uses obj->mod variable and could currently give a
wrong return value. The bug is probably harmless as of now.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/livepatch/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 88754e9790f9b..f8dc77b18962c 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -941,6 +941,7 @@ err:
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.20.1



