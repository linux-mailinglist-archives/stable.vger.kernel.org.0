Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C571B3E04
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgDVKXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbgDVKXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27432076B;
        Wed, 22 Apr 2020 10:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551022;
        bh=BdWMS2kMpTbgqeNC5wZ91nNso70M7SuEdSXUXsnLKoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9Kndaw34RxvdpK4/DIrU/UFuAPsMLc98XHZwlxlngdU6vrRmfZfFHTm4HtbTrvAU
         41fF0/HKRWnsy//hJOh+RKCP0nd/MqTmZDYu1d3np9u+bHJJoxohqx749Ming2VS6t
         Spp8SbOtS8kUElq1FyIkOuW0jWLvfvQCG0Zf5R9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.6 026/166] x86/Hyper-V: Free hv_panic_page when fail to register kmsg dump
Date:   Wed, 22 Apr 2020 11:55:53 +0200
Message-Id: <20200422095051.438084348@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit 7f11a2cc10a4ae3a70e2c73361f4a9a33503539b upstream.

If kmsg_dump_register() fails, hv_panic_page will not be used
anywhere.  So free and reset it.

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-3-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/vmbus_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1385,9 +1385,13 @@ static int vmbus_bus_init(void)
 			hv_panic_page = (void *)hv_alloc_hyperv_zeroed_page();
 			if (hv_panic_page) {
 				ret = kmsg_dump_register(&hv_kmsg_dumper);
-				if (ret)
+				if (ret) {
 					pr_err("Hyper-V: kmsg dump register "
 						"error 0x%x\n", ret);
+					hv_free_hyperv_page(
+					    (unsigned long)hv_panic_page);
+					hv_panic_page = NULL;
+				}
 			} else
 				pr_err("Hyper-V: panic message page memory "
 					"allocation failed");
@@ -1416,7 +1420,6 @@ err_alloc:
 	hv_remove_vmbus_irq();
 
 	bus_unregister(&hv_bus);
-	hv_free_hyperv_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
 	hv_ctl_table_hdr = NULL;
 	return ret;


