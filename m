Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F035404F
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhDEJRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240789AbhDEJRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F04A61002;
        Mon,  5 Apr 2021 09:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614215;
        bh=3/NahcVERyTwRV01NBCmclz3lMQXroZGy7L7zyEmRAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9C+LgCft+A5D4xqpKthJslCkm6KaZKC8OIGPIlDyeNqCgEjlfPY615Na4XgYbFVy
         +yNB01PZgUw4keofjnehnose287w7WQwqHP9Bla5I6hU3Pd2GV3j3Kbt3aWIAa9PVA
         0LJ71tqlt0tPQn6lLxo7DXdMYi6MqDQIMwOqJqJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 126/152] usb: dwc3: pci: Enable dis_uX_susphy_quirk for Intel Merrifield
Date:   Mon,  5 Apr 2021 10:54:35 +0200
Message-Id: <20210405085038.323696423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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



