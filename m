Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647F4106FAB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfKVLQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730047AbfKVKtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:49:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75C1820718;
        Fri, 22 Nov 2019 10:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419783;
        bh=7Eclvyk1oSXbFBFh01VOpWjcHVSzMgEQTosnOwSpzDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HInn5tANxv2PvrMlCiMrpBhZLyBu8UpDCP516QovR+hDlxd3U20WppTElKLdjw0gT
         SiUVKaLPBOvMiPqzrcPBS9bZraDh+ahiJ1JlfRKgiYqQMfRaRWlBvSwVmCIgEwdW2M
         VwkjomS3dTX9yQAiyJcmj7k3AuBbXgUy7WGnrbUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 210/222] media: cx231xx: fix potential sign-extension overflow on large shift
Date:   Fri, 22 Nov 2019 11:29:10 +0100
Message-Id: <20191122100917.549324891@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 32ae592036d7aeaabcccb2b1715373a68639a768 ]

Shifting the u8 value[3] by an int can lead to sign-extension
overflow. For example, if value[3] is 0xff and the shift is 24 then it
is promoted to int and then the top bit is sign-extended so that all
upper 32 bits are set.  Fix this by casting value[3] to a u32 before
the shift.

Detected by CoverityScan, CID#1016522 ("Unintended sign extension")

Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 6414188ffdfac..cd973e780da93 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1389,7 +1389,7 @@ int cx231xx_g_register(struct file *file, void *priv,
 		ret = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
 				(u16)reg->reg, value, 4);
 		reg->val = value[0] | value[1] << 8 |
-			value[2] << 16 | value[3] << 24;
+			value[2] << 16 | (u32)value[3] << 24;
 		reg->size = 4;
 		break;
 	case 1:	/* AFE - read byte */
-- 
2.20.1



