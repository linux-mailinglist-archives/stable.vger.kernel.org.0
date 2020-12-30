Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4AC2E7926
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgL3NG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbgL3NF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F8922A84;
        Wed, 30 Dec 2020 13:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333479;
        bh=APu/jXmOcUT+ePEqtPNGTJWpAn5vwcWurH2AbSLSO68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4huVitka3gKsCA+2v752DIn9nKvYk+IDwWMhoLeK0fROFQ7uLHPrdfx9tqJ05UY2
         mxyi7VMhhKGU/N55tEYgKX7FcBh2Tggso2Mt/hoSt493hM/c7wXGKWsZ7PUjYVwbHK
         KhfvW1+ycuh2frvuY7B76zIT9inqYpIp+ADtr4uMZGnQNRZmdHV4mf1ICGvnN60vU6
         P3ne1bQunXHdcbKpilGDi1zHcrIeXZbxvbylXfPUX8uVAopzNnU5naTTjYIRffNPp1
         k5qfJVzq5MzZ1TvNDzeLZBAdq+cMAEg92dC4VkBO6UnIMTRJYh8JxeaKR7COQ+SrJf
         4jNBSeAQXacGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 2/8] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Wed, 30 Dec 2020 08:04:30 -0500
Message-Id: <20201230130436.3637579-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130436.3637579-1-sashal@kernel.org>
References: <20201230130436.3637579-1-sashal@kernel.org>
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
index 2806c9b6577c1..c4f0a8fe144e1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3801,6 +3801,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
  bug_cleanup:
+	mod->state = MODULE_STATE_GOING;
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-- 
2.27.0

