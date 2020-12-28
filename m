Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB342E6909
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgL1M4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgL1M4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:56:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F2B2207C9;
        Mon, 28 Dec 2020 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160157;
        bh=bADb9kEPr/X09t+n8Aps79523G0Qi1c3T7jigNI6dD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nosCowUDa7RJXFcwxUvQk1m2PpP0aSSOI5gPCY4KbMBSonx24RHhDW2Zz7N8Yd2vK
         46OuzrFmKU8jkTbhUVQZTj5lOV4bla/wme+PkrjtYD8T1KNYkJRd6qkxRjYKzaT/q5
         ZRDYn4HLjfBAzxx4JuUYOh4IKmpBkqBOpfGeVaeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 059/132] mips: cdmm: fix use-after-free in mips_cdmm_bus_discover
Date:   Mon, 28 Dec 2020 13:49:03 +0100
Message-Id: <20201228124849.300365438@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 1c543effe062f..e6284fc1689b3 100644
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



