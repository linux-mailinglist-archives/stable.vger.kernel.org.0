Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C643469B4A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356032AbhLFPOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346797AbhLFPMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEC0C08C5F1;
        Mon,  6 Dec 2021 07:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E71D6132D;
        Mon,  6 Dec 2021 15:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134A8C341C2;
        Mon,  6 Dec 2021 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803146;
        bh=5Aqowb9gV7qkwSZXNmtBCfXW9/hoDKZ0Ip/3lamcXO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq/b+6MJjxWYCu1klTWi7BrN98ru3t5/pyRIzPElFWvivyqbHsmUa+dYbHOT79BGS
         JFq9348G3+v9cYWsEP3j57oSP+l7tZdN6L62abaiokK5kqEdJu2ppxXZLAAB+CBapy
         +KaT/d1tIAGBYisznKFrYBkJHZplpa1VRhLgsjTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 012/106] xen: detect uninitialized xenbus in xenbus_init
Date:   Mon,  6 Dec 2021 15:55:20 +0100
Message-Id: <20211206145555.813490239@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
@@ -878,6 +878,29 @@ static int __init xenbus_init(void)
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


