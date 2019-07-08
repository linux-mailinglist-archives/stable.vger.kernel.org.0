Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB1D62286
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbfGHPYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388377AbfGHPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43D50216C4;
        Mon,  8 Jul 2019 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599476;
        bh=vVFyYXwho3zCgkOD0rbDcYE6AzYSHyuG8zbWWEKW4J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvtpDwNPfb/Kc0l7l3Sa9IwB0jBm3jWi7nwIzWJTYvfgGUVt+4lfLJJNSIrKgYIbH
         Hzxk6Vef2/HoY07PT4YqVOS9EC4vuRQzts5iKPRR795T5wqJ/V5mYmtXIIEzBXVL6X
         97ldzaBwQTp1pkmhdcZp619Vb+hakPF+/y3PLuRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+219f00fb49874dcaea17@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 28/56] ALSA: line6: Fix write on zero-sized buffer
Date:   Mon,  8 Jul 2019 17:13:20 +0200
Message-Id: <20190708150522.453606217@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/pcm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -558,6 +558,11 @@ int line6_init_pcm(struct usb_line6 *lin
 	line6pcm->max_packet_size_out =
 		usb_maxpacket(line6->usbdev,
 			usb_sndisocpipe(line6->usbdev, ep_write), 1);
+	if (!line6pcm->max_packet_size_in || !line6pcm->max_packet_size_out) {
+		dev_err(line6pcm->line6->ifcdev,
+			"cannot get proper max packet size\n");
+		return -EINVAL;
+	}
 
 	spin_lock_init(&line6pcm->out.lock);
 	spin_lock_init(&line6pcm->in.lock);


