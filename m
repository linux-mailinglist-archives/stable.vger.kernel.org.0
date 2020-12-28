Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1403B2E37E7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgL1NCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730074AbgL1NCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A459B22573;
        Mon, 28 Dec 2020 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160538;
        bh=b3YkWgAGCc8tgJYY2DJD3faZH2Q/m3Lni073ZwViY7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=em/a6it6aNuHXOBPurEm01WqutzaS37FpgedSUG5L9CcvN3oG2SUscUb+fCCimwhY
         b4FS6AnqhBCSe0pDj37BZUuOx7/8Oq20+4NZU4wQfsPRdYMtWYafQQn2sr9djBYG4V
         ZjtUmvDfIuzym8u2GE/DndM1eEcAu9oiaXpDs8QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 083/175] mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
Date:   Mon, 28 Dec 2020 13:48:56 +0100
Message-Id: <20201228124857.262943666@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit f0e82242b16826077a2775eacfe201d803bb7a22 ]

kfree(dev) has been called inside put_device so anther
kfree would cause a use-after-free bug/

Fixes: 8286ae03308c ("MIPS: Add CDMM bus support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mips_cdmm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/bus/mips_cdmm.c b/drivers/bus/mips_cdmm.c
index 1b14256376d24..7c1da45be166e 100644
--- a/drivers/bus/mips_cdmm.c
+++ b/drivers/bus/mips_cdmm.c
@@ -544,10 +544,8 @@ static void mips_cdmm_bus_discover(struct mips_cdmm_bus *bus)
 		dev_set_name(&dev->dev, "cdmm%u-%u", cpu, id);
 		++id;
 		ret = device_register(&dev->dev);
-		if (ret) {
+		if (ret)
 			put_device(&dev->dev);
-			kfree(dev);
-		}
 	}
 }
 
-- 
2.27.0



