Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC32150103E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbiDNNnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344068AbiDNNaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502C7BC4;
        Thu, 14 Apr 2022 06:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E088061B18;
        Thu, 14 Apr 2022 13:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB2C385A5;
        Thu, 14 Apr 2022 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942845;
        bh=9QMv3lahHdv/z11XuDeuy250hfehrksyMfwOkrGc6GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/kKH1BZ7euk8wgS7erCdJX+nh7oUFiwyVOPN0jjrUe7jkR/bCZ188Q5xUdL7au7c
         Cl27jc7iSG6qn8V99U6XdKd+SzqezWGVPKjvnMy/xunJfmEA6DEnAQAnKLMRemZrlk
         d0qk0eagWBmyPGta0OdCPgnE5XmqzdWMhS0WgDUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 242/338] pinctrl: pinconf-generic: Print arguments for bias-pull-*
Date:   Thu, 14 Apr 2022 15:12:25 +0200
Message-Id: <20220414110845.779497153@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 188e5834b930acd03ad3cf7c5e7aa24db9665a29 upstream.

The bias-pull-* properties, or PIN_CONFIG_BIAS_PULL_* pin config
parameters, accept optional arguments in ohms denoting the strength of
the pin bias.

Print these values out in debugfs as well.

Fixes: eec450713e5c ("pinctrl: pinconf-generic: Add flag to print arguments")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220308100956.2750295-2-wenst@chromium.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinconf-generic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -31,10 +31,10 @@ static const struct pin_config_item conf
 	PCONFDUMP(PIN_CONFIG_BIAS_BUS_HOLD, "input bias bus hold", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL, false),
-	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", NULL, false),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", "ohms", true),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_PIN_DEFAULT,
-				"input bias pull to pin specific state", NULL, false),
-	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", NULL, false),
+				"input bias pull to pin specific state", "ohms", true),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", "ohms", true),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_DRAIN, "output drive open drain", NULL, false),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_SOURCE, "output drive open source", NULL, false),
 	PCONFDUMP(PIN_CONFIG_DRIVE_PUSH_PULL, "output drive push pull", NULL, false),


