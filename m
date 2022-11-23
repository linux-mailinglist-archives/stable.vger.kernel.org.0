Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF06356F4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbiKWJfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbiKWJe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:34:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3CA5F8D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6617961B71
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53313C433D7;
        Wed, 23 Nov 2022 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195946;
        bh=fJ0lPZa0ylFVhACa79Ytd26siB75fd7+pfkuz5h4/NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f005kb4DPck8A8BCg7PqeoTJO+vDRk4vUEO7BLfiIF6LnIzenUm9LFpeCW3pc3i28
         xxNswP2kUAOFX5x/cch1Vbs7BdkSlq0waVnWTyLeZXnWTCBg/MG5HIVVvjQ/VET3Ut
         LbRLiXIcbMTh8h5d0hc6hdHC5u5ceqWER7VCuOfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liao Chang <liaochang1@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/181] MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed
Date:   Wed, 23 Nov 2022 09:50:40 +0100
Message-Id: <20221123084605.681210545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit fa706927f4722a2df723b2a28d139b1904a3e7fa ]

Add WARN_ON on kexec related kmalloc failed, avoid to pass NULL pointer
to following memcpy and loongson_kexec_prepare.

Fixes: 6ce48897ce47 ("MIPS: Loongson64: Add kexec/kdump support")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/reset.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/loongson64/reset.c b/arch/mips/loongson64/reset.c
index 758d5d26aaaa..e420800043b0 100644
--- a/arch/mips/loongson64/reset.c
+++ b/arch/mips/loongson64/reset.c
@@ -16,6 +16,7 @@
 #include <asm/bootinfo.h>
 #include <asm/idle.h>
 #include <asm/reboot.h>
+#include <asm/bug.h>
 
 #include <loongson.h>
 #include <boot_param.h>
@@ -159,8 +160,17 @@ static int __init mips_reboot_setup(void)
 
 #ifdef CONFIG_KEXEC
 	kexec_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_argv))
+		return -ENOMEM;
+
 	kdump_argv = kmalloc(KEXEC_ARGV_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kdump_argv))
+		return -ENOMEM;
+
 	kexec_envp = kmalloc(KEXEC_ENVP_SIZE, GFP_KERNEL);
+	if (WARN_ON(!kexec_envp))
+		return -ENOMEM;
+
 	fw_arg1 = KEXEC_ARGV_ADDR;
 	memcpy(kexec_envp, (void *)fw_arg2, KEXEC_ENVP_SIZE);
 
-- 
2.35.1



