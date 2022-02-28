Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD2E4C7706
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiB1SLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241221AbiB1SJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1228A9F6E8;
        Mon, 28 Feb 2022 09:49:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A683CB81085;
        Mon, 28 Feb 2022 17:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CC2C340F3;
        Mon, 28 Feb 2022 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070579;
        bh=a8FmRNqMdd1SNMKnzGb7FNCFd2BX9PTgHTGtKvI7Dzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3uRBJuUT/mx0gLiXV25KfpKvwOiVv1HbPL7sXNgJ/41yTR9LgkpOQE6uhcIG3gSE
         eiNnL0oNc0Nl6iTsKFLAzMOhWQ/Q++bhssiGERs2PJ5sxZ874iS3gsCuSVtbuPQfrb
         /yd5fbRCLF99K4vvkpYcHipIWtCC/igJMcQte+oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sean Anderson <seanga2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.16 161/164] pinctrl: fix loop in k210_pinconf_get_drive()
Date:   Mon, 28 Feb 2022 18:25:23 +0100
Message-Id: <20220228172414.250248128@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ba2ab85951c91a140a8fa51d8347d54e59ec009d upstream.

The loop exited too early so the k210_pinconf_drive_strength[0] array
element was never used.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Sean Anderson <seanga2@gmail.com>
Link: https://lore.kernel.org/r/20220209180804.GA18385@kili
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-k210.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -482,7 +482,7 @@ static int k210_pinconf_get_drive(unsign
 {
 	int i;
 
-	for (i = K210_PC_DRIVE_MAX; i; i--) {
+	for (i = K210_PC_DRIVE_MAX; i >= 0; i--) {
 		if (k210_pinconf_drive_strength[i] <= max_strength_ua)
 			return i;
 	}


