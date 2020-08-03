Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0439723A669
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHCMrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgHCMZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 868D9204EC;
        Mon,  3 Aug 2020 12:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457522;
        bh=+bZ7yDzZUgOYT9JI0IYCIKeW/jA887oFGWzPoBuqv18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9Z9o8gadPme0dfeLgQi0U6qhWEaDgnCKeUYxcRaBTN/kdGn6T53ILB4ktPnj0NOa
         vcfSany/jdWjnR4SEhMAycJX+pAzdN+euT69BV7Rh9ePwfchfHaIY/Wmt/JxVQyUsC
         AwBbjzlhzWioFtAmrYMFGy/Y265g7/i/s0Q2pVDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 068/120] octeontx2-pf: Unregister netdev at driver remove
Date:   Mon,  3 Aug 2020 14:18:46 +0200
Message-Id: <20200803121906.117295157@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit ed543f5c6a988d8a863d2436794230cef2c82389 ]

Added unregister_netdev in the driver remove
function. Generally unregister_netdev is called
after disabling all the device interrupts but here
it is called before disabling device mailbox
interrupts. The reason behind this is VF needs
mailbox interrupt to communicate with its PF to
clean up its resources during otx2_stop.
otx2_stop disables packet I/O and queue interrupts
first and by using mailbox interrupt communicates
to PF to free VF resources. Hence this patch
calls unregister_device just before
disabling mailbox interrupts.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index c1c263d1ac2ec..92a3db69a6cd6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -618,6 +618,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	vf = netdev_priv(netdev);
 
 	cancel_work_sync(&vf->reset_task);
+	unregister_netdev(netdev);
 	otx2vf_disable_mbox_intr(vf);
 
 	otx2_detach_resources(&vf->mbox);
-- 
2.25.1



