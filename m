Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD3F566C22
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiGEMLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiGEMKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:10:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E5F19010;
        Tue,  5 Jul 2022 05:09:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C444CE1B85;
        Tue,  5 Jul 2022 12:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C15C341CB;
        Tue,  5 Jul 2022 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022991;
        bh=h1TJpbxhHeOkxOVbqQejat1yI8D9rlDJA79PnW6mL2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hybBnsk0CeRTKgmUTa8Gu6k/eeHaVhgJWF5V+MMohawn9m8mQGutBv0fd82lcl26Q
         glsMEL0AUZRyQ0WQaFK7cPeIVoq0Cv4XgYohl0apldf6FQP+M+FJEXcG3t6NF7oxMR
         u2ywPFzMOc99mjysLrfHtZvR+7C2L6k1DSSrvY8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 84/84] clocksource/drivers/ixp4xx: remove EXPORT_SYMBOL_GPL from ixp4xx_timer_setup()
Date:   Tue,  5 Jul 2022 13:58:47 +0200
Message-Id: <20220705115617.769435398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
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


