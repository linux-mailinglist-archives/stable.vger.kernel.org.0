Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC36431D8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiLETUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiLETU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:20:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C513C29CA5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B8466133A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF08C433C1;
        Mon,  5 Dec 2022 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267788;
        bh=WZrMlvXuhgGSeMHoRSe8IfJXKYRGgqio+4mB8yPAjoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rp400ExnXzoUWQDvuO0gxLxpd7zOQcGdQrqTfDUR/avCzXZzClVDWZXUBf0jpDzUn
         ryF1g+HgrlrEzw4Y+9p6XwsdtGL24j6MyZ7W8GXkjfwi1Em9C2t1PtoSrd/92k1OyB
         eee+rg0bvBQMWrqGieFXLw/gcQNZ5vR48es0kFkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerry Ray <jerry.ray@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 52/77] dsa: lan9303: Correct stat name
Date:   Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190802.712895072@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit 39f59bca275d2d819a8788c0f962e9e89843efc9 ]

This patch changes the reported ethtool statistics for the lan9303
family of parts covered by this driver.

The TxUnderRun statistic label is renamed to RxShort to accurately
reflect what stat the device is reporting.  I did not reorder the
statistics as that might cause problems with existing user code that
are expecting the stats at a certain offset.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221128193559.6572-1-jerry.ray@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 1e5a69b9d90a..10d1c08ffeea 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -681,7 +681,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
-- 
2.35.1



