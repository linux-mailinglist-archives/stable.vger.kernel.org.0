Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F367A106D8A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfKVLAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfKVLAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A7420706;
        Fri, 22 Nov 2019 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420436;
        bh=HpJfRrDSSyuLg2DrJFpzk2sKf7uuJaSUC8TTp4L+rU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlgvfPCBuBbK+9W7Q6dcomTM7GJs3+mifzDV/ZajMHdQDjx4LyiSdu+J7YSBeL1R7
         vKzDTImYkuBVy0G6monV9HxTybxF5Ou0q0slH1bX55HhNcPhKuXTs/vOgSj1Ne8xQT
         9r0WrNPL85Y3LrP5Lt0iQJmzY6wm4RTsrdZj1yhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/220] bnxt_en: return proper error when FW returns HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED
Date:   Fri, 22 Nov 2019 11:27:50 +0100
Message-Id: <20191122100920.329417219@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 3a1d52a54a6a4030b294e5f5732f0bfbae0e3815 ]

Return proper error code when Firmware returns
HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED for HWRM_NVM_GET/SET_VARIABLE
commands.

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 790c684f08abc..b178c2e9dc231 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -78,8 +78,12 @@ static int bnxt_hwrm_nvm_req(struct bnxt *bp, u32 param_id, void *msg,
 		memcpy(buf, data_addr, bytesize);
 
 	dma_free_coherent(&bp->pdev->dev, bytesize, data_addr, data_dma_addr);
-	if (rc)
+	if (rc == HWRM_ERR_CODE_RESOURCE_ACCESS_DENIED) {
+		netdev_err(bp->dev, "PF does not have admin privileges to modify NVM config\n");
+		return -EACCES;
+	} else if (rc) {
 		return -EIO;
+	}
 	return 0;
 }
 
-- 
2.20.1



