Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A5FF0B5
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfKPQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbfKPPug (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:36 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450F4214E0;
        Sat, 16 Nov 2019 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919435;
        bh=H0+p4fK298kw1jSTheIrFbd+g0vAAzU0oZwSoqofGG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJjnK1vn0Bkz+efrUPs2DDHeTS/fXYvVYRPJK7e3qos2qWPpBEa6uXA7Gmk9grWN9
         VTblhEAR0u6OijSSZlzAdL58x5Lv4FKC7cu/Bs+1ycgaY0EaodTgxt1HPKRYNP27ho
         71eeonpXRY11xJlECm0W09+T3bpF1PxJsjy1Ns+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tycho Andersen <tycho@tycho.ws>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 134/150] dlm: fix invalid free
Date:   Sat, 16 Nov 2019 10:47:12 -0500
Message-Id: <20191116154729.9573-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit d968b4e240cfe39d39d80483bac8bca8716fd93c ]

dlm_config_nodes() does not allocate nodes on failure, so we should not
free() nodes when it fails.

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/member.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 3fda3832cf6a6..cad6d85911a80 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -680,7 +680,7 @@ int dlm_ls_start(struct dlm_ls *ls)
 
 	error = dlm_config_nodes(ls->ls_name, &nodes, &count);
 	if (error < 0)
-		goto fail;
+		goto fail_rv;
 
 	spin_lock(&ls->ls_recover_lock);
 
@@ -712,8 +712,9 @@ int dlm_ls_start(struct dlm_ls *ls)
 	return 0;
 
  fail:
-	kfree(rv);
 	kfree(nodes);
+ fail_rv:
+	kfree(rv);
 	return error;
 }
 
-- 
2.20.1

