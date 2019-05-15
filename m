Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75F01F256
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbfEOMCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729893AbfEOLND (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:13:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B66E420843;
        Wed, 15 May 2019 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918783;
        bh=xSihnVmtY+9iC4up/Mcox0MkU/6kFtZPpELlpQf8rew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQ5bsje12AlpI83pGgttJEUMQXv1M+cnTGWsnNJboVJObkjPGk2huWiarxeHl8BxU
         ra8MnTQX6bHo9+/So59XKptgFYjzs10sWxS02GMVg8wxdOpd2bxQSMuvqly1ewiCn8
         BhtUAMSZQ4yijn5SZ0bp1EB1DgAWdOfL4gUvzKnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Timur Tabi <timur@freescale.com>,
        Mihai Caraman <mihai.caraman@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 265/266] drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl
Date:   Wed, 15 May 2019 12:56:12 +0200
Message-Id: <20190515090731.981286173@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
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


