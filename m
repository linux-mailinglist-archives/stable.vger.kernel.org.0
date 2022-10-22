Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C96086C9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiJVHx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiJVHv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B87AC28F;
        Sat, 22 Oct 2022 00:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F08760B27;
        Sat, 22 Oct 2022 07:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B30EC433C1;
        Sat, 22 Oct 2022 07:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424657;
        bh=9vXiCE0BvIwGv1vGlOobuOURIED+4AIDnWGgCQuShT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/gN75wpAD6xAqLasLfbitG1V6UnwqmJyx6E0dg7k/xh9BG1LnCLhwMIn8a07dFyy
         nLdoU6LS/Gv3FeZbeZ+n//EICKcXbtOcZYDbtDD9MdOjgu5IkHIMV+QYGTzNy6kA9G
         NBlaghs0rx3bg0CleGrE+TR7fhisI52KoCFQJZL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 226/717] wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
Date:   Sat, 22 Oct 2022 09:21:45 +0200
Message-Id: <20221022072455.101563057@linuxfoundation.org>
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
index 8b2ca9e8eac6..7f09359a238f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1878,13 +1878,6 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
 
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
@@ -1895,6 +1888,13 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
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



