Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6BC2D6871
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 21:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390108AbgLJUPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 15:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728790AbgLJO2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:23 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 08/39] net: pasemi: fix error return code in pasemi_mac_open()
Date:   Thu, 10 Dec 2020 15:26:19 +0100
Message-Id: <20201210142601.305082512@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit aba84871bd4f52c4dfcf3ad5d4501a6c9d2de90e ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 72b05b9940f0 ("pasemi_mac: RX/TX ring management cleanup")
Fixes: 8d636d8bc5ff ("pasemi_mac: jumbo frame support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1606903035-1838-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1129,16 +1129,20 @@ static int pasemi_mac_open(struct net_de
 
 	mac->tx = pasemi_mac_setup_tx_resources(dev);
 
-	if (!mac->tx)
+	if (!mac->tx) {
+		ret = -ENOMEM;
 		goto out_tx_ring;
+	}
 
 	/* We might already have allocated rings in case mtu was changed
 	 * before interface was brought up.
 	 */
 	if (dev->mtu > 1500 && !mac->num_cs) {
 		pasemi_mac_setup_csrings(mac);
-		if (!mac->num_cs)
+		if (!mac->num_cs) {
+			ret = -ENOMEM;
 			goto out_tx_ring;
+		}
 	}
 
 	/* Zero out rmon counters */


