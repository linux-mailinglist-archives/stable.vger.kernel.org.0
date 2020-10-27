Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83A29C4BE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823051AbgJ0R5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901181AbgJ0OVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95B6F206D4;
        Tue, 27 Oct 2020 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808464;
        bh=jMSTFwM+xo8Bgsc7xtr2PkOuu7LgkCrmtXt/CTGRfjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg/2Y9xntVccSFOQCWYAp3Y23C6A/SAQ2L1Ak30UeCL+7fgN5gzAoX7kPbL3G68tq
         q1XC3WOIKszXwAYeVtuwfOeNrxRakRbDH5KQmhnY9kUGxIhi1wZta60Ld05w/DUiMk
         UGIWz2vwnRR+kSS0+pg/NCI3jK4R+6Sry8ObjiKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/264] net: dsa: rtl8366rb: Support all 4096 VLANs
Date:   Tue, 27 Oct 2020 14:52:39 +0100
Message-Id: <20201027135435.434207330@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a7920efdd86d8a0d74402dbc80ead03b023294ba ]

There is an off-by-one error in rtl8366rb_is_vlan_valid()
making VLANs 0..4094 valid while it should be 1..4095.
Fix it.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index f4b14b6acd22d..5aefd7a4696a5 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1270,7 +1270,7 @@ static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
 
-	if (vlan == 0 || vlan >= max)
+	if (vlan == 0 || vlan > max)
 		return false;
 
 	return true;
-- 
2.25.1



