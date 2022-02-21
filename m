Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CD24BE5E6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347297AbiBUJGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:06:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347508AbiBUJFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:05:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5AE2E085;
        Mon, 21 Feb 2022 00:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 957C861149;
        Mon, 21 Feb 2022 08:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809D5C340E9;
        Mon, 21 Feb 2022 08:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433950;
        bh=bnRgaCYY2Io/dz1lctcW09Cp9g3QrduhEn3iv3fnR8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI7T19n4Dw5/7JstRC64FNrkALMVY46FiOGZaoP7Kr5aMQ9XS+s4P06OE+9onLjJD
         7cV/EJb/IqNzpU96lwGZ5ypWp8+YrscLtIWR7UWhtgWOQquV/GFSmbBz1RVZq1TT3Q
         XJLWI0w6QzzYneSqI1ybBxxcFsaiAHrp1XgyUGK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.4 40/80] net: ieee802154: ca8210: Fix lifs/sifs periods
Date:   Mon, 21 Feb 2022 09:49:20 +0100
Message-Id: <20220221084916.889824666@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
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
@@ -2976,8 +2976,8 @@ static void ca8210_hw_setup(struct ieee8
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


