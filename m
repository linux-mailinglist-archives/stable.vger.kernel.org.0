Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084AC657E9A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiL1Pz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiL1Pz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:55:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A2218B13
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C706155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340CDC433D2;
        Wed, 28 Dec 2022 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242925;
        bh=jBE6hruOnRQMIgFsUWDkBDqedX+JURaItPYusGic2g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI3dXt2G12bGnwtUQ23kHAHsEkpZgmDjwckeLTFAeDEyvN4KJVFW+esg81VUBQuCK
         XWnP3rPhP6TGBNY2PT43YiivDSKvSCX69ZEMT0LRn1oqGYzLUONcRRvolnkvcebp4L
         /HnnEQE2ngDzyDiookqP/LZhK/kntiM/PEvU69+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0470/1073] pinctrl: thunderbay: fix possible memory leak in thunderbay_build_functions()
Date:   Wed, 28 Dec 2022 15:34:18 +0100
Message-Id: <20221228144340.803152710@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 83e1bcaf8cef26edaaf2a6098ef760f563683483 ]

The thunderbay_add_functions() will free memory of thunderbay_funcs
when everything is ok, but thunderbay_funcs will not be freed when
thunderbay_add_functions() fails, then there will be a memory leak,
so we need to add kfree() when thunderbay_add_functions() fails to
fix it.

In addition, doing some cleaner works, moving kfree(funcs) from
thunderbay_add_functions() to thunderbay_build_functions().

Fixes: 12422af8194d ("pinctrl: Add Intel Thunder Bay pinctrl driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20221129120126.1567338-1-cuigaosheng1@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-thunderbay.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-thunderbay.c b/drivers/pinctrl/pinctrl-thunderbay.c
index 9328b17485cf..590bbbf619af 100644
--- a/drivers/pinctrl/pinctrl-thunderbay.c
+++ b/drivers/pinctrl/pinctrl-thunderbay.c
@@ -808,7 +808,7 @@ static int thunderbay_add_functions(struct thunderbay_pinctrl *tpc, struct funct
 					    funcs[i].num_group_names,
 					    funcs[i].data);
 	}
-	kfree(funcs);
+
 	return 0;
 }
 
@@ -817,6 +817,7 @@ static int thunderbay_build_functions(struct thunderbay_pinctrl *tpc)
 	struct function_desc *thunderbay_funcs;
 	void *ptr;
 	int pin;
+	int ret;
 
 	/*
 	 * Allocate maximum possible number of functions. Assume every pin
@@ -860,7 +861,10 @@ static int thunderbay_build_functions(struct thunderbay_pinctrl *tpc)
 		return -ENOMEM;
 
 	thunderbay_funcs = ptr;
-	return thunderbay_add_functions(tpc, thunderbay_funcs);
+	ret = thunderbay_add_functions(tpc, thunderbay_funcs);
+
+	kfree(thunderbay_funcs);
+	return ret;
 }
 
 static int thunderbay_pinconf_set_tristate(struct thunderbay_pinctrl *tpc,
-- 
2.35.1



