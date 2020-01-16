Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977AD13FFA9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgAPXXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387865AbgAPXXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD9820684;
        Thu, 16 Jan 2020 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216986;
        bh=kJNnl/UzmoXOLMb8P8vtHUTkV0BMt3uFLWsw58WtJzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+0AU8Q0XR3AEzml5YSuyiEVXmQw2wl8c+EkRZK/ZYoGoV0ejzXXWQB0t3dZV7r3y
         8AlTKmVbBH1e/MPQVnoI7An8vrrvakoXfD/5gan7oWembYL52QRNI0Y7Eu58pj6WDl
         7eHU1sxRC+kgH/mUWkzfaPNqJwsIA59bbimKTnTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 085/203] scsi: enclosure: Fix stale device oops with hot replug
Date:   Fri, 17 Jan 2020 00:16:42 +0100
Message-Id: <20200116231752.791827377@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 529244bd1afc102ab164429d338d310d5d65e60d upstream.

Doing an add/remove/add on a SCSI device in an enclosure leads to an oops
caused by poisoned values in the enclosure device list pointers.  The
reason is because we are keeping the enclosure device across the enclosed
device add/remove/add but the current code is doing a
device_add/device_del/device_add on it.  This is the wrong thing to do in
sysfs, so fix it by not doing a device_del on the enclosure device simply
because of a hot remove of the drive in the slot.

[mkp: added missing email addresses]

Fixes: 43d8eb9cfd0a ("[SCSI] ses: add support for enclosure component hot removal")
Link: https://lore.kernel.org/r/1578532892.3852.10.camel@HansenPartnership.com
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reported-by: Luo Jiaxing <luojiaxing@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/enclosure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -406,10 +406,9 @@ int enclosure_remove_device(struct enclo
 		cdev = &edev->component[i];
 		if (cdev->dev == dev) {
 			enclosure_remove_links(cdev);
-			device_del(&cdev->cdev);
 			put_device(dev);
 			cdev->dev = NULL;
-			return device_add(&cdev->cdev);
+			return 0;
 		}
 	}
 	return -ENODEV;


