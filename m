Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A02E795A
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgL3NIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgL3NFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89792242A;
        Wed, 30 Dec 2020 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333467;
        bh=6aoK4ekmIni/MV8SXsbkIAnDm06vg+awXmScef8Y1MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMxT3F0fr/v4YBb2aIy805fRZ6rCabdUkTkv7yGVcCnoUNFLQz86nss3bAhDZZZS4
         RvNSan7nRpU2lMDsE6xKsaem187+Xdd2inWactFevstLotHK3HfzkH+9zs9eWKHTVb
         knmZXOCvQBqRLNGI6l4TFckGek0z39VHiWMPC1ERvjwwFRRWu2jsuAwhh/rGpweSql
         gg+6aRPwERy7LAIz+ixynwaYUEZKs7Ut1NJmjvmK0BaZ+sx1ZD32TnPhKwZ33rVAE4
         SKXEIrOYZLR9CcPc72hwCFoy+RXrTXm6chfZdGfcwTt56Q/Z215PuRjNzlqRJK++0x
         Cccm4a3MI9pBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 03/10] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Wed, 30 Dec 2020 08:04:15 -0500
Message-Id: <20201230130422.3637448-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130422.3637448-1-sashal@kernel.org>
References: <20201230130422.3637448-1-sashal@kernel.org>
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
index d05e1bfdd3559..8dbe0ff22134e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3841,6 +3841,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
  bug_cleanup:
+	mod->state = MODULE_STATE_GOING;
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-- 
2.27.0

