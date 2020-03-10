Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB117F9A8
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgCJM6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgCJM6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2672468F;
        Tue, 10 Mar 2020 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845132;
        bh=VwhYKLy1NhWaPZdxdXJS0pwQhJAtWfm9/KXs9tu/rec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyYUMSDvTN9giMlyPEqLyuIwlptZYzxt/4Y4u2d2gLeO7Y0oOEU8cFfiefVvQwHpY
         alWPeW0Ehi5b0M/HDDCnm/jxXAkAoxjmegwVN1lVmm5rBlqMicYvkWxsJM1zEtp5iO
         2w1J5pffflB3iWG9huB1FZ60UCHWidJ11Nk+38X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Mathieu Malaterre <malat@debian.org>,
        Paul Cercueil <paul@crapouillou.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 036/189] net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()
Date:   Tue, 10 Mar 2020 13:37:53 +0100
Message-Id: <20200310123643.131602714@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 9a6a0dea16177ccaecc116f560232e63bec115f1 ]

The call to of_get_mac_address() can return -EPROBE_DEFER, for instance
when the MAC address is read from a NVMEM driver that did not probe yet.

Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index cce90b5925d93..70060c51854fd 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1405,6 +1405,8 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
 		ether_addr_copy(pdata->dev_addr, mac_addr);
+	else if (PTR_ERR(mac_addr) == -EPROBE_DEFER)
+		return ERR_CAST(mac_addr);
 
 	return pdata;
 }
-- 
2.20.1



