Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE82ED1BD
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbhAGORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728910AbhAGORB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE4823371;
        Thu,  7 Jan 2021 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028961;
        bh=JipiEVOpsmKA7YeR85uaCw0XYUmiNw5ySMl2P3PuHj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkaIHGRuKizU8iUafqXF09pXUtiApPD6O5iEfFy611eFZh3gzvkyRDs2nB5WY9Xtg
         y7lGe+v9imdV7bHx6wRNynIcDF5iwCddi+Z2oeJpwITjrB14QDyeSSUTxt+IpVey45
         c/zzHTXdqLkSF16+WhPQ0fxoy0DYpF6KgOymd5M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 15/19] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Thu,  7 Jan 2021 15:16:40 +0100
Message-Id: <20210107140828.298863602@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
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



