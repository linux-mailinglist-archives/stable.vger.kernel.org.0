Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB64D3441FE
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhCVMhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhCVMgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADD7619B5;
        Mon, 22 Mar 2021 12:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416554;
        bh=xZu6JDWX9k+gSFeNcr4FNlfdCMrATCvuMPzSeaHEff4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnPGAicaz7qAh4RKVdl5DXZtSu3bkcfVv9rcKuPMnyhM0rMGqaAxsCP5dX6+4lKV1
         5vWm2Je4k1RRKND/0KYkAR4+zXePp4K4HvP2OEuu+XWIghsanB/JR8ifRAYU681o3r
         Rf6LrQ2+ZVesdOYlhIfy6IIJLkdLftzjdobN07YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 004/157] ALSA: dice: fix null pointer dereference when node is disconnected
Date:   Mon, 22 Mar 2021 13:26:01 +0100
Message-Id: <20210322121933.900566510@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit dd7b836d6bc935df95c826f69ff4d051f5561604 upstream.

When node is removed from IEEE 1394 bus, any transaction fails to the node.
In the case, ALSA dice driver doesn't stop isochronous contexts even if
they are running. As a result, null pointer dereference occurs in callback
from the running context.

This commit fixes the bug to release isochronous contexts always.

Cc: <stable@vger.kernel.org> # v5.4 or later
Fixes: e9f21129b8d8 ("ALSA: dice: support AMDTP domain")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20210312093407.23437-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-stream.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -493,11 +493,10 @@ void snd_dice_stream_stop_duplex(struct
 	struct reg_params tx_params, rx_params;
 
 	if (dice->substreams_counter == 0) {
-		if (get_register_params(dice, &tx_params, &rx_params) >= 0) {
-			amdtp_domain_stop(&dice->domain);
+		if (get_register_params(dice, &tx_params, &rx_params) >= 0)
 			finish_session(dice, &tx_params, &rx_params);
-		}
 
+		amdtp_domain_stop(&dice->domain);
 		release_resources(dice);
 	}
 }


