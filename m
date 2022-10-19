Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8347C603F33
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiJSJau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiJSJ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:27:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68778E4C33;
        Wed, 19 Oct 2022 02:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7EB96174B;
        Wed, 19 Oct 2022 09:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84E5C433C1;
        Wed, 19 Oct 2022 09:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170684;
        bh=Nf/HQ7h/Z5nwQBjoAMYb7EpY/DT/8776VVnjScGaUA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0R7Rg0MJfcgplWFV8uLphZA6LzaHh6ilyFT+9U+KoM/7IQXgELKrSGTzD4pxzegm
         FVF3TEE4AG/jkT8HSG6Y7mwnJSCIHAjyn8WPli7nudZjmKLsq5q3XkpVF7Y2O95l+L
         pyhi4xD9AAKtVSo78VmSVpHc8JwztMHa0eUTFElY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Vasilugin <vasilugin@yandex.ru>,
        Daniel Golle <daniel@makrotopia.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 714/862] wifi: rt2x00: dont run Rt5592 IQ calibration on MT7620
Date:   Wed, 19 Oct 2022 10:33:21 +0200
Message-Id: <20221019083321.481998077@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit d3aad83d05aec0cfd7670cf0028f2ad4b81de92e ]

The function rt2800_iq_calibrate is intended for Rt5592 only.
Don't call it for MT7620 which has it's own calibration functions.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/31a1c34ddbd296b82f38c18c9ae7339059215fdc.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 18102fbe36d6..de81b6060359 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4365,7 +4365,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
-		rt2800_iq_calibrate(rt2x00dev, rf->channel);
+		if (rt2x00_rt(rt2x00dev, RT5592))
+			rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	bbp = rt2800_bbp_read(rt2x00dev, 4);
-- 
2.35.1



