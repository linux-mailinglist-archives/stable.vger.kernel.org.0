Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26ED4BDCDE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiBUJOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349557AbiBUJMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB0B15A29;
        Mon, 21 Feb 2022 01:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C29AC6112F;
        Mon, 21 Feb 2022 09:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A247EC340E9;
        Mon, 21 Feb 2022 09:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434329;
        bh=ZS1TD7nsvGNTR1DMMV/5tMV8xT5RFlc/uTU2g8Au49o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ksx78a3NaKWQe7nQqPxI9Dv8nn0A+7QFkVIqCXEaKj+ZXPjJhYBrFpfHnYGLNQDrp
         jnSknUiH+Bn0Sq4xEvqQC87Lj1WHQ2HpZe/WBS4sGkC15G0KYoAXBqNzq6ekqv3mpQ
         fVOI7N+PpA3suPeSo8fNT1MOulZGp0NuY2n53apk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 059/121] net: ieee802154: ca8210: Fix lifs/sifs periods
Date:   Mon, 21 Feb 2022 09:49:11 +0100
Message-Id: <20220221084923.214332939@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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

commit bdc120a2bcd834e571ce4115aaddf71ab34495de upstream.

These periods are expressed in time units (microseconds) while 40 and 12
are the number of symbol durations these periods will last. We need to
multiply them both with the symbol_duration in order to get these
values in microseconds.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20220201180629.93410-2-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/ca8210.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2977,8 +2977,8 @@ static void ca8210_hw_setup(struct ieee8
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
 	ca8210_hw->phy->symbol_duration = 16;
-	ca8210_hw->phy->lifs_period = 40;
-	ca8210_hw->phy->sifs_period = 12;
+	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
+	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->flags =
 		IEEE802154_HW_AFILT |
 		IEEE802154_HW_OMIT_CKSUM |


