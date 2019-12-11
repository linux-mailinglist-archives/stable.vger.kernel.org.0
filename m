Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02F811AFA9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfLKPOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730557AbfLKPOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D45BA20663;
        Wed, 11 Dec 2019 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077289;
        bh=LeAPWS1q/KOLDpGgVEacQrTfjk9Ai/9gmAc+kjSCoTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tt03TsElVNQgJmvaWCFtNx4mhuQInA4JMR2ZsV4Yv03Y3K6MSbj1tJ+DZiSyeD3ux
         e5Yt/rD6r8hEQwg6fcycmbAnNqK/zyHe8RN4AvMz930zcy/1voHF+RMwY07t0ei2TZ
         jLzpz3IR4feSHfxCfTg/ogncmJO1yOAhpTBFsgUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.3 051/105] ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236
Date:   Wed, 11 Dec 2019 16:05:40 +0100
Message-Id: <20191211150242.248145590@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit e1e8c1fdce8b00fce08784d9d738c60ebf598ebc upstream.

headphone have noise even the volume is very small.
Let it fill up pcbeep hidden register to default value.
The issue was gone.

Fixes: 4344aec84bd8 ("ALSA: hda/realtek - New codec support for ALC256")
Fixes: 736f20a70608 ("ALSA: hda/realtek - Add support for ALC236/ALC3204")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/9ae47f23a64d4e41a9c81e263cd8a250@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -367,9 +367,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0215:
 	case 0x10ec0233:
 	case 0x10ec0235:
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -381,6 +379,11 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x36, 0x5757);
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		break;
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;


