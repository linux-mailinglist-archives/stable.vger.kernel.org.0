Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2347F2E99DD
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbhADQEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbhADQEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:04:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB48224D2;
        Mon,  4 Jan 2021 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776204;
        bh=1CGsBUwgP92kK0hfAOxG13/cx7bwhM8eKe/2rxmiqdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxBQgPoNFMZaD5vVXdVLB7LmAGusg2zWaEHlMxPS/y4PmsQ63Hpki5YKuaCwmhiqy
         9ZYYX/GNTNIvI6kqy23y/jt8hdwWeQuRFqMKzGPZOg4646FkHNht/VS/Nm9LgsOqKS
         1R00IwdSJSTvaYSdi1ZHjALF3bgoLAhKn09omyO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/63] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Mon,  4 Jan 2021 16:57:33 +0100
Message-Id: <20210104155710.765782069@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



