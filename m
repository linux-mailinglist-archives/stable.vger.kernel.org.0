Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569B746276D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhK2XFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237021AbhK2XFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118DEC12BCF2;
        Mon, 29 Nov 2021 10:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A127CE140F;
        Mon, 29 Nov 2021 18:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31380C53FAD;
        Mon, 29 Nov 2021 18:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210904;
        bh=8LnzY09KZVvmzi9kRjajDGVg99sEx/Ijz82zLWHNd3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcfqCjhTa6AweH/cRlagzWRw+eJI3mMpZT/D6q1nk8cOuX6qylZ79idJqayts3mYz
         EWqs4bPsK6Br7KU/6KnW7Wjg2hYBQhdDAN9hI4CY0Ko4lKgY0Dc0qqUfVnOcIQpFWP
         38H46HregdOIbCfxnjtqB9cpXy3O7pQkdCVn+5UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org, jbeulich@suse.com,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.15 036/179] xen: dont continue xenstore initialization in case of errors
Date:   Mon, 29 Nov 2021 19:17:10 +0100
Message-Id: <20211129181720.144236572@linuxfoundation.org>
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
@@ -909,7 +909,7 @@ static struct notifier_block xenbus_resu
 
 static int __init xenbus_init(void)
 {
-	int err = 0;
+	int err;
 	uint64_t v = 0;
 	xen_store_domain_type = XS_UNKNOWN;
 
@@ -983,8 +983,10 @@ static int __init xenbus_init(void)
 	 */
 	proc_create_mount_point("xen");
 #endif
+	return 0;
 
 out_error:
+	xen_store_domain_type = XS_UNKNOWN;
 	return err;
 }
 


