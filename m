Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851C4B9284
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388255AbfITOd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:33:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36282 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388204AbfITOZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqK-0004xy-KH; Fri, 20 Sep 2019 15:25:04 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007z6-I8; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+219f00fb49874dcaea17@syzkaller.appspotmail.com,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.843775932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 123/132] ALSA: line6: Fix write on zero-sized buffer
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3450121997ce872eb7f1248417225827ea249710 upstream.

LINE6 drivers allocate the buffers based on the value returned from
usb_maxpacket() calls.  The manipulated device may return zero for
this, and this results in the kmalloc() with zero size (and it may
succeed) while the other part of the driver code writes the packet
data with the fixed size -- which eventually overwrites.

This patch adds a simple sanity check for the invalid buffer size for
avoiding that problem.

Reported-by: syzbot+219f00fb49874dcaea17@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16:
 - Driver doesn't support asymmetrical packet sizes, so only check
   snd_line6_pcm::max_packet_size
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/line6/pcm.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -492,6 +492,11 @@ int line6_init_pcm(struct usb_line6 *lin
 				usb_rcvisocpipe(line6->usbdev, ep_read), 0),
 			usb_maxpacket(line6->usbdev,
 				usb_sndisocpipe(line6->usbdev, ep_write), 1));
+	if (!line6pcm->max_packet_size) {
+		dev_err(line6pcm->line6->ifcdev,
+			"cannot get proper max packet size\n");
+		return -EINVAL;
+	}
 
 	line6pcm->properties = properties;
 	line6->line6pcm = line6pcm;

