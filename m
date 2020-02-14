Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C7515DBC4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgBNPuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730363AbgBNPuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AF022314;
        Fri, 14 Feb 2020 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695408;
        bh=fPl5CA2wmeIK8jarfsPxfk2GQe02TOM2RTLnsYOCum4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/HPU+EiBE6C9xNlcbtLUibnz5fgFYpA+dD8TwLiS45QQ5TQSOhIpbWprbuT8YZP+
         8TkyseSg3lBccH1Oec3XbLxNGe7a/OlDSmG6rqsT9uxZWwmRcy/3Ra7UmM5Sps4uKQ
         E10w4jqspNfgraPXv5c6xoKqwUbXMFhtAa7mIGpM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 056/542] kernel/module: Fix memleak in module_add_modinfo_attrs()
Date:   Fri, 14 Feb 2020 10:40:48 -0500
Message-Id: <20200214154854.6746-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit f6d061d617124abbd55396a3bc37b9bf7d33233c ]

In module_add_modinfo_attrs() if sysfs_create_file() fails
on the first iteration of the loop (so i = 0), we forget to
free the modinfo_attrs.

Fixes: bc6f2a757d52 ("kernel/module: Fix mem leak in module_add_modinfo_attrs")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index b56f3224b161b..8785e31c2dd0f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1781,6 +1781,8 @@ static int module_add_modinfo_attrs(struct module *mod)
 error_out:
 	if (i > 0)
 		module_remove_modinfo_attrs(mod, --i);
+	else
+		kfree(mod->modinfo_attrs);
 	return error;
 }
 
-- 
2.20.1

