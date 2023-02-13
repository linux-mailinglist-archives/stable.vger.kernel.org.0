Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9436C69490C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBMOzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjBMOzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDDF1CAD1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE8E5B81253
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238DBC433EF;
        Mon, 13 Feb 2023 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300124;
        bh=5UM8IfTfm6oIFtYJjQ4Oz83rLBCbBHR9Hwmt35KS0uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEPCf4mGxma/K+JdQHZBRklWFw2HwOkyZb/ZZEtOIZ5OpbcVpRe19iOINMvrj9UBY
         57b5EKO/6tPGqWsZHyQjeNo8pjogQ+GYQIY/Cvbep0JnxnXbCbcRmg+sbMie0BhMFU
         4jK9QBY1AnJ55VgTLug340xvbWGl4gvGzWSN2cJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/114] pinctrl: single: fix potential NULL dereference
Date:   Mon, 13 Feb 2023 15:48:28 +0100
Message-Id: <20230213144745.981595265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit d2d73e6d4822140445ad4a7b1c6091e0f5fe703b ]

Added checking of pointer "function" in pcs_set_mux().
pinmux_generic_get_function() can return NULL and the pointer
"function" was dereferenced without checking against NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 571aec4df5b7 ("pinctrl: single: Use generic pinmux helpers for managing functions")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221118104332.943-1-korotkov.maxim.s@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 414ee6bb8ac98..9ad8f70206142 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -372,6 +372,8 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
 	if (!pcs->fmask)
 		return 0;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	func = function->data;
 	if (!func)
 		return -EINVAL;
-- 
2.39.0



