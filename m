Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2B84E774E
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353716AbiCYP1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378109AbiCYPYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0DCE29E7;
        Fri, 25 Mar 2022 08:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9402DB827B7;
        Fri, 25 Mar 2022 15:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A95AC340E9;
        Fri, 25 Mar 2022 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221586;
        bh=Ps4W+b+eC5ZRAYJ16sYEl3So8ElWlylTyF575j+r5FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZU6c3FTKeJjgX7f/SDeNYbAJUAKprpQVLKhlc6aoP32+AiKfkftnF4t+s7cjdi8MK
         mSWQs4sZ4L01lVrUl35jvw9x0d/bg7jnOwsMLMHgzg+bhsP2GYWy12v2NyKQaunnI2
         Y/b1WikVuOUu3Zt6JCSuCEtpy48OZ88TryhpmS7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reza Jahanbakhshi <reza.jahanbakhshi@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 06/39] ALSA: usb-audio: add mapping for new Corsair Virtuoso SE
Date:   Fri, 25 Mar 2022 16:14:21 +0100
Message-Id: <20220325150420.428931809@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reza Jahanbakhshi <reza.jahanbakhshi@gmail.com>

commit cd94df1795418056a19ff4cb44eadfc18ac99a57 upstream.

New device id for Corsair Virtuoso SE RGB Wireless that currently is not
in the mixer_map. This entry in the mixer_map is necessary in order to
label its mixer appropriately and allow userspace to pick the correct
volume controls. For instance, my own Corsair Virtuoso SE RGB Wireless
headset has this new ID and consequently, the sidetone and volume are not
 working correctly without this change.
> sudo lsusb -v | grep -i corsair
Bus 007 Device 011: ID 1b1c:0a40 Corsair CORSAIR VIRTUOSO SE Wireless Gam
  idVendor           0x1b1c Corsair
  iManufacturer           1 Corsair
  iProduct                2 CORSAIR VIRTUOSO SE Wireless Gaming Headset

Signed-off-by: Reza Jahanbakhshi <reza.jahanbakhshi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220304212303.195949-1-reza.jahanbakhshi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -543,6 +543,16 @@ static const struct usbmix_ctl_map usbmi
 		.map = bose_soundlink_map,
 	},
 	{
+		/* Corsair Virtuoso SE Latest (wired mode) */
+		.id = USB_ID(0x1b1c, 0x0a3f),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair Virtuoso SE Latest (wireless mode) */
+		.id = USB_ID(0x1b1c, 0x0a40),
+		.map = corsair_virtuoso_map,
+	},
+	{
 		/* Corsair Virtuoso SE (wired mode) */
 		.id = USB_ID(0x1b1c, 0x0a3d),
 		.map = corsair_virtuoso_map,


