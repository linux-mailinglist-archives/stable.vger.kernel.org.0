Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0A759D40E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbiHWITV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiHWIS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:18:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC9F2AC63;
        Tue, 23 Aug 2022 01:11:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAAC5B81C21;
        Tue, 23 Aug 2022 08:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4AEC433D6;
        Tue, 23 Aug 2022 08:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242300;
        bh=yOZYWLwreTFv4WZO0UKvJlQU6N/VIyV/FKO/k1B6alI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJQdfkxZGdcOEw59Seb0n0YrS5Lq6SfR59ilwMyd+DAKZvzEr1H3kt2lv2C7bc0z5
         tNyrbJ9fXWpU6lYnee2d/IjTYVHBfmxMSYVT6qSlgUZpUlu9aqP1omCAIkwUJRh9cu
         +gWgK70w+KthGFml1dB3K5IMRoh1Dl71dKrU4td4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Edworthy <phil.edworthy@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.19 090/365] pinctrl: renesas: rzg2l: Return -EINVAL for pins which have input disabled
Date:   Tue, 23 Aug 2022 09:59:51 +0200
Message-Id: <20220823080121.953400787@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit 5223c511eb4f919e6b423b2f66e02674e97e77e3 upstream.

Pin status reported by pinconf-pins file always reported pin status as
"input enabled" even for pins which had input disabled. Fix this by
returning -EINVAL for the pins which have input disabled.

Fixes: c4c4637eb57f2 ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Reported-by: Phil Edworthy <phil.edworthy@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Phil Edworthy <phil.edworthy@renesas.com>
Link: https://lore.kernel.org/r/20220511094057.3151-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -517,6 +517,8 @@ static int rzg2l_pinctrl_pinconf_get(str
 		if (!(cfg & PIN_CFG_IEN))
 			return -EINVAL;
 		arg = rzg2l_read_pin_config(pctrl, IEN(port_offset), bit, IEN_MASK);
+		if (!arg)
+			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_POWER_SOURCE: {


