Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41422C9BFC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390166AbgLAJNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389368AbgLAJNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93DDF20809;
        Tue,  1 Dec 2020 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813981;
        bh=pCJfn7/POhgLsd1U3TbNnpg71NrJvduuboPg4UHUftg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSEuON91FfIUTVWK7vYmfPeLTsxHHEfcEeBvV5CwBgZft+5CPJmXh1mffHL4Q3vmj
         Dvri5uxRlY+R37YVRzmbawKYY+O1k10/29ekHXa2dUE7z3aWFAXYY2HGdHg7VzpuIh
         d6k7rtPdCfJpOXRMV1jk1xcU4C1paNv0aYEbbjok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 126/152] net: stmmac: fix incorrect merge of patch upstream
Date:   Tue,  1 Dec 2020 09:54:01 +0100
Message-Id: <20201201084728.297437683@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit 12a8fe56c0f06eaab1f9d89d246c3591bcc7a966 ]

Commit 757926247836 ("net: stmmac: add flexible PPS to dwmac
4.10a") was intended to modify the struct dwmac410_ops, but it got
somehow badly merged and modified the struct dwmac4_ops.

Revert the modification in struct dwmac4_ops and re-apply it
properly in struct dwmac410_ops.

Fixes: 757926247836 ("net: stmmac: add flexible PPS to dwmac 4.10a")
Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20201124223729.886992-1-antonio.borneo@st.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index ecd834e0e1216..72a5408a44d61 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -1160,7 +1160,6 @@ const struct stmmac_ops dwmac4_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
-	.flex_pps_config = dwmac5_flex_pps_config,
 	.set_mac_loopback = dwmac4_set_mac_loopback,
 	.update_vlan_hash = dwmac4_update_vlan_hash,
 	.sarc_configure = dwmac4_sarc_configure,
@@ -1202,6 +1201,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.pcs_get_adv_lp = dwmac4_get_adv_lp,
 	.debug = dwmac4_debug,
 	.set_filter = dwmac4_set_filter,
+	.flex_pps_config = dwmac5_flex_pps_config,
 	.set_mac_loopback = dwmac4_set_mac_loopback,
 	.update_vlan_hash = dwmac4_update_vlan_hash,
 	.sarc_configure = dwmac4_sarc_configure,
-- 
2.27.0



