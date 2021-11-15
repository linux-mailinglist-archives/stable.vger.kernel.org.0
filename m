Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D9E451FA0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348199AbhKPAos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343722AbhKOTVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11B53635D4;
        Mon, 15 Nov 2021 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001899;
        bh=QcCQOdEmr1MxmvKPwwmL5ZK+PW/WtjlkHCh+NjxZx08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0zSa6k6fQRCkeuaXxn/8hMRj4oHYr3XTrAh+Q8GDJ+YDXZiJH+D/xAcO9EUrpTyI
         2H5yEiDgm7aQJrrcnHWMySkiKEWn/iBMxvp0aYF0YI71wwhipffy/lHV94MvcKSM9S
         zRmUy5/OnKtB5gN5fBrDKqD452LWIpTXAEWvJ7j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/917] net: dsa: rtl8366rb: Fix off-by-one bug
Date:   Mon, 15 Nov 2021 17:57:38 +0100
Message-Id: <20211115165441.073764494@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 5f5f12f5d4b108399130bb5c11f07765851d9cdb ]

The max VLAN number with non-4K VLAN activated is 15, and the
range is 0..15. Not 16.

The impact should be low since we by default have 4K VLAN and
thus have 4095 VLANs to play with in this switch. There will
not be a problem unless the code is rewritten to only use
16 VLANs.

Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6ad..9e3b572ed999e 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1350,7 +1350,7 @@ static int rtl8366rb_set_mc_index(struct realtek_smi *smi, int port, int index)
 
 static bool rtl8366rb_is_vlan_valid(struct realtek_smi *smi, unsigned int vlan)
 {
-	unsigned int max = RTL8366RB_NUM_VLANS;
+	unsigned int max = RTL8366RB_NUM_VLANS - 1;
 
 	if (smi->vlan4k_enabled)
 		max = RTL8366RB_NUM_VIDS - 1;
-- 
2.33.0



