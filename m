Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517CC6355D3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiKWJXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbiKWJWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:22:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1215EFAD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D841B81EF5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ABEC433D7;
        Wed, 23 Nov 2022 09:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195322;
        bh=Lw/0qUIlufrW3yWXwArHp40lUGROJTp8vd8y2eiTc50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXZBUfjJvyGrnw25RLDBM5Fph7waSqLxXxf3ii/ZXXG5UphNKCLRYh1yDgq3m05Rw
         rKMTiONuhRVS5xz7vBBqP02mFYZ5MiabwagxeD7OUEkpWxASnNjDF3qB5DoNb3sNx7
         J9xtt7fBHbkxKnWC3WO9eE2K+++ljr2fP9ahSSIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/149] pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map
Date:   Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084559.768728306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
index 3fb238714718..eac55fee5281 100644
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



