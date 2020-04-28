Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB411BC916
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbgD1Si3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbgD1SiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:38:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CDEC2076A;
        Tue, 28 Apr 2020 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099104;
        bh=aeVsh5hX7YOQkqNEYFt9ZEQZ+1JIzn4VuGLrwbceF3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TTtSGNmPF79USqLYMDJPIc9tx49kljeYI7ftlYQ+FlqeV2AgibHlfEKu6Vw6lxLz
         cKBgRamnkDXnBtQg56rut4inLovFcDexO3I4YmSWXxcbay4JNDiC8DmiHZPZaH5ueB
         3GiqK8n2O0+FOkLNtWw6V6qVv+6hXyK5cbm4cYjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 097/131] ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
Date:   Tue, 28 Apr 2020 20:25:09 +0200
Message-Id: <20200428182237.284187441@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 59e1947ca09ebd1cae147c08c7c41f3141233c84 upstream.

snd_microii_spdif_default_get() invokes snd_usb_lock_shutdown(), which
increases the refcount of the snd_usb_audio object "chip".

When snd_microii_spdif_default_get() returns, local variable "chip"
becomes invalid, so the refcount should be decreased to keep refcount
balanced.

The reference counting issue happens in several exception handling paths
of snd_microii_spdif_default_get(). When those error scenarios occur
such as usb_ifnum_to_if() returns NULL, the function forgets to decrease
the refcnt increased by snd_usb_lock_shutdown(), causing a refcnt leak.

Fix this issue by jumping to "end" label when those error scenarios
occur.

Fixes: 447d6275f0c2 ("ALSA: usb-audio: Add sanity checks for endpoint accesses")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1587617711-13200-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_quirks.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1519,11 +1519,15 @@ static int snd_microii_spdif_default_get
 
 	/* use known values for that card: interface#1 altsetting#1 */
 	iface = usb_ifnum_to_if(chip->dev, 1);
-	if (!iface || iface->num_altsetting < 2)
-		return -EINVAL;
+	if (!iface || iface->num_altsetting < 2) {
+		err = -EINVAL;
+		goto end;
+	}
 	alts = &iface->altsetting[1];
-	if (get_iface_desc(alts)->bNumEndpoints < 1)
-		return -EINVAL;
+	if (get_iface_desc(alts)->bNumEndpoints < 1) {
+		err = -EINVAL;
+		goto end;
+	}
 	ep = get_endpoint(alts, 0)->bEndpointAddress;
 
 	err = snd_usb_ctl_msg(chip->dev,


