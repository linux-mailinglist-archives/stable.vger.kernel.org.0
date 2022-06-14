Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CADC54B9BC
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357916AbiFNSuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357912AbiFNStN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3D4EA05;
        Tue, 14 Jun 2022 11:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1949B8186A;
        Tue, 14 Jun 2022 18:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED1EC3411E;
        Tue, 14 Jun 2022 18:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232315;
        bh=4dZ2MEnL8HgaaqOyInfP+Rk/J1TNbvELIOhbpPpmJSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlKHO5xV3PCXSP8mqR+KHD+WuKZ/3BXCBFkM3sqzP6oStMLTS+SCzCQeRtdxIifoO
         S88txZbefCK5pddwH5+2pnaUDw9Yi8Ww8mbN6UkykooJ4S0rbrOO+trKVNmLHzZ85D
         VqYw/RGLbIpRA6Q/PLz7gb4Ovmth4ZaVDasHxbfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 05/11] x86/bugs: Group MDS, TAA & Processor MMIO Stale Data mitigations
Date:   Tue, 14 Jun 2022 20:40:34 +0200
Message-Id: <20220614183721.798479670@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
References: <20220614183720.512073672@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit e5925fb867290ee924fcf2fe3ca887b792714366 upstream

MDS, TAA and Processor MMIO Stale Data mitigations rely on clearing CPU
buffers. Moreover, status of these mitigations affects each other.
During boot, it is important to maintain the order in which these
mitigations are selected. This is especially true for
md_clear_update_mitigation() that needs to be called after MDS, TAA and
Processor MMIO Stale Data mitigation selection is done.

Introduce md_clear_select_mitigation(), and select all these mitigations
from there. This reflects relationships between these mitigations and
ensures proper ordering.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -42,6 +42,7 @@ static void __init ssb_select_mitigation
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
 static void __init md_clear_update_mitigation(void);
+static void __init md_clear_select_mitigation(void);
 static void __init taa_select_mitigation(void);
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
@@ -122,19 +123,10 @@ void __init check_bugs(void)
 	spectre_v2_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
-	mds_select_mitigation();
-	taa_select_mitigation();
-	mmio_select_mitigation();
+	md_clear_select_mitigation();
 	srbds_select_mitigation();
 	l1d_flush_select_mitigation();
 
-	/*
-	 * As MDS, TAA and MMIO Stale Data mitigations are inter-related, update
-	 * and print their mitigation after MDS, TAA and MMIO Stale Data
-	 * mitigation selection is done.
-	 */
-	md_clear_update_mitigation();
-
 	arch_smt_update();
 
 #ifdef CONFIG_X86_32
@@ -520,6 +512,20 @@ out:
 		pr_info("MMIO Stale Data: %s\n", mmio_strings[mmio_mitigation]);
 }
 
+static void __init md_clear_select_mitigation(void)
+{
+	mds_select_mitigation();
+	taa_select_mitigation();
+	mmio_select_mitigation();
+
+	/*
+	 * As MDS, TAA and MMIO Stale Data mitigations are inter-related, update
+	 * and print their mitigation after MDS, TAA and MMIO Stale Data
+	 * mitigation selection is done.
+	 */
+	md_clear_update_mitigation();
+}
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SRBDS: " fmt
 


