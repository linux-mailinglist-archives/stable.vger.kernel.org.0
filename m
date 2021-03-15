Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F65433B75D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCOOAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232603AbhCON7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D70A364DAD;
        Mon, 15 Mar 2021 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816736;
        bh=hD1F8VjWGCUZ++i9TL2oRH1ZOXXmngzERZal1ulIcoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H29GaNgsWm0cS8qWnmyJyY3m3BGTmSD3lLRqYQ5szwYg7P+7lMDCWTAuGtOPF8b0H
         B3myglPQe3IjIsUQnJHIIv+9EzNhymupsNPc924ADJC4FVsp6OO/Ze+NwceT6uw4sR
         R2/gQMnD6gLWrbbLJNWC1Cz8OftxYWcQpgxxxFIs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.19 036/120] s390/cio: return -EFAULT if copy_to_user() fails
Date:   Mon, 15 Mar 2021 14:56:27 +0100
Message-Id: <20210315135721.177953936@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit d9c48a948d29bcb22f4fe61a81b718ef6de561a0 upstream.

Fixes: 120e214e504f ("vfio: ccw: realize VFIO_DEVICE_G(S)ET_IRQ_INFO ioctls")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -383,7 +383,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struc
 		if (info.count == -1)
 			return -EINVAL;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
 	case VFIO_DEVICE_SET_IRQS:
 	{


