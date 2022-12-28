Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBE3658240
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiL1QeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiL1Qdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270681A39F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B893D61576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD10AC433EF;
        Wed, 28 Dec 2022 16:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245072;
        bh=c25+kbYfNpd8xPvTch9vIqkTNYBqRyqfYiC+xIWBuTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH33BmovzmVa7pLuNdImWP6PfNmGcKRsavluy+obN2Wmi6pwbpak4TmXjHshUqpnJ
         zRVrbh0tQOcfa1abQZW3eaB0BbTKBav5TT95LNJSwMf4dqNrPLtCCbdTJjzUXuD9LK
         xUW/T8ZrrHGXcc8k547QbcgeGHNGc7ywIZ3DJhmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Holland <samuel@sholland.org>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0828/1073] mfd: axp20x: Do not sleep in the power off handler
Date:   Wed, 28 Dec 2022 15:40:16 +0100
Message-Id: <20221228144350.504992111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 3f37d4f695cff180033254b9ed5adc8ab927cba9 ]

Since commit 856c288b0039 ("ARM: Use do_kernel_power_off()"), the
function axp20x_power_off() now runs inside a RCU read-side critical
section, so it is not allowed to call msleep(). Use mdelay() instead.

Fixes: 856c288b0039 ("ARM: Use do_kernel_power_off()")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221105212909.6526-1-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 88a212a8168c..880c41fa7021 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -842,7 +842,7 @@ static void axp20x_power_off(void)
 		     AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
-	msleep(500);
+	mdelay(500);
 }
 
 int axp20x_match_device(struct axp20x_dev *axp20x)
-- 
2.35.1



