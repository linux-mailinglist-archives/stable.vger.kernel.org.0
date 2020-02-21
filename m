Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE62167889
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBUHoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgBUHo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:44:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7978A24672;
        Fri, 21 Feb 2020 07:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271065;
        bh=iuyIbYzgZDi9u7sIMIx8Fd9TnuJLfU1RqCaPaTF+SmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQ5pphuzaYK/367F8CgLRiLNbQKZwEjS231niiALiVObGC1ql77jItp4tBPO2sE+W
         4ltGtlZ675ACH2983k5e7erbsak3P9AeHGNwVelwFZqBZdHQtK01T01jpaveRhdpFk
         ybiS9kLhIFkAjTFvfDaRIE90Taxv471Qg+8IaX9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 026/399] brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
Date:   Fri, 21 Feb 2020 08:35:51 +0100
Message-Id: <20200221072404.922390747@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 5cc509aa83c6acd2c5cd94f99065c39d2bd0a490 ]

In the implementation of brcmf_p2p_create_p2pdev() the allocated memory
for p2p_vif is leaked when the mac address is the same as primary
interface. To fix this, go to error path to release p2p_vif via
brcmf_free_vif().

Fixes: cb746e47837a ("brcmfmac: check p2pdev mac address uniqueness")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7ba9f6a686459..1f5deea5a288e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2092,7 +2092,8 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* firmware requires unique mac address for p2pdev interface */
 	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
 		bphy_err(drvr, "discovery vif must be different from primary interface\n");
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto fail;
 	}
 
 	brcmf_p2p_generate_bss_mac(p2p, addr);
-- 
2.20.1



