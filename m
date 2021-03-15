Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607C133B7C1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhCOOBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47D6D64EE9;
        Mon, 15 Mar 2021 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816760;
        bh=xVDg8VjN42L2Ig5tSO0pvjt4DrZnFJa1TMsmotPfxJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1APIE74G0G965bzThHvRPHIaUGYQS6bvNs7DYkOZYzA0lqliodD6xtxC5VGI4/o1
         EvhQvu2V4NGKMgll3zhtaZM69OASc6PRsGtJ9PbAIyjrk4s+gyYrJkVaC1iMqBTOkW
         kK6rkatVoDkFgWrpwaESBgkWl8vLGMwroQOSYUno=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 098/290] s390/cio: return -EFAULT if copy_to_user() fails
Date:   Mon, 15 Mar 2021 14:53:11 +0100
Message-Id: <20210315135545.236925038@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
@@ -578,7 +578,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struc
 		if (info.count == -1)
 			return -EINVAL;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
 	case VFIO_DEVICE_SET_IRQS:
 	{


