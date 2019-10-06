Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548D1CD4DF
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfJFRaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbfJFRaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:30:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B9C2133F;
        Sun,  6 Oct 2019 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383011;
        bh=DoSnJE+/AIJVHkubvDdh3iKIiYc9vRFb+UuVLRPUBj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ah3djOm4uAHnqP3E0oxHjiW/9kU60tjOjn+PxQ+no7uDAKa1i3P/pZWNfNNdH+H7
         UMGf4OJnDShk+CbFcP/qrPLG9dp/WUShcn1KVTkRMFWdpOEtPZfDfV87n9o+s7B2kF
         xJHj2rxMA/tvLXmXZ2J6rImOs5brq2Cq/ERgzIMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/106] livepatch: Nullify obj->mod in klp_module_coming()s error path
Date:   Sun,  6 Oct 2019 19:21:00 +0200
Message-Id: <20191006171146.174243201@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
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
index 722c27c40e5b3..a1250ad591c1d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1027,6 +1027,7 @@ err:
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.20.1



