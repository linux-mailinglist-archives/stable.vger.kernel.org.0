Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25313469EB2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351568AbhLFPno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378583AbhLFPgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8C8C08EACB;
        Mon,  6 Dec 2021 07:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DDCB81018;
        Mon,  6 Dec 2021 15:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D6AC341C1;
        Mon,  6 Dec 2021 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804119;
        bh=RioavJvfscCUsED2Ps6cGNb6zIDx5TJ0po+l5uMdiOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OShxHaB/GR0Ek5kJ/bXrJZbhu0SURu1XcYNw19rX/gskZ9zyUItjCOX/Ap8LHySB1
         vzNrpoWzNfDsfF5CjNg/eNI+exLAyWnxZcOYNnyz2aazPLtWZ5inLyaV1Ilbl1k+Np
         Cujiob5QAUSNJaw6oU0FZpyjP9nYiGDPx4JmxE4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 006/207] ALSA: usb-audio: Add spinlock to stop_urbs()
Date:   Mon,  6 Dec 2021 15:54:20 +0100
Message-Id: <20211206145610.400066230@linuxfoundation.org>
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

commit 0ef74366bc150dda4f53c546dfa6e8f7c707e087 upstream.

In theory, stop_urbs() may be called concurrently.
Although we have the state check beforehand, it's safer to apply
ep->lock during the critical list head manipulations.

Link: https://lore.kernel.org/r/20210929080844.11583-8-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -927,6 +927,7 @@ void snd_usb_endpoint_sync_pending_stop(
 static int stop_urbs(struct snd_usb_endpoint *ep, bool force)
 {
 	unsigned int i;
+	unsigned long flags;
 
 	if (!force && atomic_read(&ep->running))
 		return -EBUSY;
@@ -934,9 +935,11 @@ static int stop_urbs(struct snd_usb_endp
 	if (!ep_state_update(ep, EP_STATE_RUNNING, EP_STATE_STOPPING))
 		return 0;
 
+	spin_lock_irqsave(&ep->lock, flags);
 	INIT_LIST_HEAD(&ep->ready_playback_urbs);
 	ep->next_packet_head = 0;
 	ep->next_packet_queued = 0;
+	spin_unlock_irqrestore(&ep->lock, flags);
 
 	for (i = 0; i < ep->nurbs; i++) {
 		if (test_bit(i, &ep->active_mask)) {


