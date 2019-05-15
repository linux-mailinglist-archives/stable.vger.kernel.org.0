Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C881EDFA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbfEOLPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbfEOLPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7207E20862;
        Wed, 15 May 2019 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918917;
        bh=xSihnVmtY+9iC4up/Mcox0MkU/6kFtZPpELlpQf8rew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmQU6QGfjN8OdzZy6ZZVpVdSUZrj3FLMhqlWmsD2MIETzfth8fjNn/2Js4/zdMo11
         dnttbJHiVk1qO32OpVGp9rT/9baw0GXB6lSo9LPi5PM0cxWlbmDCgN80x10XUn2sJ9
         hlgiokQ7ua2W9qGs4Y6oi6BWnc/0ALBXPrNKyW7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Timur Tabi <timur@freescale.com>,
        Mihai Caraman <mihai.caraman@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 49/51] drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl
Date:   Wed, 15 May 2019 12:56:24 +0200
Message-Id: <20190515090629.728136722@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6a024330650e24556b8a18cc654ad00cfecf6c6c upstream.

The "param.count" value is a u64 thatcomes from the user.  The code
later in the function assumes that param.count is at least one and if
it's not then it leads to an Oops when we dereference the ZERO_SIZE_PTR.

Also the addition can have an integer overflow which would lead us to
allocate a smaller "pages" array than required.  I can't immediately
tell what the possible run times implications are, but it's safest to
prevent the overflow.

Link: http://lkml.kernel.org/r/20181218082129.GE32567@kadam
Fixes: 6db7199407ca ("drivers/virt: introduce Freescale hypervisor management driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mihai Caraman <mihai.caraman@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virt/fsl_hypervisor.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -215,6 +215,9 @@ static long ioctl_memcpy(struct fsl_hv_i
 	 * hypervisor.
 	 */
 	lb_offset = param.local_vaddr & (PAGE_SIZE - 1);
+	if (param.count == 0 ||
+	    param.count > U64_MAX - lb_offset - PAGE_SIZE + 1)
+		return -EINVAL;
 	num_pages = (param.count + lb_offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Allocate the buffers we need */


