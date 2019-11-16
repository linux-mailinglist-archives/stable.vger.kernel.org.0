Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C541FEF0F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbfKPP4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:56:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbfKPPz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:55:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F86219F7;
        Sat, 16 Nov 2019 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919729;
        bh=3ezIcSOyWYw8I4efjEO+0CwCb+ZkrQdkz6h7FNO1ffM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+I+8J3unJ7rkCLWBda6A7dxHT6HW2l/R/pArabgKyk7V8GCQkaAb5LFqwvXreDx9
         YtNoY2hXtRSy3XYWajNHppbr+Gk+HQ2j0gmTspzPsM+I7TS7GN1aCxp3e+BGaBC8LL
         1NhUffGhfjvFyyqQvljbVdV7NtGiMJFGiQv0T1Yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tycho Andersen <tycho@tycho.ws>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 70/77] dlm: fix invalid free
Date:   Sat, 16 Nov 2019 10:53:32 -0500
Message-Id: <20191116155339.11909-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
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
index 9c47f1c14a8ba..a47ae99f7bcbc 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -683,7 +683,7 @@ int dlm_ls_start(struct dlm_ls *ls)
 
 	error = dlm_config_nodes(ls->ls_name, &nodes, &count);
 	if (error < 0)
-		goto fail;
+		goto fail_rv;
 
 	spin_lock(&ls->ls_recover_lock);
 
@@ -715,8 +715,9 @@ int dlm_ls_start(struct dlm_ls *ls)
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

