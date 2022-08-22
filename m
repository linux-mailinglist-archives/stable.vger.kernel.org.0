Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B3859BBDB
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiHVIlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiHVIlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:41:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C242C2CE3D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5774A6105D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B05C433D7;
        Mon, 22 Aug 2022 08:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661157672;
        bh=Wnrc6fSAT315M99DfnbnmbqYMadQj2WIZgIhsdmWcD4=;
        h=Subject:To:Cc:From:Date:From;
        b=mInvyL8I2b0zpX+00AhCu3Seay4iaB5LubRVtuS1I+whsFrrh0orFPfeMkBeVCmY1
         bv2ubOpN6m2vGjTNHflYMWiFkj16IrdKMwcw+63/OhQ0qIfWyRQTgbFloVt/S8S20L
         57Ez+w/wiLH+dcI9GbGjRdwQzibdTPy73HtD0e6A=
Subject: FAILED: patch "[PATCH] pinctrl: renesas: rzg2l: Return -EINVAL for pins which have" failed to apply to 5.15-stable tree
To:     prabhakar.mahadev-lad.rj@bp.renesas.com, geert+renesas@glider.be,
        phil.edworthy@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:41:09 +0200
Message-ID: <166115766994125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5223c511eb4f919e6b423b2f66e02674e97e77e3 Mon Sep 17 00:00:00 2001
From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Date: Wed, 11 May 2022 10:40:57 +0100
Subject: [PATCH] pinctrl: renesas: rzg2l: Return -EINVAL for pins which have
 input disabled

Pin status reported by pinconf-pins file always reported pin status as
"input enabled" even for pins which had input disabled. Fix this by
returning -EINVAL for the pins which have input disabled.

Fixes: c4c4637eb57f2 ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Reported-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Phil Edworthy <phil.edworthy@renesas.com>
Link: https://lore.kernel.org/r/20220511094057.3151-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index a48cac55152c..c3cdf52b7294 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -517,6 +517,8 @@ static int rzg2l_pinctrl_pinconf_get(struct pinctrl_dev *pctldev,
 		if (!(cfg & PIN_CFG_IEN))
 			return -EINVAL;
 		arg = rzg2l_read_pin_config(pctrl, IEN(port_offset), bit, IEN_MASK);
+		if (!arg)
+			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_POWER_SOURCE: {

