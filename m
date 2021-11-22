Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEE345973B
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 23:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhKVWTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 17:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229484AbhKVWTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 17:19:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 222B260FE6;
        Mon, 22 Nov 2021 22:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637619388;
        bh=kRlam7odlirF8W9djazKfCVOxAEG58oHirjbOnjelJI=;
        h=From:To:Cc:Subject:Date:From;
        b=oWsu7ISreFyJ3GjFm0Fsgen+xWF1YgeB24eOx63Y8aqGqj187MQBCbgP6l5BuzgBN
         S5t2SsFvP8EBEm6Az9QyVWAwgOwrtFAMS5AEFNyE/MdDz68XaMfLY4r1UPkPNBWn0w
         5kJDqgUoJ34/fMJnL6mui6AhttQnqMUeNd0j2C2hU7YPFYXRGaBgdE8SF1QkMymafi
         U+tvXo1vIkEeU6wCKTK5ew7p3bEesfJTfzvHS6cBlynLJlhQ2eCE9jfdRM0mC4nBvy
         TZL3SjoPbv86mtVd74JzTFa6TVqhvXLGK5DPZezsynAPvkidaf1YKP1Q5wS2vEScjv
         R24zmreoizBww==
From:   Stefano Stabellini <sstabellini@kernel.org>
To:     jgross@suse.com
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, sstabellini@kernel.org,
        jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] xen: detect uninitialized xenbus in xenbus_init
Date:   Mon, 22 Nov 2021 14:16:25 -0800
Message-Id: <20211122221625.1473164-1-sstabellini@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@xilinx.com>

If the xenstore page hasn't been allocated properly, reading the value
of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
error. Instead, it will succeed and return zero. Instead of attempting
to xen_remap a bad guest physical address, detect this condition and
return early.

Note that although a guest physical address of zero for
HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
and zero has never been validly used in that capacity.

Also recognize the invalid value of INVALID_PFN which is ULLONG_MAX.

For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
above ULONG_MAX should never be passed by the Xen tools to HVM guests
anyway, so check for this condition and return early.

Cc: stable@vger.kernel.org
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
---
Changes in v3:
- improve in-code comment
- improve check

Changes in v2:
- add check for ULLONG_MAX (unitialized)
- add check for ULONG_MAX #if BITS_PER_LONG == 32 (actual error)
- add pr_err error message
---
 drivers/xen/xenbus/xenbus_probe.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 94405bb3829e..d3ca57d48a73 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -951,6 +951,30 @@ static int __init xenbus_init(void)
 		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
 		if (err)
 			goto out_error;
+		/*
+		 * Uninitialized hvm_params are zero and return no error.
+		 * Although it is theoretically possible to have
+		 * HVM_PARAM_STORE_PFN set to zero on purpose, in reality it is
+		 * not zero when valid. If zero, it means that Xenstore hasn't
+		 * been properly initialized. Instead of attempting to map a
+		 * wrong guest physical address return error.
+		 *
+		 * Also recognize the invalid value of INVALID_PFN which is
+		 * ULLONG_MAX.
+		 */
+		if (!v || !(v + 1)) {
+			err = -ENOENT;
+			goto out_error;
+		}
+		/* Avoid truncation on 32-bit. */
+#if BITS_PER_LONG == 32
+		if (v > ULONG_MAX) {
+			pr_err("%s: cannot handle HVM_PARAM_STORE_PFN=%llx > ULONG_MAX\n",
+			       __func__, v);
+			err = -EINVAL;
+			goto out_error;
+		}
+#endif
 		xen_store_gfn = (unsigned long)v;
 		xen_store_interface =
 			xen_remap(xen_store_gfn << XEN_PAGE_SHIFT,
-- 
2.25.1

