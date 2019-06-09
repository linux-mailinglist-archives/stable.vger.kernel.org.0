Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643D43A7C2
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbfFIQw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731588AbfFIQw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3598204EC;
        Sun,  9 Jun 2019 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099177;
        bh=sVbvg2ZDub4xllll04lYEjeBM8H7V90nmDfC3X3hM6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hE7RX/zWbxVYUkthYccDn8MwyYSIl7M9qge+PQEIQQ/c2PcZovVN6s2GO9Vewx7pO
         4dQzzHHmyZEP8qHij3tw9fg4VkLbVmeYEGCdDt8sZxsFRIEkIbVle30+k/w22OD80+
         dSGJl6a4i4i+XHMaCIWYUfw+AlINrt3VNdhKcz1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 38/83] ALSA: hda/realtek - Set default power save node to 0
Date:   Sun,  9 Jun 2019 18:42:08 +0200
Message-Id: <20190609164131.059784825@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 317d9313925cd8388304286c0d3c8dda7f060a2d upstream.

I measured power consumption between power_save_node=1 and power_save_node=0.
It's almost the same.
Codec will enter to runtime suspend and suspend.
That pin also will enter to D3. Don't need to enter to D3 by single pin.
So, Disable power_save_node as default. It will avoid more issues.
Windows Driver also has not this option at runtime PM.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6317,7 +6317,7 @@ static int patch_alc269(struct hda_codec
 
 	spec = codec->spec;
 	spec->gen.shared_mic_vref_pin = 0x18;
-	codec->power_save_node = 1;
+	codec->power_save_node = 0;
 
 #ifdef CONFIG_PM
 	codec->patch_ops.suspend = alc269_suspend;


