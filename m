Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6362537CD70
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhELQzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243909AbhELQmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62BB61C49;
        Wed, 12 May 2021 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835701;
        bh=gXq2paFHLFWG4gwQI7A79iLmPT74ZRQipM90epusL2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D88JtsuNKhfzVZuwqZwfnmru6qQ/7AeF9GKlRBpPRIoO58DSBGubGjT4AgKqzCr9A
         QUByf8KFtzt5ICjxPiGPgGAt2sECPD6OInvVBggLUVXN5Z61cEZopqAsLcLujA5s0F
         1dQq38UMyDmX1XHZhKzEhueCgXkWk7MEvX59hJJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 415/677] scsi: ufs: ufshcd-pltfrm: Fix deferred probing
Date:   Wed, 12 May 2021 16:47:41 +0200
Message-Id: <20210512144851.129195520@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 1a69949a4ea1..b56d9b4e5f03 100644
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



