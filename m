Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209E86811A1
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbjA3OPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbjA3OPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:15:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8C41BAEC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:15:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF47D6104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C28C433D2;
        Mon, 30 Jan 2023 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088119;
        bh=erl/GSgzJcCR3Xzy6LAAt9P6QF9rBuS+rCSKlStHteU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkoDhnzQGJpRrPQcq8zVQEEVMTcmAbh41J9py4owCX1NmFLyP+eZCqgJABh9x5OuT
         AG70roT/LGw9exx6zd3u/RcHWx5mnqHqse7As5BTeei2EGSoE7kGz2OmNF0eW7uCtY
         Qp4U7n85CX2ECbs+yBeLQMnt1ZujbutSSJjHEcp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deepak Sharma <deepak.sharma@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.15 121/204] x86: ACPI: cstate: Optimize C3 entry on AMD CPUs
Date:   Mon, 30 Jan 2023 14:51:26 +0100
Message-Id: <20230130134321.813243732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepak Sharma <deepak.sharma@amd.com>

commit a8fb40966f19ff81520d9ccf8f7e2b95201368b8 upstream.

All Zen or newer CPU which support C3 shares cache. Its not necessary to
flush the caches in software before entering C3. This will cause drop in
performance for the cores which share some caches. ARB_DIS is not used
with current AMD C state implementation. So set related flags correctly.

Signed-off-by: Deepak Sharma <deepak.sharma@amd.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/cstate.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -79,6 +79,21 @@ void acpi_processor_power_init_bm_check(
 		 */
 		flags->bm_control = 0;
 	}
+	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 >= 0x17) {
+		/*
+		 * For all AMD Zen or newer CPUs that support C3, caches
+		 * should not be flushed by software while entering C3
+		 * type state. Set bm->check to 1 so that kernel doesn't
+		 * need to execute cache flush operation.
+		 */
+		flags->bm_check = 1;
+		/*
+		 * In current AMD C state implementation ARB_DIS is no longer
+		 * used. So set bm_control to zero to indicate ARB_DIS is not
+		 * required while entering C3 type state.
+		 */
+		flags->bm_control = 0;
+	}
 }
 EXPORT_SYMBOL(acpi_processor_power_init_bm_check);
 


