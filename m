Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C553260A3DF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiJXMAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiJXL7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA6D7C32C;
        Mon, 24 Oct 2022 04:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D4A61218;
        Mon, 24 Oct 2022 11:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EFDC433C1;
        Mon, 24 Oct 2022 11:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612136;
        bh=imA00XoB1QibGoVcRmf2HbsfpTiVfj/6N8ZW4ewYQOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIoaaeJvQm8+wEVC0A64vux79lGAFWdYbk19XdVRNqZWSTjedhP+BzH3rRO2F+MKr
         ODeNn95JzJLzRmEfRXhw4WoJebRoJmQor7FVSsHAE9MvAndyoM2N25VoF+zVKztlqV
         cNFy1dKE2Vf+4AeQDLBK/gOxZoBWXK9EA9TES44E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/210] wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
Date:   Mon, 24 Oct 2022 13:30:01 +0200
Message-Id: <20221024112959.780851591@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 620d5eaeb9059636864bda83ca1c68c20ede34a5 ]

There some bounds checking to ensure that "map_addr" is not out of
bounds before the start of the loop.  But the checking needs to be
done as we iterate through the loop because "map_addr" gets larger as
we iterate.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/Yv8eGLdBslLAk3Ct@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5cf61710ae2f..5588518daa96 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1879,13 +1879,6 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
 		/* We have 8 bits to indicate validity */
 		map_addr = offset * 8;
-		if (map_addr >= EFUSE_MAP_LEN) {
-			dev_warn(dev, "%s: Illegal map_addr (%04x), "
-				 "efuse corrupt!\n",
-				 __func__, map_addr);
-			ret = -EINVAL;
-			goto exit;
-		}
 		for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
 			/* Check word enable condition in the section */
 			if (word_mask & BIT(i)) {
@@ -1896,6 +1889,13 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
 			if (ret)
 				goto exit;
+			if (map_addr >= EFUSE_MAP_LEN - 1) {
+				dev_warn(dev, "%s: Illegal map_addr (%04x), "
+					 "efuse corrupt!\n",
+					 __func__, map_addr);
+				ret = -EINVAL;
+				goto exit;
+			}
 			priv->efuse_wifi.raw[map_addr++] = val8;
 
 			ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &val8);
-- 
2.35.1



