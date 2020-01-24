Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5662E148322
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404315AbgAXLdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404615AbgAXLdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:33:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD46206D4;
        Fri, 24 Jan 2020 11:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865617;
        bh=/jb/StiBkQnNp1GN92R6qCVPT5kDpfSTD9GsgwK4vug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzwlVZPKQGMszjmjz/k0gskyQvf2DtGSQPql+aojzJFLpojMutE6rU7LozesQxbDP
         lAwqKFxHKNIqJyhWTv7PcDyu7IWt4aeY7pr2XVU9pOuyp3chQSJxyV8RW/4dCkH/VC
         ko6X/lMIBDoyfcGyX1kQKE51v9im8+hjQayvpkyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antonio Borneo <antonio.borneo@st.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 594/639] net: stmmac: fix disabling flexible PPS output
Date:   Fri, 24 Jan 2020 10:32:44 +0100
Message-Id: <20200124093203.802759279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit 520cf6002147281d1e7b522bb338416b623dcb93 ]

Accordingly to Synopsys documentation [1] and [2], when bit PPSEN0
in register MAC_PPS_CONTROL is set it selects the functionality
command in the same register, otherwise selects the functionality
control.
Command functionality is required to either enable (command 0x2)
and disable (command 0x5) the flexible PPS output, but the bit
PPSEN0 is currently set only for enabling.

Set the bit PPSEN0 to properly disable flexible PPS output.

Tested on STM32MP15x, based on dwmac 4.10a.

[1] DWC Ethernet QoS Databook 4.10a October 2014
[2] DWC Ethernet QoS Databook 5.00a September 2017

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Fixes: 9a8a02c9d46d ("net: stmmac: Add Flexible PPS support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 3f4f3132e16b3..e436fa160c7d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -515,6 +515,7 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 
 	if (!enable) {
 		val |= PPSCMDx(index, 0x5);
+		val |= PPSEN0;
 		writel(val, ioaddr + MAC_PPS_CONTROL);
 		return 0;
 	}
-- 
2.20.1



