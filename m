Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055526AE964
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjCGRXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjCGRXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F694F63
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB7E66150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C98C4339C;
        Tue,  7 Mar 2023 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209527;
        bh=ggjhY2VIrOaEhJBvVa2lDTDQMlqG/BGOo4AsLywwTsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICYkD0qhanLEOQM3XJ+4InSu5VcOBvZeCgdeZBioXG8oWexmaaXoB+ZbY1ZbzNztQ
         gO36JJhqKvp4o0QddNIZywt9EiljStuK8op16qwaHQzVdOffH+08QuwVrUgK5bbArJ
         gZDOPyVZmRMAM8gLEwa3oEtshWCnoONNHxaDwFqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0247/1001] wifi: mt76: mt7996: fix memory leak in mt7996_mcu_exit
Date:   Tue,  7 Mar 2023 17:50:19 +0100
Message-Id: <20230307170032.516984969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit da5b4d93e141b52c5a71d0c41a042d1bcaf70d2e ]

Always purge mcu skb queues in mt7996_mcu_exit routine even if
mt7996_firmware_state fails.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d781c6e0f33ac..d593ed9e3f73c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2460,13 +2460,14 @@ void mt7996_mcu_exit(struct mt7996_dev *dev)
 	__mt76_mcu_restart(&dev->mt76);
 	if (mt7996_firmware_state(dev, false)) {
 		dev_err(dev->mt76.dev, "Failed to exit mcu\n");
-		return;
+		goto out;
 	}
 
 	mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(0), MT_TOP_LPCR_HOST_FW_OWN);
 	if (dev->hif2)
 		mt76_wr(dev, MT_TOP_LPCR_HOST_BAND(1),
 			MT_TOP_LPCR_HOST_FW_OWN);
+out:
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 }
 
-- 
2.39.2



