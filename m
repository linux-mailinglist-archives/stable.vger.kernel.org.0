Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799F461ED1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380045AbhK2Skf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:40:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42810 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380180AbhK2Si2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:38:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA17B815C9;
        Mon, 29 Nov 2021 18:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194A8C53FCD;
        Mon, 29 Nov 2021 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210907;
        bh=AQjg/kHeSF3J2tiRTwgAxJ8YmSJdRTKatlFPY0fZ/F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJCLv9bgWXxarjkbNbJvmyuRMZCAWqGnkiN78Pc/XmEqMr0AnH3AJ038PsM/lkA0z
         OgiWpbAq6LTPRN7FIxk5kG3edUTY7MX21lFOerPR2tetzBoq/l7RD8Y3gQ3UZdpBB2
         E0HXq1xk6tsKogLnyAQMnZbYAeW38CJ29pVB+mWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.15 037/179] xen: detect uninitialized xenbus in xenbus_init
Date:   Mon, 29 Nov 2021 19:17:11 +0100
Message-Id: <20211129181720.184336445@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@xilinx.com>

commit 36e8f60f0867d3b70d398d653c17108459a04efe upstream.

If the xenstore page hasn't been allocated properly, reading the value
of the related hvm_param (HVM_PARAM_STORE_PFN) won't actually return
error. Instead, it will succeed and return zero. Instead of attempting
to xen_remap a bad guest physical address, detect this condition and
return early.

Note that although a guest physical address of zero for
HVM_PARAM_STORE_PFN is theoretically possible, it is not a good choice
and zero has never been validly used in that capacity.

Also recognize all bits set as an invalid value.

For 32-bit Linux, any pfn above ULONG_MAX would get truncated. Pfns
above ULONG_MAX should never be passed by the Xen tools to HVM guests
anyway, so check for this condition and return early.

Cc: stable@vger.kernel.org
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Link: https://lore.kernel.org/r/20211123210748.1910236-1-sstabellini@kernel.org
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_probe.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -949,6 +949,29 @@ static int __init xenbus_init(void)
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
+		 * Also recognize all bits set as an invalid value.
+		 */
+		if (!v || !~v) {
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


