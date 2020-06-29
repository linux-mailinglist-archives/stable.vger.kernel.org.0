Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA7F20DB36
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgF2UE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732996AbgF2Tac (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFA425237;
        Mon, 29 Jun 2020 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444952;
        bh=7IE2Uu2N8YQKG1XRnzrqLrSq4KIELFlb7Zow4BZM670=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1kQjHko9YU0a3VXmpPCrrq+hqkAzBAwkNgEcI6zBxtPhkIJVrZa+wzxigV02p4He
         Ym2/PsnZC9JXx+m+Xiure+FuRtlnxBNwT/k2X3IB5MSccdQrENCcgCzi90QQQexaAB
         E5wBvb2RW49N0RQUAePCTtWf8EpJHUie3CF3oiLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Chihhao Chen <chihhao.chen@mediatek.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 050/131] ALSA: usb-audio: add quirk for Samsung USBC Headset (AKG)
Date:   Mon, 29 Jun 2020 11:33:41 -0400
Message-Id: <20200629153502.2494656-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit a32a1fc99807244d920d274adc46ba04b538cc8a upstream.

We've found Samsung USBC Headset (AKG) (VID: 0x04e8, PID: 0xa051)
need a tiny delay after each class compliant request.
Otherwise the device might not be able to be recognized each times.

Signed-off-by: Chihhao Chen <chihhao.chen@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1592910203-24035-1-git-send-email-macpaul.lin@mediatek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 976eee06907c9..8b5bc809efd3f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1345,6 +1345,14 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	     chip->usb_id == USB_ID(0x0951, 0x16ad)) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		usleep_range(1000, 2000);
+
+	/*
+	 * Samsung USBC Headset (AKG) need a tiny delay after each
+	 * class compliant request. (Model number: AAM625R or AAM627R)
+	 */
+	if (chip->usb_id == USB_ID(0x04e8, 0xa051) &&
+	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
+		usleep_range(5000, 6000);
 }
 
 /*
-- 
2.25.1

