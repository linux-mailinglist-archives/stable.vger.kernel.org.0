Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA24F20E840
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbgF2WFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgF2SfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159A124655;
        Mon, 29 Jun 2020 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443968;
        bh=1FFAhl0OAM6WMZkxs4GUZv3PqFs8gVfwKn18iQl9Ccg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRtESvOMqMQ66pWE3IXEvARAOJ+wfYUki8Fjq3L3iKPm6osGsPQNabdvp2k4VHnpk
         wPjg2ifIjA55r0oaWFqBDSSxgs3V1UxPvUQJcdq3BYc1bp24bzwr0SmNqQXB4EdERz
         IlNwNi7taJjTGgpCYrRv9YFDj3ICV26to/BttD6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurence Tratt <laurie@tratt.net>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 072/265] ALSA: usb-audio: Add implicit feedback quirk for SSL2+.
Date:   Mon, 29 Jun 2020 11:15:05 -0400
Message-Id: <20200629151818.2493727-73-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurence Tratt <laurie@tratt.net>

commit e7585db1b0b5b4e4eb1967bb1472df308f7ffcbf upstream.

This uses the same quirk as the Motu M2 and M4 to ensure the driver uses the
audio interface's clock. Tested on an SSL2+.

Signed-off-by: Laurence Tratt <laurie@tratt.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200612111807.dgnig6rwhmsl2bod@overdrive.tratt.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 3411e27eb64bb..39aec83f8aca4 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -367,6 +367,7 @@ static int set_sync_ep_implicit_fb_quirk(struct snd_usb_substream *subs,
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series */
+	case USB_ID(0x31e9, 0x0002): /* Solid State Logic SSL2+ */
 		ep = 0x81;
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;
-- 
2.25.1

