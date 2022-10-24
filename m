Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4091760A1B7
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJXLcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJXLcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C26550B9;
        Mon, 24 Oct 2022 04:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9347B81133;
        Mon, 24 Oct 2022 11:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FBFC433D6;
        Mon, 24 Oct 2022 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611134;
        bh=UjehT5YJLDsyySDHKVN1z6J5noOu+leeNjyGkzg8UE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlUlJ7UPfvgfLqVVexmtPUuaIA0/S2Psnd0rSzsOPPxM6A8uQaVOEWUiaRf9ApOZR
         t1Q8HDzIUJFKNSysJdZFfovYFG+27C04NkbDBiG3OknEKJqVFg2uDNFBorOzgnawGD
         rxiz3LoGeeU+gl/62705xAMrFReLuK2+PYyPifdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.0 03/20] pinctrl: amd: change dev_warn to dev_dbg for additional feature support
Date:   Mon, 24 Oct 2022 13:31:05 +0200
Message-Id: <20221024112934.560703191@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 3160b37e5cb695e866e06c3fdbc385846b569294 upstream.

Use dev_dbg instead of dev_warn for additional support of pinmux
feature.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://lore.kernel.org/r/20220830110525.1933198-1-Basavaraj.Natikar@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -1051,13 +1051,13 @@ static void amd_get_iomux_res(struct amd
 
 	index = device_property_match_string(dev, "pinctrl-resource-names",  "iomux");
 	if (index < 0) {
-		dev_warn(dev, "failed to get iomux index\n");
+		dev_dbg(dev, "iomux not supported\n");
 		goto out_no_pinmux;
 	}
 
 	gpio_dev->iomux_base = devm_platform_ioremap_resource(gpio_dev->pdev, index);
 	if (IS_ERR(gpio_dev->iomux_base)) {
-		dev_warn(dev, "Failed to get iomux %d io resource\n", index);
+		dev_dbg(dev, "iomux not supported %d io resource\n", index);
 		goto out_no_pinmux;
 	}
 


