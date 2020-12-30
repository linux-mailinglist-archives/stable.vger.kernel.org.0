Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFBC2E7913
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgL3NGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgL3NFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D979223DB;
        Wed, 30 Dec 2020 13:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333496;
        bh=JipiEVOpsmKA7YeR85uaCw0XYUmiNw5ySMl2P3PuHj4=;
        h=From:To:Cc:Subject:Date:From;
        b=a2vREwtEoam/VtYGtLRd9S2peOW9mhw5VEX191zzyuwNWwvOAVLn6Dj7/n6uFy9Pd
         mf+mgdpbArUtqSyqmfE21ktwBJoOz1DccMubo+1Y3iYxTQZ0mwFLkNW5DHItflRYvp
         LIqmL0itcEkHZTFvwZu+C8gXTxpxBQ5OfewzMQUtyfdv35G382fuK+IawCb8vkHeg+
         DNz/1wID0KI1ijauPrnvNv0hzML67unrr4G8FBCKyxUrvCoKch7obwLJCsIySX4Ky5
         jLCUxxLHpLocUqQRNsmidmjTq4XQq8mVA/zxDSoFbC+GwyR7zJG0Miafs0s5oiHT+O
         JTz48UuW2ydig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 1/5] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Wed, 30 Dec 2020 08:04:50 -0500
Message-Id: <20201230130454.3637785-1-sashal@kernel.org>
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
index 2f695b6e1a3e0..dcfc811d9ae2d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3589,6 +3589,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	return do_init_module(mod);
 
  bug_cleanup:
+	mod->state = MODULE_STATE_GOING;
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
 	module_bug_cleanup(mod);
-- 
2.27.0

