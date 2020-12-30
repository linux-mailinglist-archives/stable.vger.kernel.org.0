Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7F2E78E2
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgL3NEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgL3NEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE2222222A;
        Wed, 30 Dec 2020 13:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333399;
        bh=1CGsBUwgP92kK0hfAOxG13/cx7bwhM8eKe/2rxmiqdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc3dx3xLb+FCyuEkXO1wFenbG5Wwu72+ThjSP6z31FRiqK1TCP+tKXoRBdDT8h/br
         UbHJp5vVRypgwQnj8VeyjMSek8EfZuEBieMvOGFK9NJ+KXvnSpJMz0kAKe5bsn8P0W
         0OevlDrK4+b0v3RnDkeexSTQtZXGQwO0b71d50vgl4Ipux1bLZvbfdctKgP5VUGiD2
         sO3Q/X1gV0n1FMcmIuaokZHtupDA31GlShkEOUN+vd7l+gGA9ngZKnZQGim8coCpf4
         6nzt+/fK7s8ZAhpMBh1aUxDpapVMP2NyrfknbNMrmXUtCLUtbSEA+SEFFL1JVO6qq1
         U1sW7dUuEJ7/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 03/31] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Wed, 30 Dec 2020 08:02:45 -0500
Message-Id: <20201230130314.3636961-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

[ Upstream commit 5e8ed280dab9eeabc1ba0b2db5dbe9fe6debb6b5 ]

If a module fails to load due to an error in prepare_coming_module(),
the following error handling in load_module() runs with
MODULE_STATE_COMING in module's state. Fix it by correctly setting
MODULE_STATE_GOING under "bug_cleanup" label.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/module.c b/kernel/module.c
index a4fa44a652a75..b34235082394b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3991,6 +3991,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
  bug_cleanup:
+	mod->state = MODULE_STATE_GOING;
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-- 
2.27.0

