Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D516E429009
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhJKOEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238665AbhJKOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD92061139;
        Mon, 11 Oct 2021 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960657;
        bh=CFd8EFEfmviIBDk9D8vzZm+qxmDdTNd1iyP/6ftIbBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wre/7qmJv56lrUlB20+RySzOmja7iT66HM/vaKfJZOHYMkAq7j1DQzVnYmwZ79Rv6
         nwfCM/aRiuhSM13qK660Uxp3Nc+GtCWOgz81NuagUW65OmxIsvCzlib7C4POL1cOrg
         U78MK5ELpnZobPIp7RDPQj46XxqanF+qlgwvP8Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henrik Enquist <henrik.enquist@gmail.com>,
        Jack Pham <jackp@codeaurora.org>,
        Pavel Hofman <pavel.hofman@ivitera.com>
Subject: [PATCH 5.14 004/151] usb: gadget: f_uac2: fixed EP-IN wMaxPacketSize
Date:   Mon, 11 Oct 2021 15:44:36 +0200
Message-Id: <20211011134517.973808230@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Hofman <pavel.hofman@ivitera.com>

commit 0560c9c552c1815e7b480bc11fd785fefc82bb27 upstream.

Async feedback patches broke enumeration on Windows 10 previously fixed
by commit 789ea77310f0 ("usb: gadget: f_uac2: always increase endpoint
max_packet_size by one audio slot").

While the existing calculation for EP OUT capture for async mode yields
size+1 frame due to uac2_opts->fb_max > 0, playback side lost the +1
feature.  Therefore the +1 frame addition must be re-introduced for
playback. Win10 enumerates the device only when both EP IN and EP OUT
max packet sizes are (at least) +1 frame.

Fixes: e89bb4288378 ("usb: gadget: u_audio: add real feedback implementation")
Cc: stable <stable@vger.kernel.org>
Tested-by: Henrik Enquist <henrik.enquist@gmail.com>
Tested-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Pavel Hofman <pavel.hofman@ivitera.com>
Link: https://lore.kernel.org/r/20210924080027.5362-1-pavel.hofman@ivitera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -593,11 +593,17 @@ static int set_ep_max_packet_size(const
 		ssize = uac2_opts->c_ssize;
 	}
 
-	if (!is_playback && (uac2_opts->c_sync == USB_ENDPOINT_SYNC_ASYNC))
+	if (!is_playback && (uac2_opts->c_sync == USB_ENDPOINT_SYNC_ASYNC)) {
+	  // Win10 requires max packet size + 1 frame
 		srate = srate * (1000 + uac2_opts->fb_max) / 1000;
-
-	max_size_bw = num_channels(chmask) * ssize *
-		DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1)));
+		// updated srate is always bigger, therefore DIV_ROUND_UP always yields +1
+		max_size_bw = num_channels(chmask) * ssize *
+			(DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1))));
+	} else {
+		// adding 1 frame provision for Win10
+		max_size_bw = num_channels(chmask) * ssize *
+			(DIV_ROUND_UP(srate, factor / (1 << (ep_desc->bInterval - 1))) + 1);
+	}
 	ep_desc->wMaxPacketSize = cpu_to_le16(min_t(u16, max_size_bw,
 						    max_size_ep));
 


