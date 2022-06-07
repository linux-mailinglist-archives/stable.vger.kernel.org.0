Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A296541AD7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380655AbiFGVjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380851AbiFGViQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEDE1C13A;
        Tue,  7 Jun 2022 12:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78435617EE;
        Tue,  7 Jun 2022 19:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849F4C385A2;
        Tue,  7 Jun 2022 19:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628725;
        bh=Whr85xBJzYK0FWJhwzET+EpOWlc68uR+NHnFIy1/Ln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vHMLFaMAKNoMUmufzO+LZ0KJhvjvNMsg+HtCBwU+a1ObRr+ZpQrAvpv62QMgeW+8
         lUuREANm2icpYl66d3EssrGGrEdzZwe3bK44iAbXx1wWVLZ8Y672UnFvmHnvBFoJhe
         gqnUrplXln30JVICLjrxSK9NBQlY6xDwqczDslss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 433/879] mt76: mt7915: fix possible uninitialized pointer dereference in mt7986_wmac_gpio_setup
Date:   Tue,  7 Jun 2022 18:59:11 +0200
Message-Id: <20220607165015.438710968@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9bd6823f5a64b6465708b244eecc9b7dd4b01bfc ]

Add default case for type switch in mt7986_wmac_gpio_setup routine in
order to avoid a possible uninitialized pointer dereference.

Fixes: 99ad32a4ca3a2 ("mt76: mt7915: add support for MT7986")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 3028c02cb840..be448d471b03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -210,6 +210,8 @@ static int mt7986_wmac_gpio_setup(struct mt7915_dev *dev)
 		if (IS_ERR_OR_NULL(state))
 			return -EINVAL;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	ret = pinctrl_select_state(pinctrl, state);
-- 
2.35.1



