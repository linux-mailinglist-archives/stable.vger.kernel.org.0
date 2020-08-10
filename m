Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045392408AA
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgHJPXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgHJPXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:23:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12E52207FF;
        Mon, 10 Aug 2020 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073025;
        bh=XSqucGMa32wJj88uZBFYJ2AD4Hy2/Cjd6juWq2PmRHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UX0v0F8XHCb6Rd3IcGFrJXTnQxmoLEa8Zsids/BXZHqlC86MV8329aiGduGfgX5jy
         56aq4NMANAF2bSt4SEui13ECC0I1fJY+CJiWeDuKVMfYmMqvij6lQk3PGn18Sl9Q+l
         zdYT3SuXwRHYkA9Ya04swxvF6/1/LxKenf0945Uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor McAdams <conmanx360@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 10/79] ALSA: hda/ca0132 - Fix AE-5 microphone selection commands.
Date:   Mon, 10 Aug 2020 17:20:29 +0200
Message-Id: <20200810151812.632048106@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor McAdams <conmanx360@gmail.com>

commit 7fe3530427e52dd53cd7366914864e29215180a4 upstream.

The ca0113 command had the wrong group_id, 0x48 when it should've been
0x30. The front microphone selection should now work.

Signed-off-by: Connor McAdams <conmanx360@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200803002928.8638-3-conmanx360@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4672,7 +4672,7 @@ static int ca0132_alt_select_in(struct h
 			tmp = FLOAT_ONE;
 			break;
 		case QUIRK_AE5:
-			ca0113_mmio_command_set(codec, 0x48, 0x28, 0x00);
+			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x00);
 			tmp = FLOAT_THREE;
 			break;
 		default:
@@ -4718,7 +4718,7 @@ static int ca0132_alt_select_in(struct h
 			r3di_gpio_mic_set(codec, R3DI_REAR_MIC);
 			break;
 		case QUIRK_AE5:
-			ca0113_mmio_command_set(codec, 0x48, 0x28, 0x00);
+			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x00);
 			break;
 		default:
 			break;
@@ -4757,7 +4757,7 @@ static int ca0132_alt_select_in(struct h
 			tmp = FLOAT_ONE;
 			break;
 		case QUIRK_AE5:
-			ca0113_mmio_command_set(codec, 0x48, 0x28, 0x3f);
+			ca0113_mmio_command_set(codec, 0x30, 0x28, 0x3f);
 			tmp = FLOAT_THREE;
 			break;
 		default:


