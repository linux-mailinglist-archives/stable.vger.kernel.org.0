Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBF3566D5D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiGEMWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiGEMU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:20:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594CF1EAD6;
        Tue,  5 Jul 2022 05:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43AA4B817AC;
        Tue,  5 Jul 2022 12:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858EFC341C7;
        Tue,  5 Jul 2022 12:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023390;
        bh=Hok1Co2iefPKMui6f6ms2vbGt5lvHy3kQSfw/a3Howk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grMgPN26tdvI6zP9FGpVLx0s5Jt6ZWHqbprlVVGHUcnaOWL+162AtcKdPHAq4+/Qh
         A52mH/xETwPXBEknVlGW0/aPwTzy8tjCJlRvAzn5eNk7bq7E945YlnZEVlBKTWzrcs
         4imQ6+Ife9UG2BJ54/OKqd8oIbdje4RQfhV5UHFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 036/102] net: usb: asix: do not force pause frames support
Date:   Tue,  5 Jul 2022 13:58:02 +0200
Message-Id: <20220705115619.437596269@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
 drivers/net/usb/asix.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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


