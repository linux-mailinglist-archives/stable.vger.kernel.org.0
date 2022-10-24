Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EBA60A80C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiJXNA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiJXM7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D36448;
        Mon, 24 Oct 2022 05:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA155612A1;
        Mon, 24 Oct 2022 11:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E784AC433D6;
        Mon, 24 Oct 2022 11:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612389;
        bh=+3IhUpAN6u1ITIK/zEVNFbHGupufpTdT9BiBQYhxLqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBeAgUCL5DNhP3lIY4/0LT1qItk9elQL3yrBJQQHBtMGGJ9h+t8s80je+p1caY5Br
         Jcur6H4IA3SKu48Ic2yE/oWZhmP9xSSWsuEK0VJbPvhryhODS1+6cMsaeGTbff3ZlP
         VtB46OLrNMsGx86GSAygP9gspJfaIjaGULcHaTzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Vasilugin <vasilugin@yandex.ru>,
        Daniel Golle <daniel@makrotopia.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 180/210] wifi: rt2x00: correctly set BBP register 86 for MT7620
Date:   Mon, 24 Oct 2022 13:31:37 +0200
Message-Id: <20221024113002.807310121@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit c9aada64fe6493461127f1522d7e2f01792d2424 ]

Instead of 0 set the correct value for BBP register 86 for MT7620.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/257267247ee4fa7ebc6a5d0c4948b3f8119c0d77.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 57fa472b5c4e..155c08dc2e0e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3655,7 +3655,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
-		rt2800_bbp_write(rt2x00dev, 86, 0);
+		if (rt2x00_rt(rt2x00dev, RT6352))
+			rt2800_bbp_write(rt2x00dev, 86, 0x38);
+		else
+			rt2800_bbp_write(rt2x00dev, 86, 0);
 	}
 
 	if (rf->channel <= 14) {
-- 
2.35.1



