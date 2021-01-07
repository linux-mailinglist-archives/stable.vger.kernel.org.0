Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22242ED203
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbhAGOQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbhAGOQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4700E23340;
        Thu,  7 Jan 2021 14:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028941;
        bh=p17C2ldw8ofBM0ZrlG1PqCrzUqOXSjWtJpZ8+tbUu9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obotF9Zpjobf8+kxyfenGHlQFiySlOJx1Of9rsnZGMZ0CR0Uq/8KTzBvT/Z4Nx5dG
         q2Io1oMqdGl1erWO1j2UCWg/Ihcs69uFO3k8vf5HDua0qih26hQaOtBl560sWzmplq
         MiFU3WvrLHSua2VhN5patKyRciPjDcbIREJR+qsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 06/19] ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236
Date:   Thu,  7 Jan 2021 15:16:31 +0100
Message-Id: <20210107140827.883874186@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit e1e8c1fdce8b00fce08784d9d738c60ebf598ebc upstream

headphone have noise even the volume is very small.
Let it fill up pcbeep hidden register to default value.
The issue was gone.

Fixes: 4344aec84bd8 ("ALSA: hda/realtek - New codec support for ALC256")
Fixes: 736f20a70608 ("ALSA: hda/realtek - Add support for ALC236/ALC3204")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/9ae47f23a64d4e41a9c81e263cd8a250@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -330,9 +330,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0225:
 	case 0x10ec0233:
 	case 0x10ec0235:
-	case 0x10ec0236:
 	case 0x10ec0255:
-	case 0x10ec0256:
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
@@ -342,6 +340,11 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0299:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
+	case 0x10ec0236:
+	case 0x10ec0256:
+		alc_write_coef_idx(codec, 0x36, 0x5757);
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		break;
 	case 0x10ec0285:
 	case 0x10ec0293:
 		alc_update_coef_idx(codec, 0xa, 1<<13, 0);


