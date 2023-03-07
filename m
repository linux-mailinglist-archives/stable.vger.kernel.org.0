Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2E6AE898
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCGRRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjCGRRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14157D98
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97620B819A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE69C433EF;
        Tue,  7 Mar 2023 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209173;
        bh=HfaJWHZl+JH43C1Bek46RIqZuuGlw8+EzMGUtsguQ8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpYyhrfqO0DUOcyKuhuE9VPayg3sWy2xJHNGjLlx+8EwfigZydcVhfiIRH5I7Mji0
         8ljLoNNh0XpglS3MmrcQvF13zhK/5HMzLrclJHFkoRwKKHmpqHpwubNmwiDxUPaUs4
         8JEr2uizKU7DRxcpO8xHJ8kngixzg3rj0bALl5H4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0134/1001] wifi: mt76: mt7915: fix mt7915_rate_txpower_get() resource leaks
Date:   Tue,  7 Mar 2023 17:48:26 +0100
Message-Id: <20230307170027.883997394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 8b25301af01566f4b5a301fc1ad7c5d2b1788d7f ]

Coverity message: variable "buf" going out of scope leaks the storage.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527799 ("Resource leaks")
Fixes: e3296759f347 ("wifi: mt76: mt7915: enable per bandwidth power limit support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index fb46c2c1784f2..a7fdcd1f3d988 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -996,7 +996,7 @@ mt7915_rate_txpower_get(struct file *file, char __user *user_buf,
 
 	ret = mt7915_mcu_get_txpower_sku(phy, txpwr, sizeof(txpwr));
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Txpower propagation path: TMAC -> TXV -> BBP */
 	len += scnprintf(buf + len, sz - len,
@@ -1047,6 +1047,8 @@ mt7915_rate_txpower_get(struct file *file, char __user *user_buf,
 			 mt76_get_field(dev, reg, MT_WF_PHY_TPC_POWER));
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+out:
 	kfree(buf);
 	return ret;
 }
-- 
2.39.2



