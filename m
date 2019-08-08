Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B507A86A50
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404887AbfHHTIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404882AbfHHTIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51B5214C6;
        Thu,  8 Aug 2019 19:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291300;
        bh=8CrwL/5KPh4jpq0cJdyOmWbgJuCj/OZSfxl+4Ileh7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnQQPNIDlIv/7qNniDh7sdgAXTSahGE5aru9IQcMc9TcHkh7PwP1L7LHXk8ah+FDd
         4y2+KICa5F2x6xAfz/p0FZvzmbigPVCXL1sAzTta4bsIraEP/pMMX7ovG6l1T2hPAX
         aY8j51SfOJqO6+Y5iNLx9UjiAybvuTAR9KZb87bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuyonglong <liuyonglong@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 47/56] net: phy: fix race in genphy_update_link
Date:   Thu,  8 Aug 2019 21:05:13 +0200
Message-Id: <20190808190455.068957361@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit aa6b1956158f1afc52761137620d4b3f8a058d24 ]

In phy_start_aneg() autoneg is started, and immediately after that
link and autoneg status are read. As reported in [0] it can happen that
at time of this read the PHY has reset the "aneg complete" bit but not
yet the "link up" bit, what can result in a false link-up detection.
To fix this don't report link as up if we're in aneg mode and PHY
doesn't signal "aneg complete".

[0] https://marc.info/?t=156413509900003&r=1&w=2

Fixes: 4950c2ba49cc ("net: phy: fix autoneg mismatch case in genphy_read_status")
Reported-by: liuyonglong <liuyonglong@huawei.com>
Tested-by: liuyonglong <liuyonglong@huawei.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1730,6 +1730,12 @@ done:
 	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
 	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
 
+	/* Consider the case that autoneg was started and "aneg complete"
+	 * bit has been reset, but "link up" bit not yet.
+	 */
+	if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
+		phydev->link = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL(genphy_update_link);


