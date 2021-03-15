Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1601033B7D8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhCOOB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCON7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A194064F89;
        Mon, 15 Mar 2021 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816766;
        bh=kY7wvwDY27JgY2WpONw5dHySYUelk1Go1Y73wFurTWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CT+Sncje2/Dz6Rh9KBYrVCBqL9Aj6dSvUp3TqOybLPXjkqflVC4xFYTPpszY8smxc
         ZypUPt1gVZ8kWsLyYTJ8jt6kwv0IVEDQ8w/awKgsAnb3+iTIMMsLyidW6shZ5L4TJG
         RXPGFEfHg8AiBrPl+96N2dprieMUomgw8WzyRh0o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.11 112/306] s390/cio: return -EFAULT if copy_to_user() fails
Date:   Mon, 15 Mar 2021 14:52:55 +0100
Message-Id: <20210315135511.429976894@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
@@ -582,7 +582,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struc
 		if (info.count == -1)
 			return -EINVAL;
 
-		return copy_to_user((void __user *)arg, &info, minsz);
+		return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 	}
 	case VFIO_DEVICE_SET_IRQS:
 	{


