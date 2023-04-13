Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288026E04A8
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDMCkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjDMCkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33669EE5;
        Wed, 12 Apr 2023 19:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7906F63A64;
        Thu, 13 Apr 2023 02:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96776C433D2;
        Thu, 13 Apr 2023 02:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353453;
        bh=XuH6j3tz7tJ5sPV1lAEwMCZ7xX0rapL3aIgBjKsrpKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akRJP3Nyzc0mWRdW+4x0CHfWzCsW7HWzpEv1qi/uKMEyXSYGah/J0fasX8Z/ggbdK
         OnmLiSfDlBWEcIAYONYbcejk4lVBD5UDrhvXlatu/p1khJnuNTD/8pJOoQm2OW92tj
         DQTANeTrpi+CGGQSBfnTtOVi6ycjUmMSD1SoxrQY9k/GYVJDw+OJt+ysFx5CGo7dQw
         gS6nEKIIrrfEzXzNU03KbXNQ9c4Vd3xkpdDbslmf8Ile37YBAhyJp/W7zZJ1hoQGau
         EkxzZouewn4/q4yxtkNoNYVKzTSju4Qlt3nl8rSENBA3KuJSgfnBGjy4Q56ZDPRYco
         HdjcALc6Mi6XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 3/8] x86/hyperv: Block root partition functionality in a Confidential VM
Date:   Wed, 12 Apr 2023 22:37:20 -0400
Message-Id: <20230413023727.74875-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023727.74875-1-sashal@kernel.org>
References: <20230413023727.74875-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit f8acb24aaf89fc46cd953229462ea8abe31b395f ]

Hyper-V should never specify a VM that is a Confidential VM and also
running in the root partition.  Nonetheless, explicitly block such a
combination to guard against a compromised Hyper-V maliciously trying to
exploit root partition functionality in a Confidential VM to expose
Confidential VM secrets. No known bug is being fixed, but the attack
surface for Confidential VMs on Hyper-V is reduced.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1678894453-95392-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index ba0efc30fac52..8d3c649a1769b 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -289,12 +289,16 @@ static void __init ms_hyperv_init_platform(void)
 	 * To mirror what Windows does we should extract CPU management
 	 * features and use the ReservedIdentityBit to detect if Linux is the
 	 * root partition. But that requires negotiating CPU management
-	 * interface (a process to be finalized).
+	 * interface (a process to be finalized). For now, use the privilege
+	 * flag as the indicator for running as root.
 	 *
-	 * For now, use the privilege flag as the indicator for running as
-	 * root.
+	 * Hyper-V should never specify running as root and as a Confidential
+	 * VM. But to protect against a compromised/malicious Hyper-V trying
+	 * to exploit root behavior to expose Confidential VM memory, ignore
+	 * the root partition setting if also a Confidential VM.
 	 */
-	if (cpuid_ebx(HYPERV_CPUID_FEATURES) & HV_CPU_MANAGEMENT) {
+	if ((ms_hyperv.priv_high & HV_CPU_MANAGEMENT) &&
+	    !(ms_hyperv.priv_high & HV_ISOLATION)) {
 		hv_root_partition = true;
 		pr_info("Hyper-V: running as root partition\n");
 	}
-- 
2.39.2

