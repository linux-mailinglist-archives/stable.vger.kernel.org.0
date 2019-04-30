Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17CF746
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfD3L5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730759AbfD3Lrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:47:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA65D2054F;
        Tue, 30 Apr 2019 11:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624870;
        bh=qmySqOgGAWXl1qA4wBmbdzy9gaa7gjJVIfqEMiXeztg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4drx8EEJuAR6mxNPTVCDGci/OyicRBUF+10QRcnBHX8dJAPCEPeYh6uwhQzdjnMs
         vhnyTkGzWf5YpWXAlqRomt7EQvt769eceWczvTBHpYZcBWm9X0tmk021XC+gFNfi4Y
         M6DvMrtxra8AiNWo4+VmVrj1jyO4L8dx6vzJGkUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Bao Cheng <baocheng.su@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 092/100] stmmac: pci: Adjust IOT2000 matching
Date:   Tue, 30 Apr 2019 13:39:01 +0200
Message-Id: <20190430113613.159496689@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Bao Cheng <baocheng.su@siemens.com>

[ Upstream commit e0c1d14a1a3211dccf0540a6703ffbd5d2a75bdb ]

Since there are more IOT2040 variants with identical hardware but
different asset tags, the asset tag matching should be adjusted to
support them.

For the board name "SIMATIC IOT2000", currently there are 2 types of
hardware, IOT2020 and IOT2040. The IOT2020 is identified by its unique
asset tag. Match on it first. If we then match on the board name only,
we will catch all IOT2040 variants. In the future there will be no other
devices with the "SIMATIC IOT2000" DMI board name but different
hardware.

Signed-off-by: Su Bao Cheng <baocheng.su@siemens.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -159,6 +159,12 @@ static const struct dmi_system_id quark_
 		},
 		.driver_data = (void *)&galileo_stmmac_dmi_data,
 	},
+	/*
+	 * There are 2 types of SIMATIC IOT2000: IOT20202 and IOT2040.
+	 * The asset tag "6ES7647-0AA00-0YA2" is only for IOT2020 which
+	 * has only one pci network device while other asset tags are
+	 * for IOT2040 which has two.
+	 */
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
@@ -170,8 +176,6 @@ static const struct dmi_system_id quark_
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
-			DMI_EXACT_MATCH(DMI_BOARD_ASSET_TAG,
-					"6ES7647-0AA00-1YA2"),
 		},
 		.driver_data = (void *)&iot2040_stmmac_dmi_data,
 	},


