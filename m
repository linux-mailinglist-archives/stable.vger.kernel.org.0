Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891CB469D53
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhLFP3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385534AbhLFPZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 922CA612D3;
        Mon,  6 Dec 2021 15:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78498C341C6;
        Mon,  6 Dec 2021 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804114;
        bh=BlMii64HDJCaC92Mm5g1HBrpyBkQPk6BAJyffq0fCVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wl4pqy3m+30G8/VurFLw+4LWGV/YbEeZRUZmFbqn6krUmOgvJfzwHxZgAZ9+iJ0LW
         stamFfzvFkcc8aEMgD8FXMLac3gIeCFa5OSDXQuDTBh6d4awzA2org+7PE1JuBFDAe
         gVgN5w1wl+T0iT3sxoiJPxrc+URsIWsEf2j+bM2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 004/207] ALSA: usb-audio: Disable low-latency mode for implicit feedback sync
Date:   Mon,  6 Dec 2021 15:54:18 +0100
Message-Id: <20211206145610.335267634@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit bceee75387554f682638e719d1ea60125ea78cea upstream.

When a playback stream runs in the implicit feedback mode, its
operation is passive and won't start unless the capture packet is
received.  This behavior contradicts with the low-latency playback
mode, and we should turn off lowlatency_playback flag accordingly.

In theory, we may take the low-latency mode when the playback-first
quirk is set, but it still conflicts with the later operation with the
fixed packet numbers, so it's disabled all together for now.

Link: https://lore.kernel.org/r/20210929080844.11583-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -595,6 +595,9 @@ static int lowlatency_playback_available
 	/* free-wheeling mode? (e.g. dmix) */
 	if (runtime->stop_threshold > runtime->buffer_size)
 		return false;
+	/* implicit feedback mode has own operation mode */
+	if (snd_usb_endpoint_implicit_feedback_sink(subs->data_endpoint))
+		return false;
 	/* too short periods? */
 	if (subs->data_endpoint->nominal_queue_size >= subs->buffer_bytes)
 		return false;


