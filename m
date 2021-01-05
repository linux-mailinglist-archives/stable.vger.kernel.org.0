Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CDC2EA775
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbhAEJ3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbhAEJ3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:29:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666CD22A84;
        Tue,  5 Jan 2021 09:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838912;
        bh=6aoK4ekmIni/MV8SXsbkIAnDm06vg+awXmScef8Y1MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0hQc/8BZaKY8bg9whIJoYo9m1x+j29DriK4qFMnflXNs6ezsF2kg+JMxVtv+QI1h
         jIRZCyiOSjMiwS/2DSD/dyTSP8Zm0PJZ7ktJnCHynUEW8XIAOD7YTSOW5z6gKXnFRh
         j3q3ghgdZVtRjyXU8IaYIPF1iLdURn+LxRZcPLp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/29] module: set MODULE_STATE_GOING state when a module fails to load
Date:   Tue,  5 Jan 2021 10:29:09 +0100
Message-Id: <20210105090821.538334680@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
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



