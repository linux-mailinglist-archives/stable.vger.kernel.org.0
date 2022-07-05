Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6957566B9D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiGEMJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiGEMHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABA91839D;
        Tue,  5 Jul 2022 05:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4125EB817C7;
        Tue,  5 Jul 2022 12:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50ACC341CB;
        Tue,  5 Jul 2022 12:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022762;
        bh=h1TJpbxhHeOkxOVbqQejat1yI8D9rlDJA79PnW6mL2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ES2XgYSht7E9RYiCgexyQttWDOlEiv68sT+GGHouH/tm8amjz8aPFbgy87yE/Idzt
         yrwWXT3K5wLB/IhCqHANhsc07bXb3h0syoKshNSk090LjZQxpq9NOBDlDTef2bb3GN
         ipUfoIsR8QTJtuW5kriCiLEDdZfQGo73uDov7z6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 58/58] clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()
Date:   Tue,  5 Jul 2022 13:58:34 +0200
Message-Id: <20220705115611.951054962@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

ixp4xx_timer_setup is exported, and so can not be an __init function.
But it does not need to be exported as it is only called from one
in-kernel function, so just remove the EXPORT_SYMBOL_GPL() marking to
resolve the build warning.

This is fixed "properly" in commit 41929c9f628b
("clocksource/drivers/ixp4xx: Drop boardfile probe path") but that can
not be backported to older kernels as the reworking of the IXP4xx
codebase is not suitable for stable releases.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-ixp4xx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/clocksource/timer-ixp4xx.c
+++ b/drivers/clocksource/timer-ixp4xx.c
@@ -258,7 +258,6 @@ void __init ixp4xx_timer_setup(resource_
 	}
 	ixp4xx_timer_register(base, timer_irq, timer_freq);
 }
-EXPORT_SYMBOL_GPL(ixp4xx_timer_setup);
 
 #ifdef CONFIG_OF
 static __init int ixp4xx_of_timer_init(struct device_node *np)


