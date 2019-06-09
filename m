Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA9C3A98C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388204AbfFIRCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbfFIRCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B93206DF;
        Sun,  9 Jun 2019 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099726;
        bh=cUOQWn5WeOO5C2d4/1sFxufHKsFKwSesPfLkcaF011Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0HeocPOVtonDebkj+FWHzqtu5RlWB9KQ2TQDAhJmXoFrDVHGGLNpUvIl5h+wWT0z
         hDpJDR68NXGVF2/9jZoEbSzMp0r9+OSvT/ZZkNpyCFNAFAx821VP2ZKSs65fW8vobL
         N5VNltxOQV4CO5MEfSVY5T+/MtQi6UyvPKLtbjOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 137/241] scsi: libsas: Do discovery on empty PHY to update PHY info
Date:   Sun,  9 Jun 2019 18:41:19 +0200
Message-Id: <20190609164151.745938786@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d8649fc1c5e40e691d589ed825998c36a947491c ]

When we discover the PHY is empty in sas_rediscover_dev(), the PHY
information (like negotiated linkrate) is not updated.

As such, for a user examining sysfs for that PHY, they would see
incorrect values:

root@(none)$ cd /sys/class/sas_phy/phy-0:0:20
root@(none)$ more negotiated_linkrate
3.0 Gbit
root@(none)$ echo 0 > enable
root@(none)$ more negotiated_linkrate
3.0 Gbit

So fix this, simply discover the PHY again, even though we know it's empty;
in the above example, this gives us:

root@(none)$ more negotiated_linkrate
Phy disabled

We must do this after unregistering the device associated with the PHY
(in sas_unregister_devs_sas_addr()).

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 1a6f65db615e8..ee1f9ee995e53 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2027,6 +2027,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 	if ((SAS_ADDR(sas_addr) == 0) || (res == -ECOMM)) {
 		phy->phy_state = PHY_EMPTY;
 		sas_unregister_devs_sas_addr(dev, phy_id, last);
+		/*
+		 * Even though the PHY is empty, for convenience we discover
+		 * the PHY to update the PHY info, like negotiated linkrate.
+		 */
+		sas_ex_phy_discover(dev, phy_id);
 		return res;
 	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
 		   dev_type_flutter(type, phy->attached_dev_type)) {
-- 
2.20.1



