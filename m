Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC372E3C97
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437395AbgL1OEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437382AbgL1OEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAFC7206D4;
        Mon, 28 Dec 2020 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164259;
        bh=3vucih4tF+dWL/5eSd/msFD16XeurQkjRefXMhHHfuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2NdVei+QKYcUyNKn3x2nv94gE3dEGHmZWNHAivkGZeMm4laSZvBjgY+97TsrQ6rM
         eBM6NDrn7kIa0CEm4+uFd1aPzc9vkenIm58yAQvatbg0bTwl0anawCFdmkfHJpdyRO
         ndCNxCf4mvZtwsuBRIU93QHYQWOkzkfnEtCuIVb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/717] media: tm6000: Fix sizeof() mismatches
Date:   Mon, 28 Dec 2020 13:41:56 +0100
Message-Id: <20201228125026.614861728@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a08ad6339e0441ca12533969ed94a87e3655426e ]

The are two instances of sizeof() being used incorrectly. The
sizeof(void *) is incorrect because urb_buffer is a char ** pointer,
fix this by using sizeof(*dev->urb_buffer).  The sizeof(dma_addr_t *)
is incorrect, it should be sizeof(*dev->urb_dma), which is a dma_addr_t
and not a dma_addr_t *.  This errors did not cause any issues because
it just so happens the sizes are the same.

Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")

Fixes: 16427faf2867 ("[media] tm6000: Add parameter to keep urb bufs allocated")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/tm6000/tm6000-video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index bfba06ea60e9d..2df736c029d6e 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -461,11 +461,12 @@ static int tm6000_alloc_urb_buffers(struct tm6000_core *dev)
 	if (dev->urb_buffer)
 		return 0;
 
-	dev->urb_buffer = kmalloc_array(num_bufs, sizeof(void *), GFP_KERNEL);
+	dev->urb_buffer = kmalloc_array(num_bufs, sizeof(*dev->urb_buffer),
+					GFP_KERNEL);
 	if (!dev->urb_buffer)
 		return -ENOMEM;
 
-	dev->urb_dma = kmalloc_array(num_bufs, sizeof(dma_addr_t *),
+	dev->urb_dma = kmalloc_array(num_bufs, sizeof(*dev->urb_dma),
 				     GFP_KERNEL);
 	if (!dev->urb_dma)
 		return -ENOMEM;
-- 
2.27.0



