Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98E7106362
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfKVGKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:10:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbfKVF4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3AF020659;
        Fri, 22 Nov 2019 05:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402213;
        bh=HrvkQmIy1wCzH0pi9Xov1kIUGDIYQiuaTMJmZSTiLbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/1BHv6ujVw0uRzVa89+syMEkogM9W6x8F8M9VAxq6PC58a+y5NtvjWn8Gw1JEuSA
         EbcbTE35RlPku5/v0FwBVTPUryoW4/oOoNStgkOBz4ONEIuKi3SIFjN3FcpukUGS6W
         2A2nwK9TtX9YbZ4yEOMnL0cBw1kPBzogurMbrEbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 061/127] scsi: csiostor: fix incorrect dma device in case of vport
Date:   Fri, 22 Nov 2019 00:54:39 -0500
Message-Id: <20191122055544.3299-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 9934613edcb40b92a216122876cd3b7e76d08390 ]

In case of ->vport_create() call scsi_add_host_with_dma() instead of
scsi_add_host() to pass correct dma device.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 28a9c7d706cb0..03c7b1603dbc1 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -649,7 +649,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
 	if (csio_lnode_init(ln, hw, pln))
 		goto err_shost_put;
 
-	if (scsi_add_host(shost, dev))
+	if (scsi_add_host_with_dma(shost, dev, &hw->pdev->dev))
 		goto err_lnode_exit;
 
 	return ln;
-- 
2.20.1

