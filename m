Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A829BBF7
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902228AbgJ0QaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802649AbgJ0Pum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A5102072C;
        Tue, 27 Oct 2020 15:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813841;
        bh=W7djoAKVSL07Q8YxcMiprpi1nhnt1rRDRNxZOdBdfkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lh3S/dpQmw3UDJkhU85MKxGfXyVBBXqoKg5PW462tj1ZpVWCth0naKUXGnV9mVTCx
         KpE5erpDp7dyDRFSwaRE5aJKGsoTZ7ZBFEdA3TecNEl73N/JfSTvh31x0VM8qxQAbE
         y4XEIWK1eYQoVN6iPRDdoN93iUq2VZblGiF7+its=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzu-En Huang <tehuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 689/757] rtw88: increse the size of rx buffer size
Date:   Tue, 27 Oct 2020 14:55:39 +0100
Message-Id: <20201027135522.850234100@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit ee755732b7a16af018daa77d9562d2493fb7092f ]

The vht capability of MAX_MPDU_LENGTH is 11454 in rtw88; however, the rx
buffer size for each packet is 8192. When receiving packets that are
larger than rx buffer size, it will leads to rx buffer ring overflow.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200925061219.23754-2-tehuang@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 024c2bc275cbe..ca17aa9cf7dc7 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -9,8 +9,8 @@
 #define RTK_BEQ_TX_DESC_NUM	256
 
 #define RTK_MAX_RX_DESC_NUM	512
-/* 8K + rx desc size */
-#define RTK_PCI_RX_BUF_SIZE	(8192 + 24)
+/* 11K + rx desc size */
+#define RTK_PCI_RX_BUF_SIZE	(11454 + 24)
 
 #define RTK_PCI_CTRL		0x300
 #define BIT_RST_TRXDMA_INTF	BIT(20)
-- 
2.25.1



