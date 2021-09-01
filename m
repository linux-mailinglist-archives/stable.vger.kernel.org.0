Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2B3FDC46
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbhIAMsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346094AbhIAMqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7040360041;
        Wed,  1 Sep 2021 12:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499983;
        bh=b4QX9l2JeanhLuJ65fU+MfkH0dwo1GAb0KNh5+IyX0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5sgOqDQFnn2ZnEJCC1F9v+GHe3engJus63xX168+jui2x738rd8AwudE4z06k0tR
         1ZMuhdokYm2wkEIhcmczhu4w5ye231smF7YM7ONtXVFxqYmNcaYH4aeStYjlofG258
         G5/KiE34TZpK+xsurvwrGoPJZ3a11WzHpNuW4a9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 057/113] net: dsa: hellcreek: Fix incorrect setting of GCL
Date:   Wed,  1 Sep 2021 14:28:12 +0200
Message-Id: <20210901122303.873808465@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit a7db5ed8632c88c029254d5d74765d52614af3fd ]

Currently the gate control list which is programmed into the hardware is
incorrect resulting in wrong traffic schedules. The problem is the loop
variables are incremented before they are referenced. Therefore, move the
increment to the end of the loop.

Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 50109218baad..3aab01c25f9a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1473,9 +1473,6 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 		u16 data;
 		u8 gates;
 
-		cur++;
-		next++;
-
 		if (i == schedule->num_entries)
 			gates = initial->gate_mask ^
 				cur->gate_mask;
@@ -1504,6 +1501,9 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 			(initial->gate_mask <<
 			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
 		hellcreek_write(hellcreek, data, TR_GCLCMD);
+
+		cur++;
+		next++;
 	}
 }
 
-- 
2.30.2



