Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00033B758
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhCOOAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhCON7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF9764F33;
        Mon, 15 Mar 2021 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816731;
        bh=FAEVE6XHouPTJcwLoC8YlshzinAWao+eLhloMA++pAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWr8Jt3laxSuakzOUHLQIloDTAT1SVcJ13keNROp0K8ayxZ/SgQSxKWps9liEHKqL
         Jjc+aeCfBSFTSJr9ubBdH/J9Cgee4OkYCTHq9JELu7Xg8F9bPUEtw5P3a4v7Eqvq57
         OcKlOwMpeBsnlPQpnN5wzWuLgBtEroePRSPd3qAg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.19 033/120] s390/cio: return -EFAULT if copy_to_user() fails again
Date:   Mon, 15 Mar 2021 14:56:24 +0100
Message-Id: <20210315135721.076757562@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wang Qing <wangqing@vivo.com>

commit 51c44babdc19aaf882e1213325a0ba291573308f upstream.

The copy_to_user() function returns the number of bytes remaining to be
copied, but we want to return -EFAULT if the copy doesn't complete.

Fixes: e01bcdd61320 ("vfio: ccw: realize VFIO_DEVICE_GET_REGION_INFO ioctl")
Signed-off-by: Wang Qing <wangqing@vivo.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/1614600093-13992-1-git-send-email-wangqing@vivo.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -341,7 +341,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struc
 		if (ret)
 			return ret;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
 	case VFIO_DEVICE_GET_REGION_INFO:
 	{
@@ -362,7 +362,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struc
 		if (ret)
 			return ret;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
 	case VFIO_DEVICE_GET_IRQ_INFO:
 	{


