Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A1401C0A
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbhIFNBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243687AbhIFNAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A6E61039;
        Mon,  6 Sep 2021 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933143;
        bh=F4nW9+6bqy5jXUpLK5Zm71GCJLXbHcqGgL5PNruXAeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpmIpLWhGIa2IDzHKr1uwlN46+nV/M43NdnRoPlyu0xtoWGOsJ1cICZXIlN04fGuR
         DeBXkJY15I+Uzhf5EvultjxGhUHqkvyrmnblXNIX/5wo+X2953G85e1fY+oaTuulqq
         srhp5YLbnG45sjb2uYFXyZjUCscNd8lH/rRPEU94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 10/14] ALSA: usb-audio: Fix regression on Sony WALKMAN NW-A45 DAC
Date:   Mon,  6 Sep 2021 14:55:56 +0200
Message-Id: <20210906125448.527911430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 7af5a14371c1cf94a41f08eabb62a3faceec8911 upstream.

We've got a regression report for USB-audio with Sony WALKMAN NW-A45
DAC device where no sound is audible on recent kernel.  The bisection
resulted in the code change wrt endpoint management, and the further
debug session revealed that it was caused by the order of the USB
audio interface.  In the earlier code, we always set up the USB
interface at first before other setups, but it was changed to be done
at the last for UAC2/3, which is more standard way, while keeping the
old way for UAC1.  OTOH, this device seems requiring the setup of the
interface at first just like UAC1.

This patch works around the regression by applying the interface setup
specifically for the WALKMAN at the beginning of the endpoint setup
procedure.  This change is written straightforwardly to be easily
backported in old kernels.  A further cleanup to move the workaround
into a generic quirk section will follow in a later patch.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214105
Link: https://lore.kernel.org/r/20210824054700.8236-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1287,6 +1287,11 @@ int snd_usb_endpoint_configure(struct sn
 	 * to be set up before parameter setups
 	 */
 	iface_first = ep->cur_audiofmt->protocol == UAC_VERSION_1;
+	/* Workaround for Sony WALKMAN NW-A45 DAC;
+	 * it requires the interface setup at first like UAC1
+	 */
+	if (chip->usb_id == USB_ID(0x054c, 0x0b8c))
+		iface_first = true;
 	if (iface_first) {
 		err = endpoint_set_interface(chip, ep, true);
 		if (err < 0)


