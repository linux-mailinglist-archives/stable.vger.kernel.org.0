Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71103290DF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhCAUQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239596AbhCAUGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:06:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE7864F58;
        Mon,  1 Mar 2021 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621537;
        bh=9gryNzoOiLzEah55G3bfCjxzAxuy2v+KmEf+keOf3jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LG7vYbEGXyuAtiCMm6/QAInnpgymMAytUsHFUXk8xz1fGJfoCZ46bseqk4vu66vOy
         ivyYmjEvfbenjKz4a+WhO9mUAT3buLGTyPy5nVSA22BshBNvnL9pr/gTyyj1fMRrti
         PwJK/rCYL+XMZ00JlNRE0dFyrFIZcjhXFfQcyUD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Melki <christian.melki@t2data.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 552/775] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
Date:   Mon,  1 Mar 2021 17:12:00 +0100
Message-Id: <20210301161228.761716968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Melki <christian.melki@t2data.com>

[ Upstream commit 764d31cacfe48440745c4bbb55a62ac9471c9f19 ]

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

Bluntly removing that default may expose a lot of situations where various
PHYs/board implementations won't recover on various changes.
Like with this implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if it
did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210224205536.9349-1-christian.melki@t2data.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203dac..57f8021b70af5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1295,6 +1295,7 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8081_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.27.0



