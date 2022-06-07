Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A58541B07
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378042AbiFGVmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381078AbiFGVj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:39:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3092E232364;
        Tue,  7 Jun 2022 12:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEE0BB8220B;
        Tue,  7 Jun 2022 19:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47248C385A2;
        Tue,  7 Jun 2022 19:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628747;
        bh=/hO7V1E4bGRZIAjtvHweCl5D4LwDlWhO4XIrdlNKhT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrMj/XQm6ZyOL99j2QdBHy+/HlCNA+c2FWE5mIgMFNcZuF4lMqf964cH+rLNg8xtv
         bnk1Q6ozBmdkt+asTUz0QfxfNGweh6jWV9fmElNQvEzhmQGpFkoe+8tPP/rVDhgLRt
         LMCdsf4oPCNis1SiaNEWwgTJxoLWJus2cQXzFAAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 441/879] mt76: mt7915: fix twt table_mask to u16 in mt7915_dev
Date:   Tue,  7 Jun 2022 18:59:19 +0200
Message-Id: <20220607165015.672004666@linuxfoundation.org>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 3620c8821ae15902eb995a32918e34b7a0c773a3 ]

mt7915 can support 16 twt stations so modify table_mask to u16.

Fixes: 3782b69d03e7 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 6efa0a2e2345..4b6eda958ef3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -319,7 +319,7 @@ struct mt7915_dev {
 	void *cal;
 
 	struct {
-		u8 table_mask;
+		u16 table_mask;
 		u8 n_agrt;
 	} twt;
 
-- 
2.35.1



