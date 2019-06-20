Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511034D895
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFTSEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfFTSEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC1D21537;
        Thu, 20 Jun 2019 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053871;
        bh=qtrcLS0Ihxw/TV73LYimeZNrjr8AoKq8dUxpfk53+y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zGscBbqplnxpyBm1AxOlXpalQM9TwjbtoBzPGfQoogutr+DUGHGtsavdPE0gHkKv
         K6l2cMJ6zt1lmrYHOXC0qO1AoDddt3nuvnHKMG8fgPTLPFajn4c/p85Vlj8fkf4S5S
         RVLu0nwpTBt2rQu0CvTz9XQ+3vsMOwVkVjzn6hJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 057/117] ALSA: oxfw: allow PCM capture for Stanton SCS.1m
Date:   Thu, 20 Jun 2019 19:56:31 +0200
Message-Id: <20190620174356.067683719@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit d8fa87c368f5b4096c4746894fdcc195da285df1 upstream.

Stanton SCS.1m can transfer isochronous packet with Multi Bit Linear
Audio data channels, therefore it allows software to capture PCM
substream. However, ALSA oxfw driver doesn't.

This commit changes the driver to add one PCM substream for capture
direction.

Fixes: de5126cc3c0b ("ALSA: oxfw: add stream format quirk for SCS.1 models")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/oxfw/oxfw.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -175,9 +175,6 @@ static int detect_quirks(struct snd_oxfw
 		oxfw->midi_input_ports = 0;
 		oxfw->midi_output_ports = 0;
 
-		/* Output stream exists but no data channels are useful. */
-		oxfw->has_output = false;
-
 		return snd_oxfw_scs1x_add(oxfw);
 	}
 


