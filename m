Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F535947EA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354394AbiHOXsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355045AbiHOXrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:47:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607DB1117;
        Mon, 15 Aug 2022 13:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50784B80EB1;
        Mon, 15 Aug 2022 20:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70ECC433C1;
        Mon, 15 Aug 2022 20:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594513;
        bh=ipv9dfXXVqAtoVR/NxjiBYzy9by7wrxc6uBHn0fl/lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9noWkexd5sBS3/3/I0yST62q9v6hPTF4+Xii8ImtlwAH8EAF0N4hRK54hOHJoy/1
         Id7Kn+V61cBm5LpTvstAkdrt7Dj6tRS/QLRxkLcU7oonGPpwT5kFT7FEjaKBgtjMW1
         uJCHfYsjNGAeDgnqgnVOq0Q7QFYI9zYu9Owb0iXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0470/1157] mt76: mt7915: fix endian bug in mt7915_rf_regval_set()
Date:   Mon, 15 Aug 2022 19:57:06 +0200
Message-Id: <20220815180458.411176288@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f572dc969a59a80baa22bf2f7c9af0064402652f ]

This code is supposed to set a u32 value, but casting will not work on
big endian systems.

Fixes: 0a17329ae9c1 ("mt76: mt7915: add debugfs knob for RF registers read/write")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index d0c719ecacd0..fd76db8f5269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -985,8 +985,9 @@ static int
 mt7915_rf_regval_set(void *data, u64 val)
 {
 	struct mt7915_dev *dev = data;
+	u32 val32 = val;
 
-	return mt7915_mcu_rf_regval(dev, dev->mt76.debugfs_reg, (u32 *)&val, true);
+	return mt7915_mcu_rf_regval(dev, dev->mt76.debugfs_reg, &val32, true);
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_rf_regval, mt7915_rf_regval_get,
-- 
2.35.1



