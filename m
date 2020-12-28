Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5091D2E63C5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404928AbgL1Pmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405495AbgL1NrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EBE22B3B;
        Mon, 28 Dec 2020 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163205;
        bh=b3YkWgAGCc8tgJYY2DJD3faZH2Q/m3Lni073ZwViY7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+bCkvzRw1oYWvfD/J+YMEVxFsuBPvjJ/I89kxBisxRFv7XRC3jo96o2nTVc+kDHY
         asq9L1GjlY/Ts9EvQTM+bMlewPEzerNCl8ML7TbPaXUUw1PgEFSQ81SOLrGJ7zk8rP
         OOny6sT2tBv3xTeJOOJiehJck/lkNfPPdEw843kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/453] mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
Date:   Mon, 28 Dec 2020 13:46:52 +0100
Message-Id: <20201228124945.668591367@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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



