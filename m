Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62311161E5
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLHN4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60452 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726888AbfLHNyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1F-0007gr-Pc; Sun, 08 Dec 2019 13:54:41 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0002Op-4a; Sun, 08 Dec 2019 13:54:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Navid Emamdoost" <navid.emamdoost@gmail.com>,
        "Ganapathi Bhat" <gbhat@marvell.com>
Date:   Sun, 08 Dec 2019 13:53:39 +0000
Message-ID: <lsq.1575813165.739849210@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 55/72] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_alloc_cmdrsp_buf
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit db8fd2cde93227e566a412cf53173ffa227998bc upstream.

In mwifiex_pcie_alloc_cmdrsp_buf, a new skb is allocated which should be
released if mwifiex_map_pci_memory() fails. The release is added.

Fixes: fc3314609047 ("mwifiex: use pci_alloc/free_consistent APIs for PCIe")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Acked-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -876,8 +876,10 @@ static int mwifiex_pcie_alloc_cmdrsp_buf
 	}
 	skb_put(skb, MWIFIEX_UPLD_SIZE);
 	if (mwifiex_map_pci_memory(adapter, skb, MWIFIEX_UPLD_SIZE,
-				   PCI_DMA_FROMDEVICE))
+				   PCI_DMA_FROMDEVICE)) {
+		kfree_skb(skb);
 		return -1;
+	}
 
 	card->cmdrsp_buf = skb;
 

