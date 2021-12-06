Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA55469D58
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378353AbhLFP3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385683AbhLFPZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E8F6130D;
        Mon,  6 Dec 2021 15:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D23FC341C2;
        Mon,  6 Dec 2021 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804128;
        bh=YRp2bH+IqZKu+FgHDieow5NZN9kAt3/iKyOYTM156/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SefEGnZIMtiwcWptCn3fEhIhA41o0XnIkEa8k46yb3xn260bWC5472Vat4XucqKbq
         IKlKBzA+YU0HIBYWa4lX6b3rh2IhD6qUeivbUUIhdfCC8GzbOlaNj8+pb6Ret92Ei2
         o/MSK5EQcM9ypMOrNjjYUHHihSjEEiQtDPoXThPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 009/207] ALSA: usb-audio: Fix packet size calculation regression
Date:   Mon,  6 Dec 2021 15:54:23 +0100
Message-Id: <20211206145610.508041897@linuxfoundation.org>
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

commit 23939115be181bc5dbc33aa8471adcdbffa28910 upstream.

The commit d215f63d49da ("ALSA: usb-audio: Check available frames for
the next packet size") introduced the available frame size check, but
the conversion forgot to initialize the temporary variable properly,
and it resulted in a bogus calculation.  This patch fixes it.

Fixes: d215f63d49da ("ALSA: usb-audio: Check available frames for the next packet size")
Reported-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20211001104417.14291-1-colin.king@canonical.com
Link: https://lore.kernel.org/r/20211001105425.16191-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -182,7 +182,7 @@ static int next_packet_size(struct snd_u
 	if (ep->fill_max)
 		return ep->maxframesize;
 
-	sample_accum += ep->sample_rem;
+	sample_accum = ep->sample_accum + ep->sample_rem;
 	if (sample_accum >= ep->pps) {
 		sample_accum -= ep->pps;
 		ret = ep->packsize[1];


