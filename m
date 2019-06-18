Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0174B4A3F6
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfFRO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50516 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729406AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nG-6t; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000HR-Ef; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Timur Tabi" <timur@freescale.com>,
        "Mihai Caraman" <mihai.caraman@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.893490119@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/10] drivers/virt/fsl_hypervisor.c: prevent integer
 overflow in ioctl
In-Reply-To: <lsq.1560868079.359853905@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.69-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/virt/fsl_hypervisor.c | 3 +++
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

