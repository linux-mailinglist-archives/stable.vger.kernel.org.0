Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1692C9A8F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbgLAI6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388004AbgLAI6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C3F2224C;
        Tue,  1 Dec 2020 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813087;
        bh=feyOVk9Nvd7raUGhgw0geW6B0Qe5AngkQVZq4qX3pvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/XT753vMsfHZGYDSqy5xp+07/1Uku4zb0RkG1Ui25Jj8ygTKymplLKQA5dyf3oqy
         jrU1vEpCpNT8Xpym2bB6ZcQBPYtjUA5KIAeFeHmPoX0QfGuuWEbHAehMWTafuY8FWp
         Ta/4cLqnlfpiHwbGIDamQD2VALd6ApmzzGBBq8Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/50] bnxt_en: fix error return code in bnxt_init_one()
Date:   Tue,  1 Dec 2020 09:53:28 +0100
Message-Id: <20201201084648.662941616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit b5f796b62c98cd8c219c4b788ecb6e1218e648cb ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c213eae8d3cd ("bnxt_en: Improve VF/PF link change logic.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Link: https://lore.kernel.org/r/1605701851-20270-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e146f6a1fa80d..4a3ee5db19d34 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8233,6 +8233,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				create_singlethread_workqueue("bnxt_pf_wq");
 			if (!bnxt_pf_wq) {
 				dev_err(&pdev->dev, "Unable to create workqueue.\n");
+				rc = -ENOMEM;
 				goto init_err_pci_clean;
 			}
 		}
-- 
2.27.0



