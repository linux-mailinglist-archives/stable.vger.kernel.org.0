Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F960B29C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiJXQuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiJXQrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:47:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D049A2E9C0;
        Mon, 24 Oct 2022 08:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 592B5B818E2;
        Mon, 24 Oct 2022 12:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD793C433C1;
        Mon, 24 Oct 2022 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616146;
        bh=KvRsyww8TBRu9FFqzoB2wsOyRcPdvHSJA+Z6NdlXCMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyR8pNxZAFx5LRq9ipaebj+TcyAKg561muZI/M3Jt/ZZxQWmRPW30KXq6EXGwvuGO
         uqXsJM1nidYkIL/atJniEIcHb4INqqyhFqn+pZymilHbkSlgAlGnu4lt1syeebMSha
         Y3GiZIlU22IpJJicjmodGXewpPYe3bXWInPf8yqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 518/530] ALSA: usb-audio: Fix last interface check for registration
Date:   Mon, 24 Oct 2022 13:34:22 +0200
Message-Id: <20221024113108.455825729@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -883,7 +883,7 @@ static int usb_audio_probe(struct usb_in
 	 * one given via option
 	 */
 	if (check_delayed_register_option(chip) == ifnum ||
-	    chip->last_iface == ifnum) {
+	    usb_interface_claimed(usb_ifnum_to_if(dev, chip->last_iface))) {
 		err = snd_card_register(chip->card);
 		if (err < 0)
 			goto __error;


