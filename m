Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E500246C6F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgHQQQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731074AbgHQQPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:15:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA1520657;
        Mon, 17 Aug 2020 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680939;
        bh=/wMCcPpPqmCyGbd1uW2Ae1dblCYoqM4JgnnIydBCcpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b+fn0Nhi2QT3YhEeEVsT7ty7YHwGRrHvwTJCscg3C4110XyuV9CxRqL9qhspTGYyz
         Y/IpkyMvmP+6cMr5fpblreF1t/yZ0zdO4wiy6+/Kx8quFfDhwz8tynTP/E2JNNQ1v2
         NU6TGr9lZDGEX9lnaQVhOKb1EXtSz0YD+GZ0BwDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Farrington <ricardo.farrington@cavium.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/168] liquidio: Fix wrong return value in cn23xx_get_pf_num()
Date:   Mon, 17 Aug 2020 17:17:29 +0200
Message-Id: <20200817143739.576028667@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit aa027850a292ea65524b8fab83eb91a124ad362c ]

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: 0c45d7fe12c7e ("liquidio: fix use of pf in pass-through mode in a virtual machine")
Cc: Rick Farrington <ricardo.farrington@cavium.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 9f4f3c1d50434..55fe80ca10d39 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -1167,7 +1167,7 @@ static int cn23xx_get_pf_num(struct octeon_device *oct)
 		oct->pf_num = ((fdl_bit >> CN23XX_PCIE_SRIOV_FDL_BIT_POS) &
 			       CN23XX_PCIE_SRIOV_FDL_MASK);
 	} else {
-		ret = EINVAL;
+		ret = -EINVAL;
 
 		/* Under some virtual environments, extended PCI regs are
 		 * inaccessible, in which case the above read will have failed.
-- 
2.25.1



