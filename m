Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA63412490
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353241AbhITSfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380248AbhITSdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2617063301;
        Mon, 20 Sep 2021 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158896;
        bh=fhAlM7tXfgfz+PJ1/No1MPOY77yCuMAL+RYKZTGWvvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sLm7BXuej23reSCBoZBldkk8Sdy1/8JlYzshnSd7UdRMarz32z/RLxYpsKQ3Gyuc
         p53Md/6VJ7mtk8aYqtAkj6fzhv1urQrOyvHzCugfu1K2oV7Waa0XbNlaOhyme3Gwbb
         PXIa1CPz21KvpDU/mA7hlhL/gAeUUP4Bp07SfK9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/122] net: dsa: b53: Set correct number of ports in the DSA struct
Date:   Mon, 20 Sep 2021 18:44:38 +0200
Message-Id: <20210920163919.273487205@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit d12e1c4649883e8ca5e8ff341e1948b3b6313259 ]

Setting DSA_MAX_PORTS caused DSA to call b53 callbacks (e.g.
b53_disable_port() during dsa_register_switch()) for invalid
(non-existent) ports. That made b53 modify unrelated registers and is
one of reasons for a broken BCM5301x support.

This problem exists for years but DSA_MAX_PORTS usage has changed few
times. It seems the most accurate to reference commit dropping
dsa_switch_alloc() in the Fixes tag.

Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a8e915dd826a..54558f47b633 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2559,6 +2559,8 @@ static int b53_switch_init(struct b53_device *dev)
 	dev->enabled_ports |= BIT(dev->cpu_port);
 	dev->num_ports = fls(dev->enabled_ports);
 
+	dev->ds->num_ports = min_t(unsigned int, dev->num_ports, DSA_MAX_PORTS);
+
 	/* Include non standard CPU port built-in PHYs to be probed */
 	if (is539x(dev) || is531x5(dev)) {
 		for (i = 0; i < dev->num_ports; i++) {
@@ -2603,7 +2605,6 @@ struct b53_device *b53_switch_alloc(struct device *base,
 		return NULL;
 
 	ds->dev = base;
-	ds->num_ports = DSA_MAX_PORTS;
 
 	dev = devm_kzalloc(base, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
-- 
2.30.2



