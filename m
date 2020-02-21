Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBAF167882
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgBUHpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbgBUHph (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:45:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D850A24656;
        Fri, 21 Feb 2020 07:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271137;
        bh=fPl5CA2wmeIK8jarfsPxfk2GQe02TOM2RTLnsYOCum4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwDBjatH7rm8GTI4r7mOhnUhv4xcKxLuDHXq6i7cbZLoDCTtm0OoA7u0q/sl8K7VR
         VIk1gXjs+zooxGs6hbxW7uRB3//xHZsrNfRY0lso5i6Y/LPE04UEgqWlT277Gughl6
         g3ZVcX7IfN1CRBlveWjwdTx7Cua6BWYEzESSQvbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        YueHaibing <yuehaibing@huawei.com>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 053/399] kernel/module: Fix memleak in module_add_modinfo_attrs()
Date:   Fri, 21 Feb 2020 08:36:18 +0100
Message-Id: <20200221072407.509394798@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



