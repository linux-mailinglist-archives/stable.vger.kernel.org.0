Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB6344242
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhCVMjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhCVMi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A394619B6;
        Mon, 22 Mar 2021 12:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416656;
        bh=Rqh84oPfGpkLWryE55UI1gfvz+d8MIqsBpn7j7LeXzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRkGNXQUucXwTPtE7lOmTSiw9QWTCo3n8XHJxq8RDd39uy36oeJ3SEc6oWWJTNIvv
         44Gh0nfv8ECcQSuhBpNU1HPPFLsE7QlmZGw8zEIltzLqKaPXrRmEeL72xI8cUoKGaX
         g1Wq7aS4njqRZySxRj7fuEvYmkaJQsXYETH6Xpks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 035/157] ALSA: usb-audio: Fix unintentional sign extension issue
Date:   Mon, 22 Mar 2021 13:26:32 +0100
Message-Id: <20210322121934.872616590@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

commit 50b1affc891cbc103a2334ce909a026e25f4c84d upstream.

The shifting of the u8 integer device by 24 bits to the left will
be promoted to a 32 bit signed int and then sign-extended to a
64 bit unsigned long. In the event that the top bit of device is
set then all then all the upper 32 bits of the unsigned long will
end up as also being set because of the sign-extension. Fix this
by casting device to an unsigned long before the shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: a07df82c7990 ("ALSA: usb-audio: Add DJM750 to Pioneer mixer quirk")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210318132008.15266-1-colin.king@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2883,7 +2883,7 @@ static int snd_djm_controls_put(struct s
 	u8 group = (private_value & SND_DJM_GROUP_MASK) >> SND_DJM_GROUP_SHIFT;
 	u16 value = elem->value.enumerated.item[0];
 
-	kctl->private_value = ((device << SND_DJM_DEVICE_SHIFT) |
+	kctl->private_value = (((unsigned long)device << SND_DJM_DEVICE_SHIFT) |
 			      (group << SND_DJM_GROUP_SHIFT) |
 			      value);
 
@@ -2921,7 +2921,7 @@ static int snd_djm_controls_create(struc
 		value = device->controls[i].default_value;
 		knew.name = device->controls[i].name;
 		knew.private_value = (
-			(device_idx << SND_DJM_DEVICE_SHIFT) |
+			((unsigned long)device_idx << SND_DJM_DEVICE_SHIFT) |
 			(i << SND_DJM_GROUP_SHIFT) |
 			value);
 		err = snd_djm_controls_update(mixer, device_idx, i, value);


