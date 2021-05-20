Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667C738A88C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhETKvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238542AbhETKtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAABA61CBC;
        Thu, 20 May 2021 09:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504745;
        bh=tjkIxn5V8+0BzLdtAIO2twJtqa+6KImAIg9oC+bPsrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5a8z10VjsapXPvTs2meaHNSdXuTGFT+q+lxr+3V/10Rwiqm2PEmJKUuf6twvv8KS
         XEE9GTRVHOL5JjsaT4osvWzKD2Z6/NkE6T641ipvRe66/ifuLfqXzhtHtXBgDHFYb3
         7oKeuHTIvyV21Ls+uQJ4jeexBCpjR2gtxVZeb6F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7f09440acc069a0d38ac@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.9 061/240] media: dvbdev: Fix memory leak in dvb_media_device_free()
Date:   Thu, 20 May 2021 11:20:53 +0200
Message-Id: <20210520092110.731561447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -216,6 +216,7 @@ static void dvb_media_device_free(struct
 
 	if (dvbdev->adapter->conn) {
 		media_device_unregister_entity(dvbdev->adapter->conn);
+		kfree(dvbdev->adapter->conn);
 		dvbdev->adapter->conn = NULL;
 		kfree(dvbdev->adapter->conn_pads);
 		dvbdev->adapter->conn_pads = NULL;


