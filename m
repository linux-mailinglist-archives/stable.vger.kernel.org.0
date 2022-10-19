Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57452604534
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiJSMZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbiJSMXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:23:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8841E696FB;
        Wed, 19 Oct 2022 04:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447AF6184A;
        Wed, 19 Oct 2022 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54681C433D6;
        Wed, 19 Oct 2022 08:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169469;
        bh=2+gx3wWCA2o5UX2WNEx+l1I7W2tZK/1eydy8g3EycQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqegrmoIt4n7t8Xh8hKdIxZRMKljSwEe6WP7J6WRRM6CN9hSiN1SwUlxan7qiRSAb
         IskXaTnwmbMZuYDEgBEnwNJ/EO/tCZDBl6DDNEbqtIavfWY3LgPmdUYKUo3dEOb/45
         MFAA+aSsDfbhZQoFua3GBD2jcRzwcqJSfMmGXcJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 288/862] wifi: mt76: mt7921: fix the firmware version report
Date:   Wed, 19 Oct 2022 10:26:15 +0200
Message-Id: <20221019083302.732187973@linuxfoundation.org>
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

[ Upstream commit 00be84d6dfc8319ed1864d3ca8658569d36a1882 ]

Fix the regression of the firmware version report since
'b9ec27102ac0 ('mt76: connac: move mt76_connac2_load_ram in connac
module')'.

Fixes: b9ec27102ac0 ("mt76: connac: move mt76_connac2_load_ram in connac module")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 13d4722e4186..7cac7b126e59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2888,6 +2888,10 @@ int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 		goto out;
 	}
 
+	snprintf(dev->hw->wiphy->fw_version,
+		 sizeof(dev->hw->wiphy->fw_version),
+		 "%.10s-%.15s", hdr->fw_ver, hdr->build_date);
+
 	release_firmware(fw);
 
 	if (!fw_wa)
-- 
2.35.1



