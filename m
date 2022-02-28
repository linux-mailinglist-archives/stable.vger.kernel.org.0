Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32C34C7590
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiB1Rze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbiB1Ry3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97819DF66;
        Mon, 28 Feb 2022 09:42:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 310B6B815B8;
        Mon, 28 Feb 2022 17:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8762DC340E7;
        Mon, 28 Feb 2022 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070156;
        bh=MO36n/M99U6IL4V75gmdNp4IhLFS2AB+rBq5TnOYexA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCagVHJxjDW9cZ0Yk+pP/MF/1cNz0JmDmE8s0OLTCpSX7jkQVnIjaVZe2ma/sQdvb
         iyzmrytDuUoMQUUjwoyaXmxidY9LbgPz4c1aeqBh++rdiltGbyV5DgDISiNXtinCTz
         Tg30FW+rJokxVjpU+qC6Hcn5E7qOWwbRR8odeRnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 135/139] pinctrl: k210: Fix bias-pull-up
Date:   Mon, 28 Feb 2022 18:25:09 +0100
Message-Id: <20220228172401.892752402@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Anderson <seanga2@gmail.com>

commit e9f7b9228a94778edb7a63fde3c0a3c5bb793064 upstream.

Using bias-pull-up would actually cause the pin to have its pull-down
enabled. Fix this.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Link: https://lore.kernel.org/r/20220209182822.640905-1-seanga2@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-k210.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -527,7 +527,7 @@ static int k210_pinconf_set_param(struct
 	case PIN_CONFIG_BIAS_PULL_UP:
 		if (!arg)
 			return -EINVAL;
-		val |= K210_PC_PD;
+		val |= K210_PC_PU;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		arg *= 1000;


