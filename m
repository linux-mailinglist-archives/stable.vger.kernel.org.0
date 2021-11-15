Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A25C451FAC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350650AbhKPAoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343724AbhKOTVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76901635D8;
        Mon, 15 Nov 2021 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001902;
        bh=LqB4mW/Iahc4WSQEWaRmcSjU3xOXUljaega4n7VArFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcNsCcbMQRGU9uz8hcaSi1YArtU9iNMj8T0bvtjkXMsFj65z4eoRP6r4EB5Pjc8Ei
         i7BulCr213ahQTC1CTZA1ONN7DYXrRVo1tec+byHrqHSXHsgTCm/c/vm0wgqhMHHjl
         R/KZJ5imkkadCWWYsUPim74Sfjq5n0yv/CbIPR0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/917] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Mon, 15 Nov 2021 17:57:39 +0100
Message-Id: <20211115165441.105418927@linuxfoundation.org>
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

[ Upstream commit d8251b9db34a2cbc5619b610e7e8aad1d165c531 ]

We were checking that the MC (member config) was != 0
for some reason, all we need to check is that the config
has no ports, i.e. no members. Then it can be recycled.
This must be some misunderstanding.

Fixes: 4ddcaf1ebb5e ("net: dsa: rtl8366: Properly clear member config")
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 75897a3690969..ffbe5b6b2655b 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -457,7 +457,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 			 * anymore then clear the whole member
 			 * config so it can be reused.
 			 */
-			if (!vlanmc.member && vlanmc.untag) {
+			if (!vlanmc.member) {
 				vlanmc.vid = 0;
 				vlanmc.priority = 0;
 				vlanmc.fid = 0;
-- 
2.33.0



