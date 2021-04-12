Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D7035BDB6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbhDLIxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237945AbhDLIvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50064613BA;
        Mon, 12 Apr 2021 08:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217449;
        bh=vTWlQa/vKWD29VbxOdWkZQQ/cq5bW9VYLV1HuXpsyo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWOVkGEJ+UbJbcpS8UpDGY/yg9HFCMp/IjKzggL6XbW7oj1wBqskJvKg2/BQTRVaR
         gGucudxJKTZezC+UiNBSgJvPLgOZzxPLq8z6gkRP8JYyjdjM3jPgF4u4A52wVQgooI
         ayuNzptlyrTxcQg298LtIhoHEkwaSQ1ZZmY4wJO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Holmberg <jonashg@axis.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 002/188] ALSA: aloop: Fix initialization of controls
Date:   Mon, 12 Apr 2021 10:38:36 +0200
Message-Id: <20210412084013.723561236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Holmberg <jonashg@axis.com>

commit 168632a495f49f33a18c2d502fc249d7610375e9 upstream.

Add a control to the card before copying the id so that the numid field
is initialized in the copy. Otherwise the numid field of active_id,
format_id, rate_id and channels_id will be the same (0) and
snd_ctl_notify() will not queue the events properly.

Signed-off-by: Jonas Holmberg <jonashg@axis.com>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210407075428.2666787-1-jonashg@axis.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/drivers/aloop.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1572,6 +1572,14 @@ static int loopback_mixer_new(struct loo
 					return -ENOMEM;
 				kctl->id.device = dev;
 				kctl->id.subdevice = substr;
+
+				/* Add the control before copying the id so that
+				 * the numid field of the id is set in the copy.
+				 */
+				err = snd_ctl_add(card, kctl);
+				if (err < 0)
+					return err;
+
 				switch (idx) {
 				case ACTIVE_IDX:
 					setup->active_id = kctl->id;
@@ -1588,9 +1596,6 @@ static int loopback_mixer_new(struct loo
 				default:
 					break;
 				}
-				err = snd_ctl_add(card, kctl);
-				if (err < 0)
-					return err;
 			}
 		}
 	}


