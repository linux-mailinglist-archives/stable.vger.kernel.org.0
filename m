Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0C23283AE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbhCAQXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235459AbhCAQVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F8764EE9;
        Mon,  1 Mar 2021 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615514;
        bh=PyHnulEqEL4dblbmwHgvs66MxrrH1EVh0ZJeUgRl498=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch6aoK56UMnG9HPmFTFr8u6Qw+GrCKA4Nc+31X3Y/4Y4NCDh1EWfFL5LtyBVeUIUN
         GaOlELRZbVMixI/nDYJiJ0lSfCL1M7Kk0FMx+tBFst0mhW0w0jJa6BHRm5fyz3XBp3
         BzUmZPdhUUl4VmKfl1fkn5Mb6vuUnpcJoSTda9Tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 26/93] media: tm6000: Fix memleak in tm6000_start_stream
Date:   Mon,  1 Mar 2021 17:12:38 +0100
Message-Id: <20210301161008.185424561@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 87401b18d85a8..8afc7de1cf834 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -158,6 +158,10 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	if (ret < 0) {
 		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",
 							ret, __func__);
+
+		kfree(dvb->bulk_urb->transfer_buffer);
+		usb_free_urb(dvb->bulk_urb);
+		dvb->bulk_urb = NULL;
 		return ret;
 	} else
 		printk(KERN_ERR "tm6000: pipe resetted\n");
-- 
2.27.0



