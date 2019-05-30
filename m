Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DF22EB9B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfE3DOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbfE3DOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:31 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0DC224591;
        Thu, 30 May 2019 03:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186070;
        bh=vxd87k3H+JvbN92sWZXc8B0sMIw72/CKLNSmpZ/mxas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQPZF5Piqosx3/IYU+woKOQq1dlv9IxWgu/WUCthxSgVNXhZvUXkkJAI+7O3pS2Uc
         rJutTN+pUcJrAQrgd9pTUm9oForwOTrrJHgwK+R34jYYfGu3zqBjC9kN4G3EC2IyR1
         1xuHcgjYyAX5lYsSzdPWm7dO+BddsJHU79jfoldo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 185/346] scsi: libsas: Do discovery on empty PHY to update PHY info
Date:   Wed, 29 May 2019 20:04:18 -0700
Message-Id: <20190530030550.472605717@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index f21c93bbb35c7..a761f5019b07e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2024,6 +2024,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
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



