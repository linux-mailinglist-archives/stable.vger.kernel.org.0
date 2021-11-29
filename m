Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A5461ECF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379292AbhK2SkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42736 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380103AbhK2SiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C92AB815D5;
        Mon, 29 Nov 2021 18:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC2C53FC7;
        Mon, 29 Nov 2021 18:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210898;
        bh=f4OSadxPciGF83os856TfBP9g0zdHeyj7xiRXw8U62I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqNbTiPKaT3uPIVB66qhs5aIgIdSmEqiLKYRItKAoftAO+jzW7vyIpbg5HWlxDeHm
         zQCFB4ekKu8bJUjNcrcLY6MSBIZ1YEFmsaBMbFWTcq9XeixYXF4iT+9tFqmfEwqC4z
         feKi0pN0SLbPQ8FHCo86nwURr4NL41X3i5o5G2XE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.15 034/179] staging: r8188eu: fix a memory leak in rtw_wx_read32()
Date:   Mon, 29 Nov 2021 19:17:08 +0100
Message-Id: <20211129181720.070578256@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit be4ea8f383551b9dae11b8dfff1f38b3b5436e9a upstream.

Free "ptmp" before returning -EINVAL.

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211109114935.GC16587@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/ioctl_linux.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/staging/r8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/r8188eu/os_dep/ioctl_linux.c
@@ -2061,6 +2061,7 @@ static int rtw_wx_read32(struct net_devi
 	u32 data32;
 	u32 bytes;
 	u8 *ptmp;
+	int ret;
 
 	padapter = (struct adapter *)rtw_netdev_priv(dev);
 	p = &wrqu->data;
@@ -2093,12 +2094,17 @@ static int rtw_wx_read32(struct net_devi
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


