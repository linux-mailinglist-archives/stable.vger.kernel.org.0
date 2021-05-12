Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A62537C54F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhELPjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbhELPcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:32:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D469D61977;
        Wed, 12 May 2021 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832603;
        bh=cNkD7QY51/402Wi/3aj0ittlMuaQAXew+IMlUx3lLBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acL5P4ngTcASoqms6N5fRysMaOaBBhtp1hVOdvbrGN6yTbeR6DsYtRMN9ucktdy6f
         N2cYPJz+YuF/VHXh13UHdKczGmuNWGUgQ4oyvrUuvgZINiNynYl4/I5KDQ+h90eSEe
         ozmiO5FUBVdVHC8MgDUZEUvlguUiW4X939o2Dm4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/530] scsi: ufs: ufshcd-pltfrm: Fix deferred probing
Date:   Wed, 12 May 2021 16:47:20 +0200
Message-Id: <20210512144830.654604574@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omprussia.ru>

[ Upstream commit 339c9b63cc7ce779ce45c675bf709cb58b807fc3 ]

The driver overrides the error codes returned by platform_get_irq() to
-ENODEV, so if it returns -EPROBE_DEFER, the driver would fail the probe
permanently instead of the deferred probing.  Propagate the error code
upstream as it should have been done from the start...

Link: https://lore.kernel.org/r/420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru
Fixes: 2953f850c3b8 ("[SCSI] ufs: use devres functions for ufshcd")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 3db0af66c71c..24927cf485b4 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -377,7 +377,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		err = -ENODEV;
+		err = irq;
 		goto out;
 	}
 
-- 
2.30.2



