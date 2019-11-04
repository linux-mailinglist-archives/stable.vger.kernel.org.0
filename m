Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706F4EEF04
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfKDWSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389171AbfKDWBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:01:46 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC8CA205C9;
        Mon,  4 Nov 2019 22:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904906;
        bh=v0IrQyRi9n+bfhh9+5Fe2BJGlZxsDr2cCWzbbt2oXfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fy/ol/dtOK4uwYyfDjMsplgyO4GUkMLy+Ypym8tCn01tJip9iudQeyAL0B4iGz3D1
         V+yYd+3ievpfJWm2DGI7fwBQP/sKfX312hswkHj/YJmtuQx0Agwp/AaIE5JT8FX8s4
         S+SCxTxTDoISeoR5YuPnpBfbfE2A+0ZiWD9L/5nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 111/149] ALSA: bebob: Fix prototype of helper function to return negative value
Date:   Mon,  4 Nov 2019 22:45:04 +0100
Message-Id: <20191104212144.168753005@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit f2bbdbcb075f3977a53da3bdcb7cd460bc8ae5f2 upstream.

A helper function of ALSA bebob driver returns negative value in a
function which has a prototype to return unsigned value.

This commit fixes it by changing the prototype.

Fixes: eb7b3a056cd8 ("ALSA: bebob: Add commands and connections/streams management")
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20191026030620.12077-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/bebob/bebob_stream.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -253,8 +253,7 @@ end:
 	return err;
 }
 
-static unsigned int
-map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
+static int map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
 {
 	unsigned int sec, sections, ch, channels;
 	unsigned int pcm, midi, location;


