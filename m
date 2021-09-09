Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DFA405DFF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 22:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344885AbhIIU3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 16:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345157AbhIIU3L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 16:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D826054F;
        Thu,  9 Sep 2021 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631219281;
        bh=rTFp4sgpdGfmAa244GhAk8h9gFwRy658c13xb9ZAUd4=;
        h=Date:From:To:Subject:From;
        b=tD0T/cnMLFHEBae1QGk6s+nGZdgthzHI3PybzLz31cUYu9KnrcwovuUo0eydkjXdo
         LhrIa4tR3rorcnElk54lhYEfy8dRLBKbIg+JQ48pUVFCRT2rQzFv6vNSK95tq9K85V
         dy86mhRKEuzdyk09CBa3eUX/L4Rv9rMQcYO04LuQ=
Date:   Thu, 09 Sep 2021 13:28:00 -0700
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, gustavoars@kernel.org, ira.weiny@intel.com,
        jhubbard@nvidia.com, jingxiangfeng@huawei.com,
        jrdr.linux@gmail.com, keescook@chromium.org, lkp@intel.com,
        mm-commits@vger.kernel.org, mporter@kernel.crashing.org,
        stable@vger.kernel.org
Subject:  + rapidio-avoid-bogus-__alloc_size-warning.patch added to
 -mm tree
Message-ID: <20210909202800.Jkz8_SpHE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: rapidio: avoid bogus __alloc_size warning
has been added to the -mm tree.  Its filename is
     rapidio-avoid-bogus-__alloc_size-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/rapidio-avoid-bogus-__alloc_size-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/rapidio-avoid-bogus-__alloc_size-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: rapidio: avoid bogus __alloc_size warning

GCC 9.3 (but not later) incorrectly evaluates the arguments to
check_copy_size(), getting seemingly confused by the size being returned
from array_size().  Instead, perform the calculation once, which both
makes the code more readable and avoids the bug in GCC.

   In file included from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:55,
                    from include/linux/mm_types.h:9,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from drivers/rapidio/devices/rio_mport_cdev.c:13:
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:191:6,
       inlined from 'rio_mport_transfer_ioctl' at drivers/rapidio/devices/rio_mport_cdev.c:983:6:
   include/linux/thread_info.h:213:4: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
     213 |    __bad_copy_to();
         |    ^~~~~~~~~~~~~~~

But the allocation size and the copy size are identical:

	transfer = vmalloc(array_size(sizeof(*transfer), transaction.count));
	if (!transfer)
		return -ENOMEM;

	if (unlikely(copy_from_user(transfer,
				    (void __user *)(uintptr_t)transaction.block,
				    array_size(sizeof(*transfer), transaction.count)))) {

Link: https://lkml.kernel.org/r/20210909161409.2250920-1-keescook@chromium.org
Link: https://lore.kernel.org/linux-mm/202109091134.FHnRmRxu-lkp@intel.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-avoid-bogus-__alloc_size-warning
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -965,6 +965,7 @@ static int rio_mport_transfer_ioctl(stru
 	struct rio_transfer_io *transfer;
 	enum dma_data_direction dir;
 	int i, ret = 0;
+	size_t size;
 
 	if (unlikely(copy_from_user(&transaction, arg, sizeof(transaction))))
 		return -EFAULT;
@@ -976,13 +977,14 @@ static int rio_mport_transfer_ioctl(stru
 	     priv->md->properties.transfer_mode) == 0)
 		return -ENODEV;
 
-	transfer = vmalloc(array_size(sizeof(*transfer), transaction.count));
+	size = array_size(sizeof(*transfer), transaction.count);
+	transfer = vmalloc(size);
 	if (!transfer)
 		return -ENOMEM;
 
 	if (unlikely(copy_from_user(transfer,
 				    (void __user *)(uintptr_t)transaction.block,
-				    array_size(sizeof(*transfer), transaction.count)))) {
+				    size))) {
 		ret = -EFAULT;
 		goto out_free;
 	}
@@ -994,8 +996,7 @@ static int rio_mport_transfer_ioctl(stru
 			transaction.sync, dir, &transfer[i]);
 
 	if (unlikely(copy_to_user((void __user *)(uintptr_t)transaction.block,
-				  transfer,
-				  array_size(sizeof(*transfer), transaction.count))))
+				  transfer, size)))
 		ret = -EFAULT;
 
 out_free:
_

Patches currently in -mm which might be from keescook@chromium.org are

rapidio-avoid-bogus-__alloc_size-warning.patch

