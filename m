Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371EB6AF3A2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjCGTHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233514AbjCGTG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:06:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E345968F4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:52:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32562B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952A1C4339B;
        Tue,  7 Mar 2023 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215128;
        bh=4bzhCnmK1XqjWVAwFBuudtMyfviKxF03krUNw9+tjFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TywTDnxN8EePKlfzX2SKdtOrc1iYOdTBwjZhHNxQFFjqvBnx54ZQByl47p9jNXcDU
         jyPB0JIKAMLJ+EnYrIbGV1mJUfFSGItB20ewF2TjYYoHS2LUNFE8xdSEozGr5tFQsw
         p8lvpqnTHDMyESt6M2QeByvr0NMW+beFIJi0t5pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/567] x86/microcode: Adjust late loading result reporting message
Date:   Tue,  7 Mar 2023 17:57:35 +0100
Message-Id: <20230307165911.062182433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 30d1bd36934dd..7efdfc16144e5 100644
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



