Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5D610BAD8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbfK0VHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732552AbfK0VHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5912176D;
        Wed, 27 Nov 2019 21:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888827;
        bh=H0+p4fK298kw1jSTheIrFbd+g0vAAzU0oZwSoqofGG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnMKtRhnOSVp8qgFtTiaI7+DlYCwsGkKp2vRrWxNxE5EMxt/zJELqESDtnQwylLW4
         DK1xvL5IdO/inHHQUdWn5DSvaaXDb5IFYjTxti5n/pdSzpi7qt7DLYVAZPhun74Fiz
         tQNIGengpRbfoWZ2JaXovhzmLPBthWqPJOfavg3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/306] dlm: fix invalid free
Date:   Wed, 27 Nov 2019 21:31:23 +0100
Message-Id: <20191127203132.024274952@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



