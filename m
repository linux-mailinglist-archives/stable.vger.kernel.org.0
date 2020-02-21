Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44263167263
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgBUIDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbgBUIDD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89BE1206ED;
        Fri, 21 Feb 2020 08:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272183;
        bh=dkb+6SBa4D8pK5Pl0N9HGRV0ODZeGJ8/tYb4qTMpYN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FweZktvK91WJ0kptGPOtGXI5XrgoCeavYVszC7bO20avngwszXFPRs4HGGfg+DNzH
         srrJtcaeHnwvpoverOVutUyJeabahwRqp6qpB0fWu+8GuPwe4VyNVMT6iye8/+zo77
         52s1GF49DujhLvpq8y/VBfZ+8Lgb4N3x0Inq7F6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        YueHaibing <yuehaibing@huawei.com>, Jessica Yu <jeyu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/344] kernel/module: Fix memleak in module_add_modinfo_attrs()
Date:   Fri, 21 Feb 2020 08:37:26 +0100
Message-Id: <20200221072353.377532118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
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
index cb09a5f37a5fc..9fb8fa22e16b3 100644
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



