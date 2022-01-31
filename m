Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1DE4A44E9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiAaLe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379125AbiAaL3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819E1C0617AA;
        Mon, 31 Jan 2022 03:20:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CB5AB82A5F;
        Mon, 31 Jan 2022 11:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47144C340E8;
        Mon, 31 Jan 2022 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627999;
        bh=MoQMBgxEJWUXQ7oCFxZt/uAgqFPZTohGcRMNCzkJWQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvoGvZ12QvM6dDlbdxZ5E2LLNyDwOgFlXKpiGwrQUQgw+CAvk7JkXsQmZl3Hn6BQ/
         AB2B2Vg23zIPJTNDLjWaQ20kC7ztNphtqn70Q/WU7/IoQ+uB9SXFk0/Jhh5o5F1y/R
         +kGCi2CT9DfJcWtO9t9lUxaXij0JJ2jVltCPGNGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.16 091/200] x86/MCE/AMD: Allow thresholding interface updates after init
Date:   Mon, 31 Jan 2022 11:55:54 +0100
Message-Id: <20220131105236.675046425@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 1f52b0aba6fd37653416375cb8a1ca673acf8d5f upstream.

Changes to the AMD Thresholding sysfs code prevents sysfs writes from
updating the underlying registers once CPU init is completed, i.e.
"threshold_banks" is set.

Allow the registers to be updated if the thresholding interface is
already initialized or if in the init path. Use the "set_lvt_off" value
to indicate if running in the init path, since this value is only set
during init.

Fixes: a037f3ca0ea0 ("x86/mce/amd: Make threshold bank setting hotplug robust")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220117161328.19148-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -401,7 +401,7 @@ static void threshold_restart_bank(void
 	u32 hi, lo;
 
 	/* sysfs write might race against an offline operation */
-	if (this_cpu_read(threshold_banks))
+	if (!this_cpu_read(threshold_banks) && !tr->set_lvt_off)
 		return;
 
 	rdmsr(tr->b->address, lo, hi);


