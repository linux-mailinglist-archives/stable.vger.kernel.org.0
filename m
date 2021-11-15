Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E57E45013F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhKOJ1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237383AbhKOJ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 04:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2669163215;
        Mon, 15 Nov 2021 09:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636968245;
        bh=2lg2JptMLNqWWB2g53wc+wVav8qAFFffRwcb19WMr+U=;
        h=Subject:To:From:Date:From;
        b=teJqSnS7RFgmuETRUXtGhMS9UNEuqZHYoscicQlPqC73cZZLn651+nuug5Fdzw+V4
         zzuzDDLe/1e8NwZoDNPMZ8XTRpvlkdfDzlnVCrIDJ+1eh0XjgSuMCn4KInS+xkk07y
         jiuf2cBrQS+jpucl+OFSutXjl8l3uqpfO25BwCXY=
Subject: patch "staging: r8188eu: fix a memory leak in rtw_wx_read32()" added to staging-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 10:23:50 +0100
Message-ID: <163696823047119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: fix a memory leak in rtw_wx_read32()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From be4ea8f383551b9dae11b8dfff1f38b3b5436e9a Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 9 Nov 2021 14:49:36 +0300
Subject: staging: r8188eu: fix a memory leak in rtw_wx_read32()

Free "ptmp" before returning -EINVAL.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211109114935.GC16587@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/r8188eu/os_dep/ioctl_linux.c b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
index 52d42e576443..9404355726d0 100644
--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -1980,6 +1980,7 @@ static int rtw_wx_read32(struct net_device *dev,
 	u32 data32;
 	u32 bytes;
 	u8 *ptmp;
+	int ret;
 
 	padapter = (struct adapter *)rtw_netdev_priv(dev);
 	p = &wrqu->data;
@@ -2007,12 +2008,17 @@ static int rtw_wx_read32(struct net_device *dev,
 		break;
 	default:
 		DBG_88E(KERN_INFO "%s: usage> read [bytes],[address(hex)]\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_free_ptmp;
 	}
 	DBG_88E(KERN_INFO "%s: addr = 0x%08X data =%s\n", __func__, addr, extra);
 
 	kfree(ptmp);
 	return 0;
+
+err_free_ptmp:
+	kfree(ptmp);
+	return ret;
 }
 
 static int rtw_wx_write32(struct net_device *dev,
-- 
2.33.1


