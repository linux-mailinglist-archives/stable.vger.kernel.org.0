Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7D6B49AA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjCJPOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjCJPOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB5869063
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729C1B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E49C4339B;
        Fri, 10 Mar 2023 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460722;
        bh=eJNTLNrICSyIt8nx5A/4In7SIJbgHcuvY7gS3TWRXcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0gTRcDFq6VPtmwHtgJUkCOVRspkPOKDJpiyQ1CTj/z9LzejJH5rwE4/sBNLJ+hE2
         dcrjmLE+CXX2w1KbHF9rzXfxOkT32oNKGM+B6cPFHLYvhk1r1HvOWWcQMHlwh+dcQ9
         H726g0EWHLR9RMZonGcCjmAXDNrNJSfGAnGW2Qkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonas Karlman <jonas@kwiboo.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Jianqun Xu <jay.xu@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 429/529] pinctrl: rockchip: fix reading pull type on rk3568
Date:   Fri, 10 Mar 2023 14:39:32 +0100
Message-Id: <20230310133824.836188459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

commit 31b62a98de42cf65d76e4dcfb571af067d27d83a upstream.

When reading pinconf-pins from debugfs it fails to get the configured pull
type on RK3568, "unsupported pinctrl type" error messages is also reported.

Fix this by adding support for RK3568 in rockchip_get_pull, including a
reverse of the pull-up value swap applied in rockchip_set_pull so that
pull-up is correctly reported in pinconf-pins.
Also update the workaround comment to reflect affected pins, GPIO0_D3-D6.

Fixes: c0dadc0e47a8 ("pinctrl: rockchip: add support for rk3568")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Jianqun Xu <jay.xu@rock-chips.com>
Link: https://lore.kernel.org/r/20230110172955.1258840-1-jonas@kwiboo.se
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2045,9 +2045,18 @@ static int rockchip_get_pull(struct rock
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		pull_type = bank->pull_type[pin_num / 8];
 		data >>= bit;
 		data &= (1 << RK3188_PULL_BITS_PER_PIN) - 1;
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (data == 3)
+				data = 1;
+		}
 
 		return rockchip_pull_list[pull_type][data];
 	default:
@@ -2101,7 +2110,7 @@ static int rockchip_set_pull(struct rock
 			}
 		}
 		/*
-		 * In the TRM, pull-up being 1 for everything except the GPIO0_D0-D6,
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
 		 * where that pull up value becomes 3.
 		 */
 		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {


