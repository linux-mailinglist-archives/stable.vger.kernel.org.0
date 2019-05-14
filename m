Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA661E54B
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 00:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfENWrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 18:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfENWrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 18:47:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141CD20644;
        Tue, 14 May 2019 22:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557874024;
        bh=bsYkileagRGTkTUzkLu+KXz5X5Ro1lrwWEy2sUMLRTw=;
        h=Date:From:To:Subject:From;
        b=xSZNaRcZihp3B1IZGMgynYX2fbHcmWwhrXJxF3FqmurWATfPA9ig6TY0Mfj2KaKKV
         CIH+oATDeizNqBDAegvEAtgMwd5h0u4tzVd6BnBvfzNMl28ksdJ5OyEr2kisvAN9Xp
         dsRqHuPOazMe4FPCCfjTEDsQrVPiaLwhA4Bzb2xw=
Date:   Tue, 14 May 2019 15:47:03 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        galak@kernel.crashing.org, mihai.caraman@freescale.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        timur@freescale.com, torvalds@linux-foundation.org
Subject:  [patch 122/126] drivers/virt/fsl_hypervisor.c: prevent
 integer overflow in ioctl
Message-ID: <20190514224703.Hm3SdHBTn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

The "param.count" value is a u64 thatcomes from the user.  The code later
in the function assumes that param.count is at least one and if it's not
then it leads to an Oops when we dereference the ZERO_SIZE_PTR.

Also the addition can have an integer overflow which would lead us to
allocate a smaller "pages" array than required.  I can't immediately tell
what the possible run times implications are, but it's safest to prevent
the overflow.

Link: http://lkml.kernel.org/r/20181218082129.GE32567@kadam
Fixes: 6db7199407ca ("drivers/virt: introduce Freescale hypervisor management driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Timur Tabi <timur@freescale.com>
Cc: Mihai Caraman <mihai.caraman@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virt/fsl_hypervisor.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/virt/fsl_hypervisor.c~fsl_hypervisor-prevent-integer-overflow-in-ioctl
+++ a/drivers/virt/fsl_hypervisor.c
@@ -215,6 +215,9 @@ static long ioctl_memcpy(struct fsl_hv_i
 	 * hypervisor.
 	 */
 	lb_offset = param.local_vaddr & (PAGE_SIZE - 1);
+	if (param.count == 0 ||
+	    param.count > U64_MAX - lb_offset - PAGE_SIZE + 1)
+		return -EINVAL;
 	num_pages = (param.count + lb_offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Allocate the buffers we need */
_
