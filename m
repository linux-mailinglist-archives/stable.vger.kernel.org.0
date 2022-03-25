Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF9C4E7684
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359753AbiCYPP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376270AbiCYPMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:12:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069EB60A80;
        Fri, 25 Mar 2022 08:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9871AB82902;
        Fri, 25 Mar 2022 15:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0330C340EE;
        Fri, 25 Mar 2022 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220949;
        bh=x4K2PXqXinFMwHW5hfD/9uxSzwlabe/0LDz0rUIMlks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPYL+LLgyGj6SIkD8nDoSGpkscf7SdtX9HDexNRVJUcG7uCRYzSR8W9BwOOhMTF+j
         2ueYKadE2UOIM5ufgwzLSezFkGtjDohPLs83FB/rBYXOy9jpf2Dy6FAWCXBvexsgvh
         7zI7tpxcQAEY0jrwqh74c/dsIJK22kat4smu1qAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reza Jahanbakhshi <reza.jahanbakhshi@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 14/38] ALSA: usb-audio: add mapping for new Corsair Virtuoso SE
Date:   Fri, 25 Mar 2022 16:04:58 +0100
Message-Id: <20220325150420.169232960@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
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
 		.map = scms_usb3318_map,
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
 		.id = USB_ID(0x30be, 0x0101), /*  Schiit Hel */
 		.ignore_ctl_error = 1,
 	},


