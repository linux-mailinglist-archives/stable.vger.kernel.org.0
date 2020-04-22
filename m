Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FCC1B3C26
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgDVKDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbgDVKC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:02:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABD02077D;
        Wed, 22 Apr 2020 10:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549778;
        bh=ChPTHsdSiJ/7Ehx/vuUbjeQfWZ2tYAEVWdNT+nmo/Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcYyIvDtGibnNHft9yxd+4xbHXfVZ0ZQ0EtvujR1ZrI5JqVTq908Fr8mTLE4LK4pw
         GAS7IvSjOPAugmnBYY3iwl4+F3P7Ru+OAmzjQbQ1FhMw+VkTyDMFsfNUCpvkd3FQZE
         3DmX2KGYFvIdeH1J8akK3zibbSt+8UAthKHPTsI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 064/100] ALSA: usb-audio: Dont override ignore_ctl_error value from the map
Date:   Wed, 22 Apr 2020 11:56:34 +0200
Message-Id: <20200422095034.583759310@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 3507245b82b4362dc9721cbc328644905a3efa22 upstream.

The mapping table may contain also ignore_ctl_error flag for devices
that are known to behave wild.  Since this flag always writes the
card's own ignore_ctl_error flag, it overrides the value already set
by the module option, so it doesn't follow user's expectation.
Let's fix the code not to clear the flag that has been set by user.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206873
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200412081331.4742-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2269,7 +2269,7 @@ static int snd_usb_mixer_controls(struct
 		if (map->id == state.chip->usb_id) {
 			state.map = map->map;
 			state.selector_map = map->selector_map;
-			mixer->ignore_ctl_error = map->ignore_ctl_error;
+			mixer->ignore_ctl_error |= map->ignore_ctl_error;
 			break;
 		}
 	}


