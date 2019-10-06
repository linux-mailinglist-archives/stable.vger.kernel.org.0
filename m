Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA967CD72F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfJFRhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbfJFRhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:37:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FDF721479;
        Sun,  6 Oct 2019 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383424;
        bh=YGkScx/jhGS2Nre6fZSEF/CTkWusNS3dmBmk4gEMASw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM+sPkttkYrZ5bbMIgI/5hW0SPIde7DEO7HTbTTz0pm3zzJheCXm0RgZ1HU+0tzwa
         N1YirJlwpQaeRkBXbbnGyjSzjK3BKzupj3RybEletbhMFXL/kIRUZleFVvQUaiCpKH
         BA+gyQY7SEZ5xpgjKBKDt4PVit/QDQzzfn5IfV8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 100/137] livepatch: Nullify obj->mod in klp_module_coming()s error path
Date:   Sun,  6 Oct 2019 19:21:24 +0200
Message-Id: <20191006171217.241438193@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
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
index c4ce08f43bd63..ab4a4606d19b7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1175,6 +1175,7 @@ err:
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.20.1



