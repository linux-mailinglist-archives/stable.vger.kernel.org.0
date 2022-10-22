Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54468608A46
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiJVIuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbiJVItL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:49:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5B04E62F;
        Sat, 22 Oct 2022 01:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C734DB82E39;
        Sat, 22 Oct 2022 08:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8C8C433C1;
        Sat, 22 Oct 2022 08:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426044;
        bh=HqzInSWqetlXOUQs1l/ij7Z47hWlE+PPV581CXDV+lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPQfkp03Qk1Jci6f6GSC5cIeiaap1Vmhq8dpuOdgmslfO2a9aPafr+rpJ39VsrlHX
         PZBRdEd0VubvugmIVqd49TWECCeDgzlS2Lnf4Hps9n6jd078VLKKCu67XPiHR4Tj4a
         O7a3X9nhWKKts2RV1WnOLcr7JIITaf79UBMwoAV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 701/717] ALSA: usb-audio: Fix last interface check for registration
Date:   Sat, 22 Oct 2022 09:29:40 +0200
Message-Id: <20221022072529.462131443@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 39efc9c8a973ddff5918191525d1679d0fb368ea upstream.

The recent fix in commit 6392dcd1d0c7 ("ALSA: usb-audio: Register card
at the last interface") tried to delay the card registration until the
last found interface is probed.  It assumed that the probe callback
gets called for those later interfaces, but it's not always true; as
the driver loops over the descriptor and probes the matching ones,
it's not separately called via multiple probe calls.  This results in
the missing card registration, i.e. no sound device.

For addressing this problem, replace the check whether the last
interface is processed with usb_interface_claimed() instead of the
comparison with the probe interface number.

Fixes: 6392dcd1d0c7 ("ALSA: usb-audio: Register card at the last interface")
Link: https://lore.kernel.org/r/20220915085947.7922-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -884,7 +884,7 @@ static int usb_audio_probe(struct usb_in
 	 * one given via option
 	 */
 	if (check_delayed_register_option(chip) == ifnum ||
-	    chip->last_iface == ifnum) {
+	    usb_interface_claimed(usb_ifnum_to_if(dev, chip->last_iface))) {
 		err = snd_card_register(chip->card);
 		if (err < 0)
 			goto __error;


