Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAEA13A5F1
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgANKGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbgANKGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:06:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846F2207FF;
        Tue, 14 Jan 2020 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996397;
        bh=/aG2MasLIibQrXweZeE7AgosxxsKqR4K6Pl8zc4gGs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edG68gNEsuDPGtiWkDlVyI7Q0VP4PGhCilrqE43eyFvt+E9Lg8bR3kW3+oIgqdkje
         j2pstOgEVBrKtpNZOuxj8g0/y0lJaNGAZDQ6wLg5J/hO30HQ0QyfazH+4pCEm5yGKF
         O1UEmilLhq2HguuL2PjrFw+ifYA4v375rA5pZjso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.4 67/78] mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
Date:   Tue, 14 Jan 2020 11:01:41 +0100
Message-Id: <20200114094402.390320964@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit db8fd2cde93227e566a412cf53173ffa227998bc upstream.

In mwifiex_pcie_alloc_cmdrsp_buf, a new skb is allocated which should be
released if mwifiex_map_pci_memory() fails. The release is added.

Fixes: fc3314609047 ("mwifiex: use pci_alloc/free_consistent APIs for PCIe")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/pcie.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1032,8 +1032,10 @@ static int mwifiex_pcie_alloc_cmdrsp_buf
 	}
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
 	if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
-				   PCI_DMA_FROMDEVICE))
+				   PCI_DMA_FROMDEVICE)) {
+		kfree_skb(skb);
 		return -1;
+	}
 
 	card->cmdrsp_buf = skb;
 


