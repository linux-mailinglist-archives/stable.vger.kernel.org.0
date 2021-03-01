Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827A3328816
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhCARcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238423AbhCAR1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F3F6508E;
        Mon,  1 Mar 2021 16:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617477;
        bh=2cCC6TH7qeRG0yCgcOb5UmMIhP5lGkq+1TM5FO9x5ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVJqzH1O4C0rKlhKnyv04nhke1IccFd/gE2DxQGsJvzA9ziiK/iPs/8jvWxyD6otb
         ab1pR9pa2iVq6yE4aJHcnBy6H45siInPSCcThx0xRMJ5LaHJQbOt/9/skCrjswM9kB
         4nfThWGMft4itp3wPnSKIB1AV3facCzojoOTV6qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/340] media: tm6000: Fix memleak in tm6000_start_stream
Date:   Mon,  1 Mar 2021 17:10:31 +0100
Message-Id: <20210301161052.605156521@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 76aaf8a96771c16365b8510f1fb97738dc88026e ]

When usb_clear_halt() fails, dvb->bulk_urb->transfer_buffer
and dvb->bulk_urb should be freed just like when
usb_submit_urb() fails.

Fixes: 3169c9b26fffa ("V4L/DVB (12788): tm6000: Add initial DVB-T support")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/tm6000/tm6000-dvb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 19c90fa9e443d..293a460f4616c 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -141,6 +141,10 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	if (ret < 0) {
 		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",
 							ret, __func__);
+
+		kfree(dvb->bulk_urb->transfer_buffer);
+		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		return ret;
 	} else
 		printk(KERN_ERR "tm6000: pipe reset\n");
-- 
2.27.0



