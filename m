Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E957333E33
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhCJNZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhCJNZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A948464FE8;
        Wed, 10 Mar 2021 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382704;
        bh=vk3mtxnn6aBHlEJmU4lfSAuGWVCWMlvbxpHXIZXGoAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drVIM00+RGLVKbEmXfro3or1aovG6kefE2VlC/t0HjZShl4h7OHOq6x6mr5w5Tnsa
         n30u7Xi/aXeGuVDTcE+4iOhCl/n33svvjfjaluyKP0am4uWN8S+qE6HLQEniPv/Oc/
         3mj5jL5lMdxNYz3ZpBIHBBkVXwCoZDrQwQGmiVGE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/49] scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Wed, 10 Mar 2021 14:23:43 +0100
Message-Id: <20210310132322.955347418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 46ec9592ffd679fa26142dcb9e5119aad7e60b55 ]

Flush during hibern8 is sufficient on MediaTek platforms, thus enable
UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL to skip enabling
fWriteBoosterBufferFlush during WriteBooster initialization.

Link: https://lore.kernel.org/r/20201222072928.32328-1-stanley.chu@mediatek.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 914a827a93ee..934713472ebc 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -566,6 +566,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	/* Enable WriteBooster */
 	hba->caps |= UFSHCD_CAP_WB_EN;
+	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
 
 	/*
-- 
2.30.1



