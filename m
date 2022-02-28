Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9226F4C7722
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiB1SLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241612AbiB1SKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:10:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5D0BA743;
        Mon, 28 Feb 2022 09:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE7860F7C;
        Mon, 28 Feb 2022 17:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647ECC340F0;
        Mon, 28 Feb 2022 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070584;
        bh=MO36n/M99U6IL4V75gmdNp4IhLFS2AB+rBq5TnOYexA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q04n2jpMb4x5B/pQF2xKxTdyUtam07Qgj0HPrQ5HfS9ZT8dmwB/HDUkLNqfGsCcaZ
         +mM9nf8M4ZBwU0hFb8Zyp1xARkSQmjaiWKpKOyxpjOsieDkBevK59CtVlsbIsgRn3z
         bfushqTegvnJ8RpdMDDYNKyIvZnJHngl1ofCQ5eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.16 162/164] pinctrl: k210: Fix bias-pull-up
Date:   Mon, 28 Feb 2022 18:25:24 +0100
Message-Id: <20220228172414.326174338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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


