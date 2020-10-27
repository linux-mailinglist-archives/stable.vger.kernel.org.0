Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35FB29BC0E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752262AbgJ0Qa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802618AbgJ0Pud (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFB6204EF;
        Tue, 27 Oct 2020 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813832;
        bh=v2Irryi3FqaIFDpBaCx1TpdVuR2A4FadIVt8z2gYIKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFuuyqKEQoOUt33N/1a2YzZwtH5Fns22VPSbYBgauUyXluvKuM00ASTop0i/966Iz
         eVF+E8iyQT2xxnSHgtpEIh3nrHuD3WoNa2L1n+8FrzMFViuWpO8WJQPE93LBVQbwPU
         UTXbqTq9gotHJJs+lgwPJ6P+8E1bMXSCyRzs4xVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 686/757] rtw88: pci: Power cycle device during shutdown
Date:   Tue, 27 Oct 2020 14:55:36 +0100
Message-Id: <20201027135522.705929633@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 44492e70adc8086c42d3745d21d591657a427f04 ]

There are reports that 8822CE fails to work rtw88 with "failed to read DBI
register" error. Also I have a system with 8723DE which freezes the whole
system when the rtw88 is probing the device.

According to [1], platform firmware may not properly power manage the
device during shutdown. I did some expirements and putting the device to
D3 can workaround the issue.

So let's power cycle the device by putting the device to D3 at shutdown
to prevent the issue from happening.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=206411#c9

BugLink: https://bugs.launchpad.net/bugs/1872984
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200928165508.20775-1-kai.heng.feng@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 3413973bc4750..7f1f5073b9f4d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1599,6 +1599,8 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 
 	if (chip->ops->shutdown)
 		chip->ops->shutdown(rtwdev);
+
+	pci_set_power_state(pdev, PCI_D3hot);
 }
 EXPORT_SYMBOL(rtw_pci_shutdown);
 
-- 
2.25.1



