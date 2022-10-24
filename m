Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3494E60AB52
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiJXNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbiJXNtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:49:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA120B601C;
        Mon, 24 Oct 2022 05:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DEA161325;
        Mon, 24 Oct 2022 12:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F21BC433D7;
        Mon, 24 Oct 2022 12:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615240;
        bh=Y8i6qm5VeunCheqmpXC5AquJIRvQ8kPAhWHotNHrpjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzkNpK2Uy+XTjAM4tcuT0KR62sXfQG+vQo12XJYSXDD9/SwkqvnBJm5NLurMw/vvg
         mgnYE+fHOQzrnNPxnhUkJ+3j3euvwvJsWvI5Bh80TiX3vfRqZsrhNJH2bQbYNFsA/q
         mf7ZgS4USb84llRXHYoPQs1T9dYeXY8jK81CwL5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/530] wifi: mt76: mt7915: do not check state before configuring implicit beamform
Date:   Mon, 24 Oct 2022 13:28:40 +0200
Message-Id: <20221024113052.983268479@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit d2b5bb6dfab29fe32bedefaade88dcd182c03a00 ]

Do not need to check running state before configuring implicit Tx
beamform. It is okay to configure implicit Tx beamform in run time.
Noted that the existing connected stations will be applied for new
configuration only if they reconnected to the interface.

Fixes: 6d6dc980e07d ("mt76: mt7915: add implicit Tx beamforming support")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 64048243e34b..31c1d4bc78dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -12,9 +12,9 @@ mt7915_implicit_txbf_set(void *data, u64 val)
 {
 	struct mt7915_dev *dev = data;
 
-	if (test_bit(MT76_STATE_RUNNING, &dev->mphy.state))
-		return -EBUSY;
-
+	/* The existing connected stations shall reconnect to apply
+	 * new implicit txbf configuration.
+	 */
 	dev->ibf = !!val;
 
 	return mt7915_mcu_set_txbf(dev, MT_BF_TYPE_UPDATE);
-- 
2.35.1



