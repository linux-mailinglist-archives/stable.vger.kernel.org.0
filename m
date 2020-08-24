Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE7024FA4E
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHXIgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgHXIgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:36:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B6C207DF;
        Mon, 24 Aug 2020 08:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258196;
        bh=3nDsga2bpnQ7gibh7J1sl5vVziLsJsa7Ai2+ydM4siQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJjR3cbU36JRG/Y95BBa8wwyZ3XAThzFJ5LRRxZnkP/SHJaMI9/Tgqccw7H1F5Clr
         JbQkwZHA/h4SEQgBjOixsAI6jBBLRC5h19MMOD7oaZ42yDQi8fBryQwERu82MKYit0
         IEMFfz+fDfCmAOvtxRJlpoL9xuwOcKunR2xzCSj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 109/148] scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()
Date:   Mon, 24 Aug 2020 10:30:07 +0200
Message-Id: <20200824082419.239966938@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 2138d1c918246e3d8193c3cb8b6d22d0bb888061 ]

Fix to return error code PTR_ERR() from the error handling case instead of
0.

Link: https://lore.kernel.org/r/20200806070135.67797-1-jingxiangfeng@huawei.com
Fixes: 22617e216331 ("scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 46bb905b4d6a9..eafe0db98d542 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -38,6 +38,7 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
 		dev_err(dev, "Cannot claim MPHY clock.\n");
 		goto clk_err;
 	}
-- 
2.25.1



