Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C9F38EFC6
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhEXP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235604AbhEXP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0327961451;
        Mon, 24 May 2021 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871083;
        bh=5jrsJcfOXLB7iq3lldWj7N22rfEhJCXEKYzQ1G6TaiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuzhonupnkhAhdnZXSH17WoPrq0vGw5Z9u534m9h6KJtfZTXCXjN6wwEMfI2wG4xE
         zVUstcJjQINmovGsOhgGJ1pXupBGBwptaGmwoKfx5spWLVcX+3RQbrjk9wQtb0mTxz
         BI62BuOceJBWm9VN7p4wno6L4ToU1DaYWVG8T2zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 053/127] ALSA: hda/realtek: reset eapd coeff to default value for alc287
Date:   Mon, 24 May 2021 17:26:10 +0200
Message-Id: <20210524152336.633025220@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 8822702f6e4c8917c83ba79e0ebf2c8c218910d4 upstream.

Ubuntu users reported an audio bug on the Lenovo Yoga Slim 7 14IIL05,
he installed dual OS (Windows + Linux), if he booted to the Linux
from Windows, the Speaker can't work well, it has crackling noise,
if he poweroff the machine first after Windows, the Speaker worked
well.

Before rebooting or shutdown from Windows, the Windows changes the
codec eapd coeff value, but the BIOS doesn't re-initialize its value,
when booting into the Linux from Windows, the eapd coeff value is not
correct. To fix it, set the codec default value to that coeff register
in the alsa driver.

BugLink: http://bugs.launchpad.net/bugs/1925057
Suggested-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210507024452.8300-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -395,7 +395,6 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
-	case 0x10ec0287:
 	case 0x10ec0288:
 	case 0x10ec0285:
 	case 0x10ec0298:
@@ -406,6 +405,10 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;
+	case 0x10ec0287:
+		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+		alc_write_coef_idx(codec, 0x8, 0x4ab7);
+		break;
 	case 0x10ec0293:
 		alc_update_coef_idx(codec, 0xa, 1<<13, 0);
 		break;


