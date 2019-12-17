Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385ED1220A0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfLQA4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:56:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35072 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MS-3N; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Yx-Ex; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Doug Berger" <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:46:51 +0000
Message-ID: <lsq.1576543535.9704780@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 077/136] net: phy: bcm7xxx: define soft_reset for
 40nm EPHY
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit fe586b823372a9f43f90e2c6aa0573992ce7ccb7 upstream.

The internal 40nm EPHYs use a "Workaround for putting the PHY in
IDDQ mode." These PHYs require a soft reset to restore functionality
after they are powered back up.

This commit defines the soft_reset function to use genphy_soft_reset
during phy_init_hw to accommodate this.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16:
 - Delete trailing backslash; there is a single entry for 40 nm PHYs
   and not a macro definition
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/phy/bcm7xxx.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -306,6 +306,7 @@ static struct phy_driver bcm7xxx_driver[
 	.features	= PHY_GBIT_FEATURES |
 			  SUPPORTED_Pause | SUPPORTED_Asym_Pause,
 	.flags		= PHY_IS_INTERNAL,
+	.soft_reset	= genphy_soft_reset,
 	.config_init	= bcm7xxx_config_init,
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= genphy_read_status,

