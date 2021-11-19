Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9CB4577BB
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 21:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhKSUc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 15:32:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhKSUc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 15:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D08761108;
        Fri, 19 Nov 2021 20:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637353796;
        bh=ToeTFTsoG8RQjmG78bJhuXqP6zSZHWT6qNk31D0MUoU=;
        h=From:To:Cc:Subject:Date:From;
        b=HY0Wc0K3QU2jjN81tsHd7ofj+cn8CV/0zrvORkAufQty7mgSC5HNLx5jH2utPuyqK
         h1AgZo9MEqDHOPlWQ4Fk0NHudI/ZO67jSVP+0ZeIFY+fvBCdSYLjWyRy/3B4J9/DkO
         XEldKjW38qyT8TNQiscbakt71vNHJxNaH4jXrGOtkyPEmStyMR0rWKSAUgLM4QwtyN
         LdaKPCNa4n2T77M0QvxBUu9/5/gk0tS2+tvGwNEQKWIQ7Y2XWFX59lkdTzkO2qJ8vL
         YbZzsrmxYctOuMNtFhv7qmdcxG/UIR7+AwJQMTL+7ixA1Lb1hDlG+lhL309Lm5rjfA
         ak/Iv7GH6QuSw==
From:   Stefano Stabellini <sstabellini@kernel.org>
To:     jgross@suse.com
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, sstabellini@kernel.org,
        jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] xen: detect uninitialized xenbus in xenbus_init
Date:   Fri, 19 Nov 2021 12:29:51 -0800
Message-Id: <20211119202951.403525-1-sstabellini@kernel.org>
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
Changes in v2:
- add check for ULLONG_MAX (unitialized)
- add check for ULONG_MAX #if BITS_PER_LONG == 32 (actual error)
- add pr_err error message

 drivers/xen/xenbus/xenbus_probe.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 94405bb3829e..c7472ff27a93 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -951,6 +951,20 @@ static int __init xenbus_init(void)
 		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
 		if (err)
 			goto out_error;
+		/* Uninitialized. */
+		if (v == 0 || v == ULLONG_MAX) {
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

