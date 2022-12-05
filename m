Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7C643494
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiLETr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiLETrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E48225C5A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5EA6131D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBDEC433C1;
        Mon,  5 Dec 2022 19:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269450;
        bh=MlmR7vaWRAckJIdA5Q/amGsXqFnFyJvNAoP9e9BayIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbyidGmz378DI62YM17VJNXdwFOjq1vBBJSOn1fR5hno65K1chFJgwaIZTPGx5qO8
         R4LPkfzd9x9vT5kJoIc5iffV72ROsVIu34IFAUDo8Sl7xUPCgwY1Mw5qTPe27uxkfW
         ka7jNS73waWs8TIHp3Bsy9/npdclxbFoZoCY4WeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/153] pinctrl: single: Fix potential division by zero
Date:   Mon,  5 Dec 2022 20:10:55 +0100
Message-Id: <20221205190812.436271726@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 64c150339e7f6c5cbbe8c17a56ef2b3902612798 ]

There is a possibility of dividing by zero due to the pcs->bits_per_pin
if pcs->fmask() also has a value of zero and called fls
from asm-generic/bitops/builtin-fls.h or arch/x86/include/asm/bitops.h.
The function pcs_probe() has the branch that assigned to fmask 0 before
pcs_allocate_pin_table() was called

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4e7e8017a80e ("pinctrl: pinctrl-single: enhance to configure multiple pins of different modules")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221117123034.27383-1-korotkov.maxim.s@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index fb1c8965cb99..20c89023d312 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -703,7 +703,7 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 
 	mux_bytes = pcs->width / BITS_PER_BYTE;
 
-	if (pcs->bits_per_mux) {
+	if (pcs->bits_per_mux && pcs->fmask) {
 		pcs->bits_per_pin = fls(pcs->fmask);
 		nr_pins = (pcs->size * BITS_PER_BYTE) / pcs->bits_per_pin;
 		num_pins_in_register = pcs->width / pcs->bits_per_pin;
-- 
2.35.1



