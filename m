Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD7603F4E
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiJSJbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJSJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:28:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E2CE8ABA;
        Wed, 19 Oct 2022 02:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 678D46183D;
        Wed, 19 Oct 2022 09:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79782C433D6;
        Wed, 19 Oct 2022 09:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170690;
        bh=qgniTSF+OJAJ5oQQqmSqvcCBvyeFINIUvqYDGmh5u6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf87kxdGBGyDX1vfq1dtL0QQcHEu8tC8Ceg4xzIFPr6+SG/TAIkrsxSvZvuhk0LNo
         b4iaOlzZf4+QWJeFQYokHPFyHixbkiGAPxiEWrCP1l6K+eYuSFpeKL9RUHQxWWvN4N
         mO0cG/31MbrBmRpBKFxBN0TFBW/P8UkAW7uFiqqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 706/862] wifi: rtw89: free unused skb to prevent memory leak
Date:   Wed, 19 Oct 2022 10:33:13 +0200
Message-Id: <20221019083321.171162167@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit eae672f386049146058b9e5d3d33e9e4af9dca1d ]

This avoid potential memory leak under power saving mode.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220916033811.13862-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index a5880a54812e..8b338e5ce364 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -872,6 +872,7 @@ int rtw89_h2c_tx(struct rtw89_dev *rtwdev,
 		rtw89_debug(rtwdev, RTW89_DBG_FW,
 			    "ignore h2c due to power is off with firmware state=%d\n",
 			    test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags));
+		dev_kfree_skb(skb);
 		return 0;
 	}
 
-- 
2.35.1



