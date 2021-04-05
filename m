Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17205353F33
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbhDEJKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239229AbhDEJKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BD3613AD;
        Mon,  5 Apr 2021 09:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613820;
        bh=3/NahcVERyTwRV01NBCmclz3lMQXroZGy7L7zyEmRAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv5tvIz3Ouo34f21yd55Bi4W5DuimZNn4WYN65wzqj3QMi7gniN7e50zeOKtErMd5
         kX2+QiI4RPiDBI5UIAdJbBfqoVEZlGybK7z3kA510iuO3sTYX2KzpQaYZt2Eg4vp23
         +1jkkaVwgmzRjoQQ/4PYiXJCl/zYW28cH+AxsCrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/126] usb: dwc3: pci: Enable dis_uX_susphy_quirk for Intel Merrifield
Date:   Mon,  5 Apr 2021 10:54:24 +0200
Message-Id: <20210405085034.417508050@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b522f830d35189e0283fa4d5b4b3ef8d7a78cfcb ]

It seems that on Intel Merrifield platform the USB PHY shouldn't be suspended.
Otherwise it can't be enabled by simply change the cable in the connector.

Enable corresponding quirk for the platform in question.

Fixes: e5f4ca3fce90 ("usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression")
Suggested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210322125244.79407-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index bae6a70664c8..598daed8086f 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -118,6 +118,8 @@ static const struct property_entry dwc3_pci_intel_properties[] = {
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
+	PROPERTY_ENTRY_BOOL("snps,dis_u3_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
-- 
2.30.2



