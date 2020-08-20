Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA624B9D2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgHTLz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbgHTKCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:02:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB99122B49;
        Thu, 20 Aug 2020 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917750;
        bh=8iTHG97oN/GiY/zqMjgP70WevF5Sb28U4lP0F2VYTEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAudMyy8GYIX+zJotKP56CyPVZWv3N2CUXpy0VNtB/G8HDjGsDOxA/jYwUQxFsegq
         v52VSUTIS5mvb9BZ8MwYN7Cj5dv+whIIgCNoJ4nMq5HXiLrLZiyjNgi53dcrUJrcBb
         KpcUWS4Vz8RzvcGT3wf/0xrNmIlWA5pldx569ZaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 145/212] fsl/fman: fix unreachable code
Date:   Thu, 20 Aug 2020 11:21:58 +0200
Message-Id: <20200820091609.668855430@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florinel Iordache <florinel.iordache@nxp.com>

[ Upstream commit cc79fd8f557767de90ff199d3b6fb911df43160a ]

The parameter 'priority' is incorrectly forced to zero which ultimately
induces logically dead code in the subsequent lines.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index c30994a09a7c2..3e5b40c831558 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -851,7 +851,6 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~CMD_CFG_PFC_MODE;
-	priority = 0;
 
 	iowrite32be(tmp, &regs->command_config);
 
-- 
2.25.1



