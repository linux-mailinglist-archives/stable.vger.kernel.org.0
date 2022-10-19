Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8068E604872
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiJSN4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiJSNyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:54:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F6D1DC822;
        Wed, 19 Oct 2022 06:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC95B82388;
        Wed, 19 Oct 2022 08:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810DBC433D6;
        Wed, 19 Oct 2022 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169434;
        bh=+Gu7QzlWRpwbVMYhNonG5PitRlXoTuYCdza+QJFhkd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYSjYRYbOXpjr/m6gPmYL/GRNQ647U2sx8quYnxeiYRGCtTwR48GsSpDOU7koccM6
         JakXJ1vOsC/srAGoX6m+NTRE/3StYQHisOJRE+LEKT0IacsQQz8UpmUm4xGCuJfeTz
         2mp/b6lWiCQfcitah2UFpq691LhhsZUAxtOOF0tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 276/862] wifi: mt76: mt7921s: fix race issue between reset and suspend/resume
Date:   Wed, 19 Oct 2022 10:26:03 +0200
Message-Id: <20221019083302.219343270@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit e86f10e6809add9132ecc2c6b3184ed59db7ca71 ]

It is unexpected that the reset work is running simultaneously with
the suspend or resume context and it is possible that reset work is still
running even after mt7921 is suspended if we don't fix the race issue.

Thus, the suspend procedure should be waiting until the reset is completed
at the beginning and ignore the subsequent the reset requests.

In case there is an error that happens during either suspend or resume
handler, we will schedule a reset task to recover the error before
returning the error code to ensure we can immediately fix the error there.

Fixes: ca74b9b907f9 ("mt76: mt7921s: add reset support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 487acd6e2be8..2face849fb4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -206,6 +206,7 @@ static int mt7921s_suspend(struct device *__dev)
 	pm->suspended = true;
 	set_bit(MT76_STATE_SUSPEND, &mdev->phy.state);
 
+	flush_work(&dev->reset_work);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
@@ -261,6 +262,9 @@ static int mt7921s_suspend(struct device *__dev)
 	clear_bit(MT76_STATE_SUSPEND, &mdev->phy.state);
 	pm->suspended = false;
 
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
 	return err;
 }
 
@@ -276,7 +280,7 @@ static int mt7921s_resume(struct device *__dev)
 
 	err = mt7921_mcu_drv_pmctrl(dev);
 	if (err < 0)
-		return err;
+		goto failed;
 
 	mt76_worker_enable(&mdev->tx_worker);
 	mt76_worker_enable(&mdev->sdio.txrx_worker);
@@ -288,11 +292,12 @@ static int mt7921s_resume(struct device *__dev)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
 
 	err = mt76_connac_mcu_set_hif_suspend(mdev, false);
-	if (err)
-		return err;
-
+failed:
 	pm->suspended = false;
 
+	if (err < 0)
+		mt7921_reset(&dev->mt76);
+
 	return err;
 }
 
-- 
2.35.1



