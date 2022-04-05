Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C954F28C1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiDEIVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiDEIHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D896A07A;
        Tue,  5 Apr 2022 01:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75B75B81BBE;
        Tue,  5 Apr 2022 08:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB16C385A0;
        Tue,  5 Apr 2022 08:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145712;
        bh=a+/N5IUO25mLVD4HlbVJH05aMl0d8x/LKcPMRt4VXv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNUjP9K4BHJo/DI08vnRiImQ+QVJ6hLZqxTMg0WLqw18aJji8yZshayJKrPImDaDc
         ftrMUPbRlJsTOSU97Cut//q96cnC0vDnyBxn26gwiblyFVmwRQgS1aGs/pCNmmtK3u
         GomRy89E7575vEUIXs6Vb1IJYaV0FLctPHrTqoxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0501/1126] mt76: mt7921: fix ht mcs in mt7921_mac_add_txs_skb()
Date:   Tue,  5 Apr 2022 09:20:48 +0200
Message-Id: <20220405070422.332611285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit b1fe07ed21024f64719315ba0f3a5676d8b36db6 ]

The mcs value of HT mode reported by mt7921_mac_add_txs_skb()
has already been converted to the expected format.

Fixes: 970ab80ef9f63 ("mt76: mt7921: report tx rate directly from tx status")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 3e83a0c33143..c6a849ee817c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1092,7 +1092,6 @@ mt7921_mac_add_txs_skb(struct mt7921_dev *dev, struct mt76_wcid *wcid, int pid,
 		break;
 	case MT_PHY_TYPE_HT:
 	case MT_PHY_TYPE_HT_GF:
-		rate.mcs += (rate.nss - 1) * 8;
 		if (rate.mcs > 31)
 			goto out;
 
-- 
2.34.1



