Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D980638A24B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhETJk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233241AbhETJiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:38:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A367613D6;
        Thu, 20 May 2021 09:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503055;
        bh=71XwmiYEqE86phbVMEykCV8hy+dESJ4c8+LHyZEaTs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnTjSkAetsfFQcEgDN3MNrElOXPmNOKBa23KveYWxhRlIei+asPomQvGaP2YR5GlZ
         DCNNy8/ZJnDctef2d4w07vfcM7GLSprpYKlAu0cdp48tuFrMQUQk6WrASRib9ml1ZD
         gSz+GpCuwaNIXIlvG4PV9IdUJ53bDNpUjYKCLGAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Niv <danielniv3@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/425] media: media/saa7164: fix saa7164_encoder_register() memory leak bugs
Date:   Thu, 20 May 2021 11:16:58 +0200
Message-Id: <20210520092133.042908459@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Niv <danielniv3@gmail.com>

[ Upstream commit c759b2970c561e3b56aa030deb13db104262adfe ]

Add a fix for the memory leak bugs that can occur when the
saa7164_encoder_register() function fails.
The function allocates memory without explicitly freeing
it when errors occur.
Add a better error handling that deallocate the unused buffers before the
function exits during a fail.

Signed-off-by: Daniel Niv <danielniv3@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 32136ebe4f61..962f8eb73b05 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1024,7 +1024,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 		printk(KERN_ERR "%s() failed (errno = %d), NO PCI configuration\n",
 			__func__, result);
 		result = -ENOMEM;
-		goto failed;
+		goto fail_pci;
 	}
 
 	/* Establish encoder defaults here */
@@ -1078,7 +1078,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 			  100000, ENCODER_DEF_BITRATE);
 	if (hdl->error) {
 		result = hdl->error;
-		goto failed;
+		goto fail_hdl;
 	}
 
 	port->std = V4L2_STD_NTSC_M;
@@ -1096,7 +1096,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 		printk(KERN_INFO "%s: can't allocate mpeg device\n",
 			dev->name);
 		result = -ENOMEM;
-		goto failed;
+		goto fail_hdl;
 	}
 
 	port->v4l_device->ctrl_handler = hdl;
@@ -1107,10 +1107,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 	if (result < 0) {
 		printk(KERN_INFO "%s: can't register mpeg device\n",
 			dev->name);
-		/* TODO: We're going to leak here if we don't dealloc
-		 The buffers above. The unreg function can't deal wit it.
-		*/
-		goto failed;
+		goto fail_reg;
 	}
 
 	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
@@ -1132,9 +1129,14 @@ int saa7164_encoder_register(struct saa7164_port *port)
 
 	saa7164_api_set_encoder(port);
 	saa7164_api_get_encoder(port);
+	return 0;
 
-	result = 0;
-failed:
+fail_reg:
+	video_device_release(port->v4l_device);
+	port->v4l_device = NULL;
+fail_hdl:
+	v4l2_ctrl_handler_free(hdl);
+fail_pci:
 	return result;
 }
 
-- 
2.30.2



