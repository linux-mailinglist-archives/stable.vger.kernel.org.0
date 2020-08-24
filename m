Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC4924F41B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgHXIcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgHXIcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30202207DF;
        Mon, 24 Aug 2020 08:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257960;
        bh=FjtyRzKl5dNr/nqa1SPE8npl47++2SYycFDGps+xMo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Inzly5gOWaWeTX1zrER6RY4VUdxVDNUrFbF5S90+jMM99bXmDdY+f8JrhSyxwztwh
         ljpQ8bJcLhbL7xtrwLxhf/I1D8SdkEaz7OTnw/T21p+NbXaYT9y698VvRxzRvmKUnW
         9YJIgFS3C5so0pfa87an4mlPdT1uO2dGJ2fWCG6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 006/148] ALSA: hda: avoid reset of sdo_limit
Date:   Mon, 24 Aug 2020 10:28:24 +0200
Message-Id: <20200824082414.257003100@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit b90b925fd52c75ee7531df739d850a1f7c58ef06 upstream.

By default 'sdo_limit' is initialized with a default value of '8'
as per spec. This is overridden in cases where a different value is
required. However this is getting reset when snd_hdac_bus_init_chip()
is called again, which happens during runtime PM cycle.

Avoid this reset by moving 'sdo_limit' setup to 'snd_hdac_bus_init()'
function which would be called only once.

Fixes: 67ae482a59e9 ("ALSA: hda: add member to store ratio for stripe control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1597851130-6765-1-git-send-email-spujar@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/hda/hdac_bus.c        |   12 ++++++++++++
 sound/hda/hdac_controller.c |   11 -----------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/sound/hda/hdac_bus.c
+++ b/sound/hda/hdac_bus.c
@@ -46,6 +46,18 @@ int snd_hdac_bus_init(struct hdac_bus *b
 	INIT_LIST_HEAD(&bus->hlink_list);
 	init_waitqueue_head(&bus->rirb_wq);
 	bus->irq = -1;
+
+	/*
+	 * Default value of '8' is as per the HD audio specification (Rev 1.0a).
+	 * Following relation is used to derive STRIPE control value.
+	 *  For sample rate <= 48K:
+	 *   { ((num_channels * bits_per_sample) / number of SDOs) >= 8 }
+	 *  For sample rate > 48K:
+	 *   { ((num_channels * bits_per_sample * rate/48000) /
+	 *	number of SDOs) >= 8 }
+	 */
+	bus->sdo_limit = 8;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_hdac_bus_init);
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -529,17 +529,6 @@ bool snd_hdac_bus_init_chip(struct hdac_
 
 	bus->chip_init = true;
 
-	/*
-	 * Default value of '8' is as per the HD audio specification (Rev 1.0a).
-	 * Following relation is used to derive STRIPE control value.
-	 *  For sample rate <= 48K:
-	 *   { ((num_channels * bits_per_sample) / number of SDOs) >= 8 }
-	 *  For sample rate > 48K:
-	 *   { ((num_channels * bits_per_sample * rate/48000) /
-	 *	number of SDOs) >= 8 }
-	 */
-	bus->sdo_limit = 8;
-
 	return true;
 }
 EXPORT_SYMBOL_GPL(snd_hdac_bus_init_chip);


