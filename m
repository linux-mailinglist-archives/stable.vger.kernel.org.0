Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1C54B993
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357995AbiFNSvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358011AbiFNSum (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F59E4F46F;
        Tue, 14 Jun 2022 11:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265D1617C6;
        Tue, 14 Jun 2022 18:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FEBC3411D;
        Tue, 14 Jun 2022 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232337;
        bh=NwbFDdR/g+6S1n2EfYrR5uXDC3U6sc0OJF0Mf+8i7GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFJ+Q+7gC6KwSGHpseE1DJR+je2i5+fWNuZ8shiEJ9nb49jJX5XR4Q8mnuJ4H3L7J
         KiKbjmw0WkcQOrXlmwcPVcxsoewO2c1QpWUY4zb7VKY/tnF0TT2tor6VYGl0g809lU
         Gmj4M38ixZteJA50rGpEHgaZMqcqkQd+iYn+5TYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.18 11/11] x86/speculation/mmio: Print SMT warning
Date:   Tue, 14 Jun 2022 20:40:48 +0200
Message-Id: <20220614183723.622139878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.861582392@linuxfoundation.org>
References: <20220614183720.861582392@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 1dc6ff02c8bf77d71b9b5d11cbc9df77cfb28626 upstream

Similar to MDS and TAA, print a warning if SMT is enabled for the MMIO
Stale Data vulnerability.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1258,6 +1258,7 @@ static void update_mds_branch_idle(void)
 
 #define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"
 #define TAA_MSG_SMT "TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more details.\n"
+#define MMIO_MSG_SMT "MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.\n"
 
 void cpu_bugs_smt_update(void)
 {
@@ -1302,6 +1303,16 @@ void cpu_bugs_smt_update(void)
 		break;
 	}
 
+	switch (mmio_mitigation) {
+	case MMIO_MITIGATION_VERW:
+	case MMIO_MITIGATION_UCODE_NEEDED:
+		if (sched_smt_active())
+			pr_warn_once(MMIO_MSG_SMT);
+		break;
+	case MMIO_MITIGATION_OFF:
+		break;
+	}
+
 	mutex_unlock(&spec_ctrl_mutex);
 }
 


