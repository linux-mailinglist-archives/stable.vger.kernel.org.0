Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E112603E6F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJSJPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJSJMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA4AC8976;
        Wed, 19 Oct 2022 02:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4090561857;
        Wed, 19 Oct 2022 08:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472FBC433D7;
        Wed, 19 Oct 2022 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169450;
        bh=mNavhjTu2yfMxnJCyu1lv2P3CIMvrTtMyZ8wrnDm0f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/MCH9oZqMQ6qDPIA5ZPZdJAuY1eCwawU6kw4ptY9gdpUvXaqeVWNki59iYVGd8Nn
         2/nopqh3jfBES8auM3FfqZPrreR0Nc2erriTR7QwJx3/cHvgACw3PTqVMNavajgHgl
         50lnW777kMlbN3Sz2fuJIzSvhuE9xUhjiwDT4/7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        YN Chen <yn.chen@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 282/862] wifi: mt76: sdio: fix transmitting packet hangs
Date:   Wed, 19 Oct 2022 10:26:09 +0200
Message-Id: <20221019083302.482931288@linuxfoundation.org>
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

From: YN Chen <yn.chen@mediatek.com>

[ Upstream commit 250b1827205846ff346a76044955cb79d4963f70 ]

Fix transmitting packets hangs with continuing to pull the pending packet
from mac80211 queues when receiving Tx status notification from the device.

Fixes: aac5104bf631 ("mt76: sdio: do not run mt76_txq_schedule directly")
Acked-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index ece4e4bb94a1..0ec308f99af5 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -485,7 +485,7 @@ static void mt76s_status_worker(struct mt76_worker *w)
 	} while (nframes > 0);
 
 	if (resched)
-		mt76_worker_schedule(&dev->sdio.txrx_worker);
+		mt76_worker_schedule(&dev->tx_worker);
 }
 
 static void mt76s_tx_status_data(struct work_struct *work)
-- 
2.35.1



