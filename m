Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D673FDC55
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244950AbhIAMsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346108AbhIAMqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C8760F21;
        Wed,  1 Sep 2021 12:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499985;
        bh=61Y4GfhL+M18hLC2f3AjSkmVlrnA73wa5mJG+u5J43w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSMjB7RNwNx1ENS99Zj6y8txzzcIr5VONTJBnAGr2ZKTJjXPBsYMERam5ZkFhp9wF
         /juI5H/JnqT76QYuQsW/0MWu5PGY4QP3Y++uXM+5r8X0LLvEWZaaoveLos3iNbvt+c
         9riVSbqxdrNP61qPwXidWigNhKDdAVPi9FJYVoLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 058/113] net: dsa: hellcreek: Adjust schedule look ahead window
Date:   Wed,  1 Sep 2021 14:28:13 +0200
Message-Id: <20210901122303.908423946@linuxfoundation.org>
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

[ Upstream commit b7658ed35a5f5900f0f658e375f366513f3eb781 ]

Traffic schedules can only be started up to eight seconds within the
future. Therefore, the driver periodically checks every two seconds whether the
admin base time provided by the user is inside that window. If so the schedule
is started. Otherwise the check is deferred.

However, according to the programming manual the look ahead window size should
be four - not eight - seconds. By using the proposed value of four seconds
starting a schedule at a specified admin base time actually works as expected.

Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 3aab01c25f9a..512b1810a8bd 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1551,7 +1551,7 @@ static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
 	/* Calculate difference to admin base time */
 	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
 
-	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;
+	return base_time_ns - current_ns < (s64)4 * NSEC_PER_SEC;
 }
 
 static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
-- 
2.30.2



