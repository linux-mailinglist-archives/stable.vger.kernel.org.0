Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686FF603EF5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJSJZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbiJSJYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8244C512C;
        Wed, 19 Oct 2022 02:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DBF61881;
        Wed, 19 Oct 2022 09:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE78C433D6;
        Wed, 19 Oct 2022 09:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170523;
        bh=Kh8Sla+Un1KkjfHIh8LWbAk/NpfHmZyyc25lnnifXUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZvWdf5fteZLWm92HtK/gkC+EEh8tHLxc5ZWTc3oFGo+UfJU1Wr6taiZJAAfMVpfu
         qxFz8Pc9m9cEp+5G/Q0OHtCEIHHNaPlmyZJsADwXJ9a/q52aJwQwOHzLSUviPVy9/7
         NXtreP4JNzTU+11Xe/UaxXss0r+hjOEBiQBefwzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Ray <jerry.ray@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 688/862] micrel: ksz8851: fixes struct pointer issue
Date:   Wed, 19 Oct 2022 10:32:55 +0200
Message-Id: <20221019083320.383736530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit fef5de753ff01887cfa50990532c3890fccb9338 ]

Issue found during code review. This bug has no impact as long as the
ks8851_net structure is the first element of the ks8851_net_spi structure.
As long as the offset to the ks8851_net struct is zero, the container_of()
macro is subtracting 0 and therefore no damage done. But if the
ks8851_net_spi struct is ever modified such that the ks8851_net struct
within it is no longer the first element of the struct, then the bug would
manifest itself and cause problems.

struct ks8851_net is contained within ks8851_net_spi.
ks is contained within kss.
kss is the priv_data of the netdev structure.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_spi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 82d55fc27edc..70bc7253454f 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -413,7 +413,8 @@ static int ks8851_probe_spi(struct spi_device *spi)
 
 	spi->bits_per_word = 8;
 
-	ks = netdev_priv(netdev);
+	kss = netdev_priv(netdev);
+	ks = &kss->ks8851;
 
 	ks->lock = ks8851_lock_spi;
 	ks->unlock = ks8851_unlock_spi;
@@ -433,8 +434,6 @@ static int ks8851_probe_spi(struct spi_device *spi)
 		 IRQ_RXPSI)	/* RX process stop */
 	ks->rc_ier = STD_IRQ;
 
-	kss = to_ks8851_spi(ks);
-
 	kss->spidev = spi;
 	mutex_init(&kss->lock);
 	INIT_WORK(&kss->tx_work, ks8851_tx_work);
-- 
2.35.1



