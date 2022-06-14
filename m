Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C35A54B8D8
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbiFNSlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356086AbiFNSlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:41:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091AA49CAF;
        Tue, 14 Jun 2022 11:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B06D0B81AF2;
        Tue, 14 Jun 2022 18:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFC6C3411B;
        Tue, 14 Jun 2022 18:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232072;
        bh=AD6M8R0F9Ak/do8OFvGwfHxyqKd6t20kvQOZOhgHRDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VazhfC3JdblE++yuGDSB8fEc31ULBAo7fZzRjh2zx2/cjZOXOruZyMRyoJ5qpo36+
         NT5bB+dBjgGjnq7UmGfnhJ2MlUwEYZBff/hS3ByGuDyB7LNWz/4rb4Omid+VUyFm71
         0IObRPQ45p0P5KWGeEHD5VjzHAL2McIT+2gFbrK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 14/20] x86/bugs: Group MDS, TAA & Processor MMIO Stale Data mitigations
Date:   Tue, 14 Jun 2022 20:39:57 +0200
Message-Id: <20220614183725.465157330@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -40,6 +40,7 @@ static void __init ssb_select_mitigation
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
 static void __init md_clear_update_mitigation(void);
+static void __init md_clear_select_mitigation(void);
 static void __init taa_select_mitigation(void);
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
@@ -112,18 +113,9 @@ void __init check_bugs(void)
 	spectre_v2_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
-	mds_select_mitigation();
-	taa_select_mitigation();
-	mmio_select_mitigation();
+	md_clear_select_mitigation();
 	srbds_select_mitigation();
 
-	/*
-	 * As MDS, TAA and MMIO Stale Data mitigations are inter-related, update
-	 * and print their mitigation after MDS, TAA and MMIO Stale Data
-	 * mitigation selection is done.
-	 */
-	md_clear_update_mitigation();
-
 	arch_smt_update();
 
 #ifdef CONFIG_X86_32
@@ -502,6 +494,20 @@ out:
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
 


