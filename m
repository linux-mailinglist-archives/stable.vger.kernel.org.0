Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132A11ED32
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfEOLGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfEOLGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:06:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B725C21773;
        Wed, 15 May 2019 11:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918381;
        bh=CfDOrmqhvB71SpN/Uis/7pUbTsJcuGsoD1/3ZjtSGlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goBbl/55qlfG7JEzkGkihrticpxkT9W4EV7rzQDOzg0tEgWcbr+vmB7yls+vrM8Qx
         dRxIVyAiZItZrxahGky3rS5mpgA2NsOWlaSbtZUYTF7iW10yrqaxbw3yns+obyM0Xw
         0Jw9XtZVLYCrdp52uFOTZVD7ZyZNvRE3SxZMy1os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, raymond pang <raymondpangxd@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.4 107/266] libata: fix using DMA buffers on stack
Date:   Wed, 15 May 2019 12:53:34 +0200
Message-Id: <20190515090726.074717568@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dd08a8d9a66de4b54575c294a92630299f7e0fe7 ]

When CONFIG_VMAP_STACK=y, __pa() returns incorrect physical address for
a stack virtual address. Stack DMA buffers must be avoided.

Signed-off-by: raymond pang <raymondpangxd@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/ata/libata-zpodd.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 0ad96c647541..7017a81d53cf 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -51,38 +51,52 @@ static int eject_tray(struct ata_device *dev)
 /* Per the spec, only slot type and drawer type ODD can be supported */
 static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
 {
-	char buf[16];
+	char *buf;
 	unsigned int ret;
-	struct rm_feature_desc *desc = (void *)(buf + 8);
+	struct rm_feature_desc *desc;
 	struct ata_taskfile tf;
 	static const char cdb[] = {  GPCMD_GET_CONFIGURATION,
 			2,      /* only 1 feature descriptor requested */
 			0, 3,   /* 3, removable medium feature */
 			0, 0, 0,/* reserved */
-			0, sizeof(buf),
+			0, 16,
 			0, 0, 0,
 	};
 
+	buf = kzalloc(16, GFP_KERNEL);
+	if (!buf)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+	desc = (void *)(buf + 8);
+
 	ata_tf_init(dev, &tf);
 	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 	tf.protocol = ATAPI_PROT_PIO;
-	tf.lbam = sizeof(buf);
+	tf.lbam = 16;
 
 	ret = ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
-				buf, sizeof(buf), 0);
-	if (ret)
+				buf, 16, 0);
+	if (ret) {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 
-	if (be16_to_cpu(desc->feature_code) != 3)
+	if (be16_to_cpu(desc->feature_code) != 3) {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 
-	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1) {
+		kfree(buf);
 		return ODD_MECH_TYPE_SLOT;
-	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+	} else if (desc->mech_type == 1 && desc->load == 0 &&
+		   desc->eject == 1) {
+		kfree(buf);
 		return ODD_MECH_TYPE_DRAWER;
-	else
+	} else {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 }
 
 /* Test if ODD is zero power ready by sense code */
-- 
2.19.1



