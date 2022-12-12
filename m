Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2764A0D9
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbiLLNbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiLLNbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:31:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13991625C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8222BCE0F11
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EFAC433F0;
        Mon, 12 Dec 2022 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851896;
        bh=JyOTMRAmrE+f96t65BPIbWC0zznlH+h9ePtkimWBYnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQceuN2My/xlI1j2LCdPdYkwQVhHaHdoWatjv3ll7mOtBKTypFmTl0uwVqT069eJ5
         dbTXlW7yl+7I06LmVMdE3EOYx9JrA03/nDHIWKP+jM5f8+iYhYUNNPdBGw3cQ6oVBn
         MW60KmS4cN3nY8AkBWBP3c91sVU8+LuH7XA3H00w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/123] ieee802154: cc2520: Fix error return code in cc2520_hw_init()
Date:   Mon, 12 Dec 2022 14:17:11 +0100
Message-Id: <20221212130929.679062170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 4d002d6a2a00ac1c433899bd7625c6400a74cfba ]

In cc2520_hw_init(), if oscillator start failed, the error code
should be returned.

Fixes: 0da6bc8cc341 ("ieee802154: cc2520: adds driver for TI CC2520 radio")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20221120075046.2213633-1-william.xuanziyang@huawei.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index 4517517215f2..a8369bfa4050 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -970,7 +970,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
-- 
2.35.1



