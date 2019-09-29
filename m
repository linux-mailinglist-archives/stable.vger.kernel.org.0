Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA0C1897
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbfI2Rnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbfI2RbX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B97521927;
        Sun, 29 Sep 2019 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778282;
        bh=pBQwV3mhbv58jsEbhbzwxQUB2adUWroTzKgDObDMn5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DejICp7ElnurRoHzFtHAOkiVgOyapVU1xpaYPbTrRE6X+qnaTJf3KmsZHMHPFtXbm
         /Mk5ihTXVZTPJr2zn8fup07TYZWfuvXEDGot9JiLhsMSzOtR5QpC2ca7FQYW8ruLk4
         8Utt3uDn7cz0a8CYOuTEIp5h2UIGBB+GmUd6Ik2k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>, live-patching@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 13/49] livepatch: Nullify obj->mod in klp_module_coming()'s error path
Date:   Sun, 29 Sep 2019 13:30:13 -0400
Message-Id: <20190929173053.8400-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c4ce08f43bd63..ab4a4606d19b7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1175,6 +1175,7 @@ int klp_module_coming(struct module *mod)
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.20.1

