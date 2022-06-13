Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C497548BF7
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354220AbiFMMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357662AbiFMMOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E48153E17;
        Mon, 13 Jun 2022 04:01:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A614C61478;
        Mon, 13 Jun 2022 11:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBCBC34114;
        Mon, 13 Jun 2022 11:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118088;
        bh=QhgWGVR+zYGZRPA0FLIf+uvi9B24gkzMv4zcs8MySP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5lkt0r03zjYf5lkoyrcJBaPuacYr7gFJlTbPkEQL8wGY55i/9AH44Li/bLlvXsfq
         PZSyfFP6fTEAPW+kkSHk33LxZ2gFTkove1FJw65Ojv1OAi8RI+l7owis9cE8FXj61F
         hdUXXgI/kcBif69GtiKAZ5N0Kn0Zwd0qIkCdh+DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/287] net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure
Date:   Mon, 13 Jun 2022 12:11:03 +0200
Message-Id: <20220613094931.263595276@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit f5826c8c9d57210a17031af5527056eefdc2b7eb ]

The ioctl EEPROM query wrongly returns success on read failures, fix
that by returning the appropriate error code.

Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220606115718.14233-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index f652cfd8127b..1d33fae529b6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2083,7 +2083,7 @@ static int mlx4_en_get_module_eeprom(struct net_device *dev,
 			en_err(priv,
 			       "mlx4_get_module_info i(%d) offset(%d) bytes_to_read(%d) - FAILED (0x%x)\n",
 			       i, offset, ee->len - i, ret);
-			return 0;
+			return ret;
 		}
 
 		i += ret;
-- 
2.35.1



