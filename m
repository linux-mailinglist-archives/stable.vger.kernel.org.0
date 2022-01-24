Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7A499782
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448627AbiAXVNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446705AbiAXVJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D166260C60;
        Mon, 24 Jan 2022 21:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21BDC340E5;
        Mon, 24 Jan 2022 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058550;
        bh=dkmUFr49CybcD04y+WFJD6jn5JBcCH1bqnANrKf9inE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCpZ5CfA0Fke7t0Ks5OITq5h2IGaabkXH1MfPuSUtj5RlBjwxu+yqRJSMM08bKDzi
         4vBwDqecNSDnxChvTByt23/hH48CTV61rgh9RS6LZmSeCfcxQfsGZAtZpB5WZIO2er
         nImewV3xTNUfoGn/iFPukHaE6nJRav4EwktHOV3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0325/1039] rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC
Date:   Mon, 24 Jan 2022 19:35:14 +0100
Message-Id: <20220124184136.231934879@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit c81edb8dddaa36c4defa26240cc19127f147283f ]

8821CE causes random freezes on HP 250 G7 Notebook PC. Add a quirk
to disable pci ASPM capability.

Reported-by: rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211119052437.8671-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203c..3b367c9085eba 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1738,6 +1738,15 @@ static const struct dmi_system_id rtw88_pci_quirks[] = {
 		},
 		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
 	},
+	{
+		.callback = disable_pci_caps,
+		.ident = "HP HP 250 G7 Notebook PC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 250 G7 Notebook PC"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
+	},
 	{}
 };
 
-- 
2.34.1



