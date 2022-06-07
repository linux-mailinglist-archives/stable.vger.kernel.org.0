Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A83B541AD4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380893AbiFGVix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380124AbiFGViN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E6223144F;
        Tue,  7 Jun 2022 12:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26118B8220B;
        Tue,  7 Jun 2022 19:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F138C385A2;
        Tue,  7 Jun 2022 19:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628711;
        bh=enkXLlOMaVEcu6u+aCpOHVMFbZ5zMyBAllMcpO7dxzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0r0vgYiYlZhsvc9jJ6R+Iyn+X1YR9fRk49A4u4/ZxKbRge/MK2ikCyHoXnnH4tZq
         y7lcs15PG/yITIm1tBjEcQMKS1Q/eypvcm9wWvx5ST2cWFpFG2cgaJYTfVwsttOB30
         EApQXeArKW47d7A5sj0gcyeNlRLdpkkn5ucqzJ84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 429/879] mt76: mt7915: fix DBDC default band selection on MT7915D
Date:   Tue,  7 Jun 2022 18:59:07 +0200
Message-Id: <20220607165015.320549965@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 96c777708bcac53f73a1c079e416495647f69553 ]

This code was accidentally dropped while adding 6 GHz support

Fixes: b4d093e321bd ("mt76: mt7915: add 6 GHz support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 5b133bcdab17..4b1a9811646f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -152,6 +152,8 @@ static void mt7915_eeprom_parse_band_config(struct mt7915_phy *phy)
 			phy->mt76->cap.has_2ghz = true;
 			return;
 		}
+	} else if (val == MT_EE_BAND_SEL_DEFAULT && dev->dbdc_support) {
+		val = phy->band_idx ? MT_EE_BAND_SEL_5GHZ : MT_EE_BAND_SEL_2GHZ;
 	}
 
 	switch (val) {
-- 
2.35.1



