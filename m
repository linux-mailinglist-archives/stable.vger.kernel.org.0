Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEA1FB741
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbgFPPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731975AbgFPPo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15E3208E4;
        Tue, 16 Jun 2020 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322267;
        bh=xUyXfkQdON4UZ0F/07NZKKPngMjnfR4FTYVv2FmUUpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAKUxfis0jS6bB8guFoQMHdBacrcr3koYdAZKBqXhdOv8tRrFCTM2PPiQQR5M+qvy
         HOkENOQJzL7U7/uzgJq1pXIWr3YIE/rkSB//PpMpNEeaNqRPtWzKEiWICdWuQlCjfF
         xD9MBPeRTF+8DUMCXb0hP6Wg+0MGLuoztyXu++tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 066/163] ALSA: fireface: start IR context immediately
Date:   Tue, 16 Jun 2020 17:34:00 +0200
Message-Id: <20200616153110.005372708@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit f4588cc425beb62e355bc2a5de5d5c83e26a74ca upstream.

In the latter models of RME Fireface series, device start to transfer
packets several dozens of milliseconds. On the other hand, ALSA fireface
driver starts IR context 2 milliseconds after the start. This results
in loss to handle incoming packets on the context.

This commit changes to start IR context immediately instead of
postponement. For Fireface 800, this affects nothing because the device
transfer packets 100 milliseconds or so after the start and this is
within wait timeout.

Cc: <stable@vger.kernel.org>
Fixes: acfedcbe1ce4 ("ALSA: firewire-lib: postpone to start IR context")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200510074301.116224-3-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/fireface/ff-stream.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/sound/firewire/fireface/ff-stream.c
+++ b/sound/firewire/fireface/ff-stream.c
@@ -184,7 +184,6 @@ int snd_ff_stream_start_duplex(struct sn
 	 */
 	if (!amdtp_stream_running(&ff->rx_stream)) {
 		int spd = fw_parent_device(ff->unit)->max_speed;
-		unsigned int ir_delay_cycle;
 
 		err = ff->spec->protocol->begin_session(ff, rate);
 		if (err < 0)
@@ -200,14 +199,7 @@ int snd_ff_stream_start_duplex(struct sn
 		if (err < 0)
 			goto error;
 
-		// The device postpones start of transmission mostly for several
-		// cycles after receiving packets firstly.
-		if (ff->spec->protocol == &snd_ff_protocol_ff800)
-			ir_delay_cycle = 800;	// = 100 msec
-		else
-			ir_delay_cycle = 16;	// = 2 msec
-
-		err = amdtp_domain_start(&ff->domain, ir_delay_cycle);
+		err = amdtp_domain_start(&ff->domain, 0);
 		if (err < 0)
 			goto error;
 


