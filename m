Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F050469ADA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348119AbhLFPLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42130 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347667AbhLFPJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:09:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2203B8114D;
        Mon,  6 Dec 2021 15:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34875C341C2;
        Mon,  6 Dec 2021 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803143;
        bh=IsZ/1Qu10PR7ml21IEfwjA5yxLPQpxYylW1mkHE0ctQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kixpzJJBqUXHXGVxcDAtPH6qFQRGHzdUX2Nz2yPEyH8IRFwen89g5q5SSkiIB9G1K
         LwQo4mp+LX1FckPsbjIgTe/s5XWR3/Eh7OZJINicZ53bRiI1yFzGPWvGXCk2wxIERH
         km6jKFjlFszhdTg2z2N+hCdsMYb8t4iM6NfJaQhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org, jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 011/106] xen: dont continue xenstore initialization in case of errors
Date:   Mon,  6 Dec 2021 15:55:19 +0100
Message-Id: <20211206145555.782529990@linuxfoundation.org>
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

commit 08f6c2b09ebd4b326dbe96d13f94fee8f9814c78 upstream.

In case of errors in xenbus_init (e.g. missing xen_store_gfn parameter),
we goto out_error but we forget to reset xen_store_domain_type to
XS_UNKNOWN. As a consequence xenbus_probe_initcall and other initcalls
will still try to initialize xenstore resulting into a crash at boot.

[    2.479830] Call trace:
[    2.482314]  xb_init_comms+0x18/0x150
[    2.486354]  xs_init+0x34/0x138
[    2.489786]  xenbus_probe+0x4c/0x70
[    2.498432]  xenbus_probe_initcall+0x2c/0x7c
[    2.503944]  do_one_initcall+0x54/0x1b8
[    2.507358]  kernel_init_freeable+0x1ac/0x210
[    2.511617]  kernel_init+0x28/0x130
[    2.516112]  ret_from_fork+0x10/0x20

Cc: <Stable@vger.kernel.org>
Cc: jbeulich@suse.com
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
Link: https://lore.kernel.org/r/20211115222719.2558207-1-sstabellini@kernel.org
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xenbus/xenbus_probe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -838,7 +838,7 @@ static struct notifier_block xenbus_resu
 
 static int __init xenbus_init(void)
 {
-	int err = 0;
+	int err;
 	uint64_t v = 0;
 	xen_store_domain_type = XS_UNKNOWN;
 
@@ -912,8 +912,10 @@ static int __init xenbus_init(void)
 	 */
 	proc_create_mount_point("xen");
 #endif
+	return 0;
 
 out_error:
+	xen_store_domain_type = XS_UNKNOWN;
 	return err;
 }
 


