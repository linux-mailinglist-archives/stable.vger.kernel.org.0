Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16421431D9B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhJRNwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234185AbhJRNui (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37BBF610A1;
        Mon, 18 Oct 2021 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564282;
        bh=N+mQ5QdIx70i1nulsl5kj6w9HtxeDu8N1DcbeuyO1mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/GYbseYZcY7PIuINE2VMS6hmBJXVDQ8IOTH7zu5PVaV72m2gLoV9n0A/Id1Sq/UF
         Kin5QoozPyrrCAOTU1fLSEKbm64VHI5H1+onawXmPnjByRFEtc/npQekNU8PX4baVr
         NVW0GfZDHMELLSrxGzVsMzLeZTgKmaPehR4CjBm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 003/151] ALSA: usb-audio: Fix a missing error check in scarlett gen2 mixer
Date:   Mon, 18 Oct 2021 15:23:02 +0200
Message-Id: <20211018132340.790448596@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 8ec59ac3ad29891c0afef627640df36f2daa0349 upstream.

The check of the returned error code is missing in
scarlett2_update_monitor_other().  Let's fix it.

Fixes: d5bda7e03982 ("ALSA: usb-audio: scarlett2: Add support for the talkback feature")
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/202109131831.9IodEzRx-lkp@intel.com
Link: https://lore.kernel.org/r/20210929073540.9611-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett_gen2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -2450,6 +2450,8 @@ static int scarlett2_update_monitor_othe
 		err = scarlett2_usb_get_config(mixer,
 					       SCARLETT2_CONFIG_TALKBACK_MAP,
 					       1, &bitmap);
+		if (err < 0)
+			return err;
 		for (i = 0; i < num_mixes; i++, bitmap >>= 1)
 			private->talkback_map[i] = bitmap & 1;
 	}


