Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58706B47C5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjCJOyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjCJOxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:53:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DF511F61A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FC961982
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE38C4339B;
        Fri, 10 Mar 2023 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459751;
        bh=bhOYmfTYfDRziyzRN3QgOBzfYeXiSRj2eqmYo5G39YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6SKPQWuixyXpX2AkBeGJG24L96vybx71vCMD/KBVDXoYa/ocG3qKTg3iE4UpDxBl
         2iM67opTRgoVwZbs6F6JcN3iHO8dWDUSL9Cm/BAgDYGfDFV09LOXGN420vlaSl50tx
         cyYKsw7eQs+LbInvpWPS8eh6r3XuIMfPSgVQmiPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/529] x86/microcode: Adjust late loading result reporting message
Date:   Fri, 10 Mar 2023 14:34:10 +0100
Message-Id: <20230310133809.937767568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit 6eab3abac7043226e5375e9ead0c7607ced6767b ]

During late microcode loading, the "Reload completed" message is issued
unconditionally, regardless of success or failure.

Adjust the message to report the result of the update.

  [ bp: Massage. ]

Fixes: 9bd681251b7c ("x86/microcode: Announce reload operation's completion")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/lkml/874judpqqd.ffs@tglx/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 122da99bac4e4..36583bc4b88c3 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -521,11 +521,14 @@ static int microcode_reload_late(void)
 	store_cpu_caps(&prev_info);
 
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
-	if (ret == 0)
+	if (!ret) {
+		pr_info("Reload succeeded, microcode revision: 0x%x -> 0x%x\n",
+			old, boot_cpu_data.microcode);
 		microcode_check(&prev_info);
-
-	pr_info("Reload completed, microcode revision: 0x%x -> 0x%x\n",
-		old, boot_cpu_data.microcode);
+	} else {
+		pr_info("Reload failed, current microcode revision: 0x%x\n",
+			boot_cpu_data.microcode);
+	}
 
 	return ret;
 }
-- 
2.39.2



