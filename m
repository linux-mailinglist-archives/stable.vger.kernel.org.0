Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71754B92A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357048AbiFNSmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357039AbiFNSls (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:41:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F24A90D;
        Tue, 14 Jun 2022 11:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC6B9B8186A;
        Tue, 14 Jun 2022 18:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE315C3411B;
        Tue, 14 Jun 2022 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232089;
        bh=xwd8s0NcWWmmlf0T2SyWUX1VuDno50o8PJA1UhCikjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzM1SqU4RQvNFLL2ebRzg6mdy2eEcLIDP+3RDcfUVkSxn84U7/ILcruNqtvLX7dtp
         EGvJdkMKjQrrE7NhSRs7WBcaDJKbsEFrVgeJQuYB18fc6F3ZaW2Cnrtj6rhKf9H0Ke
         bxVuL68vTyRbbMwwR2epRyCDJqKXB3vHD5Vj2+l8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 20/20] x86/speculation/mmio: Print SMT warning
Date:   Tue, 14 Jun 2022 20:40:03 +0200
Message-Id: <20220614183726.901907101@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 1dc6ff02c8bf77d71b9b5d11cbc9df77cfb28626 upstream

Similar to MDS and TAA, print a warning if SMT is enabled for the MMIO
Stale Data vulnerability.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1214,6 +1214,7 @@ static void update_mds_branch_idle(void)
 
 #define MDS_MSG_SMT "MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.\n"
 #define TAA_MSG_SMT "TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more details.\n"
+#define MMIO_MSG_SMT "MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.\n"
 
 void arch_smt_update(void)
 {
@@ -1258,6 +1259,16 @@ void arch_smt_update(void)
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
 


