Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFF82C9BC4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389871AbgLAJLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389861AbgLAJLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80560221FF;
        Tue,  1 Dec 2020 09:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813869;
        bh=lSRW+51jiWz62A5RaOXsDECifjqRFFFGDmM6Tm9JX5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWZGRx6KqYhx+YabXwXkVpGKDG9Vrl/054VldtSx+Vsu4NW7iCkMgMujB5O2EsKNQ
         WNi79BMVBJpVOt4tTPl94jZTWjPxyRdIHdynAqz+u+KwDw8KxlBvnlgksWZPXTLfYO
         SNj/P3q7uT91lcaeVAyDMSqfl26y/eJfxlXO+cH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 088/152] bnxt_en: fix error return code in bnxt_init_one()
Date:   Tue,  1 Dec 2020 09:53:23 +0100
Message-Id: <20201201084723.401051092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
index 2326571e8c84a..cb57e8ce368ac 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12353,6 +12353,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				create_singlethread_workqueue("bnxt_pf_wq");
 			if (!bnxt_pf_wq) {
 				dev_err(&pdev->dev, "Unable to create workqueue.\n");
+				rc = -ENOMEM;
 				goto init_err_pci_clean;
 			}
 		}
-- 
2.27.0



