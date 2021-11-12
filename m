Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7E44EED5
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 22:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhKLVuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 16:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235698AbhKLVuE (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 12 Nov 2021 16:50:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1EC60EFD;
        Fri, 12 Nov 2021 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636753633;
        bh=f0st7MUDC/rGEPGAzPZrpsNr1ug4HHv2pbX+/641YvE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z+RkjC+OWbEEAvRu5fd8dDZnWrQyUO0OTfr2nbtJCOpy+rlFxhfO5IwA0hUi4vbwb
         G+c3QwUx5ZtClmzJSd+U25P1HGv9fwChWyY/2ggywgYKD8NvqfdGD3RAQdR+jlWh8B
         ez+ntl459C52GTIchiJUN9lNQ71UX4mcpiq4lrzDIdF6iKfjC+KYq+cYa34LiGHF9+
         VrotP+SK7TmgFNfJg36H3/6uSi8WDu6YX0kGPQPMseTzd9mZ5Ha1hA8HHIXeec+hct
         PFMnk4bfVR8Uv+twH5nGQDfqOEUJkjxazWLlDxTTyNuKMQpLCKUOWy+CxEeNv2x7nP
         SAswvbUHwFH1w==
From:   Stefano Stabellini <sstabellini@kernel.org>
To:     jgross@suse.com
Cc:     boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, sstabellini@kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org
Subject: [PATCH] xen: don't continue xenstore initialization in case of errors
Date:   Fri, 12 Nov 2021 13:47:09 -0800
Message-Id: <20211112214709.1763928-1-sstabellini@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@xilinx.com>

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
Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
---
 drivers/xen/xenbus/xenbus_probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index bd003ca8acbe..34abf2b5967b 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -983,8 +983,10 @@ static int __init xenbus_init(void)
 	 */
 	proc_create_mount_point("xen");
 #endif
+	return err;
 
 out_error:
+	xen_store_domain_type = XS_UNKNOWN;
 	return err;
 }
 
-- 
2.25.1

