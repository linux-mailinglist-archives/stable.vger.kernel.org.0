Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F7B66C4FC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjAPQAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjAPQAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA04B23873
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3DC61042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E604C433D2;
        Mon, 16 Jan 2023 16:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884811;
        bh=0e1cB6rDET+Dt2wIFFoOUdT/rkft9TXI9p7v/mduYO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUvS+Unr8NeEf+zf6w5ncUFYMyhNh03Yw7pMqXCr0vUCCeW8K0IXUsw2teaMD1ASf
         5Be/NRZwqyyh5qp003H5hVNCQ4l9F8nIlrGiPh0YpDz5GpIOdapJFVzLKm9sIa4mzv
         j1lEcDx2y28KjwYGssEFtRGGTQccTfcX/RSH0tJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/183] Revert "r8169: disable detection of chip version 36"
Date:   Mon, 16 Jan 2023 16:51:12 +0100
Message-Id: <20230116154809.628736478@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 2ea26b4de6f42b74a5f1701de41efa6bc9f12666 ]

This reverts commit 42666b2c452ce87894786aae05e3fad3cfc6cb59.

This chip version seems to be very rare, but it exits in consumer
devices, see linked report.

Link: https://stackoverflow.com/questions/75049473/cant-setup-a-wired-network-in-archlinux-fresh-install
Fixes: 42666b2c452c ("r8169: disable detection of chip version 36")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/42e9674c-d5d0-a65a-f578-e5c74f244739@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73d061d9fcb..fe8dc8e0522b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1996,10 +1996,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 
 		/* 8168F family. */
 		{ 0x7c8, 0x488,	RTL_GIGA_MAC_VER_38 },
-		/* It seems this chip version never made it to
-		 * the wild. Let's disable detection.
-		 * { 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
-		 */
+		{ 0x7cf, 0x481,	RTL_GIGA_MAC_VER_36 },
 		{ 0x7cf, 0x480,	RTL_GIGA_MAC_VER_35 },
 
 		/* 8168E family. */
-- 
2.35.1



