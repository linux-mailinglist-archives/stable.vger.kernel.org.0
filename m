Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0D6086F1
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiJVHz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiJVHxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065CA29B8A4;
        Sat, 22 Oct 2022 00:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFF1C60BB9;
        Sat, 22 Oct 2022 07:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40DBC433D6;
        Sat, 22 Oct 2022 07:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424716;
        bh=tIBsBLLuzY+hkWm+XuxHlNQ6uSDfN7fZPVjIX6Wp4vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYlEwSdFGbUMqTGAZufY+87fuA3b8XGCo0NJH/rd68EDQmOugrQtgjJF5enkmvBeo
         ovskoGHRdviYlu0ir8lNUzn7LTRheuOhSYhveaHP3tcGirN6mbinnSGKMwADkyMtj9
         8dmzIAWkjQH1nYFQOFBFzHwNry3996lubT2axyXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 249/717] wifi: mt76: mt7915: do not check state before configuring implicit beamform
Date:   Sat, 22 Oct 2022 09:22:08 +0200
Message-Id: <20221022072458.937520590@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fd76db8f5269..6ef3431cad64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -23,9 +23,9 @@ mt7915_implicit_txbf_set(void *data, u64 val)
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



