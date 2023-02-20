Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97569CD53
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjBTNsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbjBTNsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:48:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601ED1CF66
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C554D60E9E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D590BC4339B;
        Mon, 20 Feb 2023 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900893;
        bh=G7Cye4Lq69XXqMBIFME//ldGe1ciOJjCaAvD8cwSjo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQOPZ1QUUJhjSGr8PVF1jgGhghDJVZ6T+mcotJ0r56bsralW7EMo13fQ4Ame7i2W7
         OQ2rO/Wms14g+qEPU349XRiTc9fr/u501BpvBIbwCwgUd3b3Sce6O/73o/qTQEBZDE
         0p3wf9IGau+gi5/WAs/amUxvtboctFG2kT6ukKP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/156] pinctrl: single: fix potential NULL dereference
Date:   Mon, 20 Feb 2023 14:35:22 +0100
Message-Id: <20230220133605.656404884@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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
index 20c89023d312e..ce5be6f0b7aac 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -345,6 +345,8 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
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



