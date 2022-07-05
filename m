Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC1566C7B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiGEMPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiGEMOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:14:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9871AF00;
        Tue,  5 Jul 2022 05:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F33B817D6;
        Tue,  5 Jul 2022 12:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E1FC341C8;
        Tue,  5 Jul 2022 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023083;
        bh=8Yx/3O7X0zhWd1KHPuHeo8VgXhfddwNdjHKMYGEiN0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJ7RXG6fZ3pjoweKhFGnO6SbFc+VKQmKmU6XuiAzhWJaBsfVlR+s5T1WdwyVCj9qj
         sEI9biIN9o9w/vjylghlbUFAiItnw0p0Y/OK8f/S1ch0PS5BxQm2dC0EqH85SvgnhW
         SgaSKUIQ2Zrwbl1S9CrZfhhpfFNyi1RbGwmS9gXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 30/98] net: usb: asix: do not force pause frames support
Date:   Tue,  5 Jul 2022 13:57:48 +0200
Message-Id: <20220705115618.447843543@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit ce95ab775f8d8e89a038c0e5611a7381a2ef8e43 upstream.

We should respect link partner capabilities and not force flow control
support on every link. Even more, in current state the MAC driver do not
advertises pause support so we should not keep flow control enabled at
all.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/r/20220624075139.3139300-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2c81236c6c7c..45d3cc5cc355 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -126,8 +126,7 @@
 	 AX_MEDIUM_RE)
 
 #define AX88772_MEDIUM_DEFAULT	\
-	(AX_MEDIUM_FD | AX_MEDIUM_RFC | \
-	 AX_MEDIUM_TFC | AX_MEDIUM_PS | \
+	(AX_MEDIUM_FD | AX_MEDIUM_PS | \
 	 AX_MEDIUM_AC | AX_MEDIUM_RE)
 
 /* AX88772 & AX88178 RX_CTL values */
-- 
2.37.0



