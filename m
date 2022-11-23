Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93176635507
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiKWJMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiKWJMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF6C17407
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7800C61B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E22FC433C1;
        Wed, 23 Nov 2022 09:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194732;
        bh=+NpaKiLRDGYdLAV7xf9YJWcPUAqNhrkheWr+odiKW0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+XFIFRhMBoSvlXWkUMgiJoFcth+UI2iHqNkrM2/uwnBXuEy6ytvKYffnvVO99YWk
         rjK6i81w4s6zp3C3ANxJ6Cq6mi5EviUopgHBNZahHxkVYWNJP8ThH0UsiqMX0I0hsH
         pRcyCj3I+Os36sy0P0DA63S2TM2tkUq6OeeBbjmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jussi Laako <jussi@sonarnerd.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 046/156] ALSA: usb-audio: Add DSD support for Accuphase DAC-60
Date:   Wed, 23 Nov 2022 09:50:03 +0100
Message-Id: <20221123084559.559545303@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Laako <jussi@sonarnerd.net>

commit 8cbd4725ffff3eface1f5f3397af02acad5b2831 upstream.

Accuphase DAC-60 option card supports native DSD up to DSD256,
but doesn't have support for auto-detection. Explicitly enable
DSD support for the correct altsetting.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221108221241.1220878-1-jussi@sonarnerd.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1676,6 +1676,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
+	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)


