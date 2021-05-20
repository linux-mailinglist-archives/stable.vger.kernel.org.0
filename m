Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F97938A2DB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhETJqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhETJoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F10676144E;
        Thu, 20 May 2021 09:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503199;
        bh=L4Z/lavsAkh015cOpILC8zaDta2Yugo6DqHJ9fBvJK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6YruzW/B3rJ6tRbOJgKifzhpcUUsawGRBeXMsH1ZDMfzZEANSO1cJWqLQ/t7c+yI
         9PgxSXmsvUVCZBJYU2Wc1wNoDlgViTsFyg+bNYI/UsViKEh+DISCiV5xVK+QKJxh3q
         tQDzlaLEEdYBBLrNUglO20DOw/b72vAUA7O0N7xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7f09440acc069a0d38ac@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 106/425] media: dvbdev: Fix memory leak in dvb_media_device_free()
Date:   Thu, 20 May 2021 11:17:55 +0200
Message-Id: <20210520092134.940765597@linuxfoundation.org>
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

From: Peilin Ye <yepeilin.cs@gmail.com>

commit bf9a40ae8d722f281a2721779595d6df1c33a0bf upstream.

dvb_media_device_free() is leaking memory. Free `dvbdev->adapter->conn`
before setting it to NULL, as documented in include/media/media-device.h:
"The media_entity instance itself must be freed explicitly by the driver
if required."

Link: https://syzkaller.appspot.com/bug?id=9bbe4b842c98f0ed05c5eed77a226e9de33bf298

Link: https://lore.kernel.org/linux-media/20201211083039.521617-1-yepeilin.cs@gmail.com
Cc: stable@vger.kernel.org
Fixes: 0230d60e4661 ("[media] dvbdev: Add RF connector if needed")
Reported-by: syzbot+7f09440acc069a0d38ac@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -241,6 +241,7 @@ static void dvb_media_device_free(struct
 
 	if (dvbdev->adapter->conn) {
 		media_device_unregister_entity(dvbdev->adapter->conn);
+		kfree(dvbdev->adapter->conn);
 		dvbdev->adapter->conn = NULL;
 		kfree(dvbdev->adapter->conn_pads);
 		dvbdev->adapter->conn_pads = NULL;


