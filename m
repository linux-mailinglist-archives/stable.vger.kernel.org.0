Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA44ABB33
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384273AbiBGL1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381689AbiBGLRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24493C03FEE5;
        Mon,  7 Feb 2022 03:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAA5A61314;
        Mon,  7 Feb 2022 11:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C02C004E1;
        Mon,  7 Feb 2022 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232625;
        bh=gQpnfX6fe1GkM5d89JbxBa90jXALueqpBd1PBNtd13I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnPMi7heTiFoaOXHcTrA7JLB7x6tLIY0vNDJVrmCsdCCvNdonuZx1oHLoapTXbaMG
         UfPkMzE2Gm7wTe09Oyncmyt9hkWSFdXhJXiV1d1FFha5I3yi5L9aSepwQjvouO2ULv
         K6U7BjwyrMldjyKje78Z5gy9bT1zUzDoOXpbGz2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.19 71/86] net: ieee802154: mcr20a: Fix lifs/sifs periods
Date:   Mon,  7 Feb 2022 12:06:34 +0100
Message-Id: <20220207103759.999169538@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit d753c4004820a888ec007dd88b271fa9c3172c5c upstream.

These periods are expressed in time units (microseconds) while 40 and 12
are the number of symbol durations these periods will last. We need to
multiply them both with phy->symbol_duration in order to get these
values in microseconds.

Fixes: 8c6ad9cc5157 ("ieee802154: Add NXP MCR20A IEEE 802.15.4 transceiver driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-3-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/mcr20a.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ieee802154/mcr20a.c
+++ b/drivers/net/ieee802154/mcr20a.c
@@ -1005,8 +1005,8 @@ static void mcr20a_hw_setup(struct mcr20
 	dev_dbg(printdev(lp), "%s\n", __func__);
 
 	phy->symbol_duration = 16;
-	phy->lifs_period = 40;
-	phy->sifs_period = 12;
+	phy->lifs_period = 40 * phy->symbol_duration;
+	phy->sifs_period = 12 * phy->symbol_duration;
 
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM |
 			IEEE802154_HW_AFILT |


