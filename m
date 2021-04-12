Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4E735BCE8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbhDLIqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237797AbhDLIpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2AB361244;
        Mon, 12 Apr 2021 08:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217120;
        bh=VNxplL0hsHPtHQbGuKzGNtm3bi12txsZOfDR+Wr/hEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Lp69b/zAYb2KxP+FB7i0imCZ4Kola2hdCb2TPJRbX8Dm2W/JWO+biePtTuyUAiCA
         E9/oDplCeg+N2o8p5zHSg7hsfbOAd01mV15GJd9njySSXCLVuF5kS892JpuOQ1M2/L
         a3+SaoPIV4OrlLpvStqgrg56RJ8qGGoa/EmU7nhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Holmberg <jonashg@axis.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 002/111] ALSA: aloop: Fix initialization of controls
Date:   Mon, 12 Apr 2021 10:39:40 +0200
Message-Id: <20210412084004.283718799@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
@@ -1035,6 +1035,14 @@ static int loopback_mixer_new(struct loo
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
@@ -1051,9 +1059,6 @@ static int loopback_mixer_new(struct loo
 				default:
 					break;
 				}
-				err = snd_ctl_add(card, kctl);
-				if (err < 0)
-					return err;
 			}
 		}
 	}


