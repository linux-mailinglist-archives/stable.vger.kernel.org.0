Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B212E7905
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgL3NFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbgL3NFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 639A5221FA;
        Wed, 30 Dec 2020 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333489;
        bh=uVGq9nwC6J8YqJjRcnpUKmtlSJAUxYQflmOxDLIE4Z0=;
        h=From:To:Cc:Subject:Date:From;
        b=h4r35IhIJg/1gM2Wlj9GsqEXfRYqCkX4UTAaRhEX2xHRp2KgURyDiRqt7Th8qV/8t
         yPXslMCZTtgIrTQde/IwuHLk8QX3YOig9OIxofKK+FXE3nNnIlOIGuttTZfOLZRhyt
         z+IsY/SJ1fHVZV0W1ISPfK9gxpouZ1gzbZU/WjCO43bjiEXzJMRFn5aR/0/pbWF64u
         Wnp/3PMWYqOcp2z6r0TQHobG+LSbo8kwtGSmRFp5zSiaAW76KdAI9d8zIcSNSZWWRF
         uXDjJQFTDVBgaRZX65ncMqCdoemmfSiZXZOTDLOPKv1nDwaPHL27aF94VC3+DJARCh
         VPthBEQb+Wqyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 1/5] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Wed, 30 Dec 2020 08:04:43 -0500
Message-Id: <20201230130447.3637694-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
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
index 9cb1437151ae7..a106801f1582b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3738,6 +3738,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
  bug_cleanup:
+	mod->state = MODULE_STATE_GOING;
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-- 
2.27.0

