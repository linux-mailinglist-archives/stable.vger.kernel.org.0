Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C181C14BD
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfI2N5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D66721882;
        Sun, 29 Sep 2019 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765465;
        bh=mQF3ZLBvKy/B8A+TuTlycHnH+6XWoMZBepOttnC9Fd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUAg1QLZ2l6/YdwAhuT9LJvZryYARs8UKTqEszLnXIoOCpuKn4IydD4cmSFLvMyzc
         zBAVDSsjmK10JBNB8xIOH6vIZrgi69E2tFSQxjwYwphpOF3fRAsXiHacwA1njhr7Xj
         RBsUB0h+2xu18AWt29Mg8Xza56CMIpD+dD3FNdzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Laako <jussi@sonarnerd.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 28/63] ALSA: usb-audio: Add DSD support for EVGA NU Audio
Date:   Sun, 29 Sep 2019 15:54:01 +0200
Message-Id: <20190929135037.236768789@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jussi Laako <jussi@sonarnerd.net>

commit f41f900568d9ffd896cc941db7021eb14bd55910 upstream.

EVGA NU Audio is actually a USB audio device on a PCIexpress card,
with it's own USB controller. It supports both PCM and DSD.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190924071143.30911-1-jussi@sonarnerd.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1449,6 +1449,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case 0x152a:  /* Thesycon devices */
 	case 0x25ce:  /* Mytek devices */
 	case 0x2ab6:  /* T+A devices */
+	case 0x3842:  /* EVGA */
 	case 0xc502:  /* HiBy devices */
 		if (fp->dsd_raw)
 			return SNDRV_PCM_FMTBIT_DSD_U32_BE;


