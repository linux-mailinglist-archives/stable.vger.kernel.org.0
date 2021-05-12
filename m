Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206C337C975
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhELQTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239629AbhELQKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DBF861D58;
        Wed, 12 May 2021 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834009;
        bh=gXq2paFHLFWG4gwQI7A79iLmPT74ZRQipM90epusL2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UvNnH9Zrr3f/kbMqn6g/W7Y5F9cfdFzU3nTsbVOQBDSGZBueMHOCfrJVUYNKe6ao
         0hwWNejBdiB0E4LjSZUf7t/MKIYHc7btepy0PQqCVPdxNKUyWW0+1PFg0XpEClwkv6
         wccloCR2M+UO7zQhxuTYVCAE0gjBQqwxRPaugjUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 367/601] scsi: ufs: ufshcd-pltfrm: Fix deferred probing
Date:   Wed, 12 May 2021 16:47:24 +0200
Message-Id: <20210512144839.887145233@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



