Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA794FD21C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242096AbiDLHKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352140AbiDLHEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5040D46B37;
        Mon, 11 Apr 2022 23:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3F76103A;
        Tue, 12 Apr 2022 06:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3704BC385A6;
        Tue, 12 Apr 2022 06:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746063;
        bh=GPMcE/Z5TPn8lD0AfTRMCJGO/tcYseOLuUzJh3fgWPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHuWzAhJvtVUejlAeCWhcVp4oEMkeSWMA+u6qK5KNN0yH1ou9Ns4CDCKG5y6RBzah
         v27VNCYqjskC7zfddBSHtZ/WGB0grJnp+ZrmtzovyjOMyT8cPk/Cp6Hsjjb2tnKtkm
         Q+kYG7feYsfZiS4m29g00uD2xvIcHPHdC4arZD9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/277] Drivers: hv: vmbus: Fix potential crash on module unload
Date:   Tue, 12 Apr 2022 08:29:11 +0200
Message-Id: <20220412062946.319702271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 792f232d57ff28bbd5f9c4abe0466b23d5879dc8 ]

The vmbus driver relies on the panic notifier infrastructure to perform
some operations when a panic event is detected. Since vmbus can be built
as module, it is required that the driver handles both registering and
unregistering such panic notifier callback.

After commit 74347a99e73a ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
though, the panic notifier registration is done unconditionally in the module
initialization routine whereas the unregistering procedure is conditionally
guarded and executes only if HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE capability
is set.

This patch fixes that by unconditionally unregistering the panic notifier
in the module's exit routine as well.

Fixes: 74347a99e73a ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220315203535.682306-1-gpiccoli@igalia.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 44bd0b6ff505..a939ca1a8d54 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2776,10 +2776,15 @@ static void __exit vmbus_exit(void)
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		kmsg_dump_unregister(&hv_kmsg_dumper);
 		unregister_die_notifier(&hyperv_die_block);
-		atomic_notifier_chain_unregister(&panic_notifier_list,
-						 &hyperv_panic_block);
 	}
 
+	/*
+	 * The panic notifier is always registered, hence we should
+	 * also unconditionally unregister it here as well.
+	 */
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &hyperv_panic_block);
+
 	free_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
 	hv_ctl_table_hdr = NULL;
-- 
2.35.1



