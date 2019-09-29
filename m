Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA7FC16FF
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfI2Rek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbfI2Rek (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19EE21D7A;
        Sun, 29 Sep 2019 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778479;
        bh=28EPEBeuVuP6Khqm6zlfvXCAwy4C7eBB7QJBK6lTiqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFg7/nZQU19uettwodGd+pBvIjhjy0wvcoZaOQJBt9RSXMG8Wvtb2xq2WoibZhgs4
         sIZwyX4qTEG2fq+Bu9HV/vubJWQFliCxNDTqN26/1Hr5c9SZtEy+2W+zRmprvevHlw
         miRaTz4CYDaK0XtKRRG+YBiNLae9Xsajy5OcdvpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>, live-patching@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/33] livepatch: Nullify obj->mod in klp_module_coming()'s error path
Date:   Sun, 29 Sep 2019 13:33:56 -0400
Message-Id: <20190929173424.9361-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
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
index 722c27c40e5b3..a1250ad591c1d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1027,6 +1027,7 @@ int klp_module_coming(struct module *mod)
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.20.1

