Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709B41B0ADD
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgDTMw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbgDTMq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:46:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4D27206D4;
        Mon, 20 Apr 2020 12:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386819;
        bh=VnYYLsz/sYIWnIIfbHRQhrU0U/h+gGUu95y/4hL63Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVY8M7S1AIGbqZkUUPi/mucvz/Sh+dSPWSBZ8JDRfyjcoC82QCE6ysg8cB3zE6Jxv
         DalJ1CLrhs54IS5suS4yfawGGLyejaiZEWMfxjLXP+zFf958SoaGkhI0O/SuwwFd19
         RqzMILVt2WEDSJP/K6dwhsh1mU9fcLuGu8iPIB6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 38/60] ALSA: usb-audio: Dont override ignore_ctl_error value from the map
Date:   Mon, 20 Apr 2020 14:39:16 +0200
Message-Id: <20200420121511.186018233@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
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
@@ -3085,7 +3085,7 @@ static int snd_usb_mixer_controls(struct
 		if (map->id == state.chip->usb_id) {
 			state.map = map->map;
 			state.selector_map = map->selector_map;
-			mixer->ignore_ctl_error = map->ignore_ctl_error;
+			mixer->ignore_ctl_error |= map->ignore_ctl_error;
 			break;
 		}
 	}


