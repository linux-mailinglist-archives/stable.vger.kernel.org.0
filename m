Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BB63580E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbiKWJuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbiKWJtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D991C3E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E27FD61A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD554C433D6;
        Wed, 23 Nov 2022 09:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196795;
        bh=j7DB7TlvOvN44uwVzudms0ItbMwP4w6ehza4se1yK38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+I+/r2fxg7YmfpNYsAdbhjW1OyGBdKm2RD796S8C6naCaIRAj0972m95Y88LWn40
         EHqWqKGI0oFgROPe66rsM0Gm2v78iTZrU42sarGu9kMwDH3Dik8yNuv2a2/Tw9t7zl
         iyuVysGQ7/t+sMmVPtx91rRcN4t/l1aboD0V4spU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 126/314] pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map
Date:   Wed, 23 Nov 2022 09:49:31 +0100
Message-Id: <20221123084631.239075712@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 91d5c5060ee24fe8da88cd585bb43b843d2f0dce ]

Here is the BUG report by KASAN about null pointer dereference:

BUG: KASAN: null-ptr-deref in strcmp+0x2e/0x50
Read of size 1 at addr 0000000000000000 by task python3/2640
Call Trace:
 strcmp
 __of_find_property
 of_find_property
 pinctrl_dt_to_map

kasprintf() would return NULL pointer when kmalloc() fail to allocate.
So directly return ENOMEM, if kasprintf() return NULL pointer.

Fixes: 57291ce295c0 ("pinctrl: core device tree mapping table parsing support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221110082056.2014898-1-zengheng4@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index ef898ee8ca6b..6e0a40962f38 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -220,6 +220,8 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		if (!propname)
+			return -ENOMEM;
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
-- 
2.35.1



