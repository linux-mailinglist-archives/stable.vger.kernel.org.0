Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAF29B092
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901184AbgJ0OVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901169AbgJ0OU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2BF6206D4;
        Tue, 27 Oct 2020 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808456;
        bh=kAIq855fC74ZltoAnwvgBoKJnImRxtTXpUe4V7emtII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1F5rGN1N5DFt4I4R0aFZec44bt3Hj8j1DqToWWmjbTlZPa3fB4YttqgCgbN85DXG
         JW7Q7oQtl1P5d0tlK4NyP9oGyyyp2Vxx80NrxhAjybyH4bRx1UoAx1rjDE71lAwqqf
         4fxBRVrMr+PD6oacELeDdnK4Y4YgiGwhwIpvQXu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/264] net: dsa: rtl8366: Check validity of passed VLANs
Date:   Tue, 27 Oct 2020 14:52:36 +0100
Message-Id: <20201027135435.299288528@linuxfoundation.org>
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

[ Upstream commit 6641a2c42b0a307b7638d10e5d4b90debc61389d ]

The rtl8366_set_vlan() and rtl8366_set_pvid() get invalid
VLANs tossed at it, especially VLAN0, something the hardware
and driver cannot handle. Check validity and bail out like
we do in the other callbacks.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rtl8366.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 430988f797225..c854fea473f76 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,6 +43,9 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	dev_dbg(smi->dev,
 		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, member, untag);
@@ -118,6 +121,9 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-- 
2.25.1



