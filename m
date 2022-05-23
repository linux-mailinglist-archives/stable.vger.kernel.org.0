Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D255312BE
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiEWNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 09:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236627AbiEWNsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 09:48:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E6D393D4
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:48:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c22so13751783pgu.2
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=salIVG6IU1qO9+Y2xD9JoQLL+B4NFrGXD3mN+nXjp6E=;
        b=oFPM4DhGRE/vDZh9kUxFwf5sVj228P5sFocqNMUThvt9WA0afPeAc/CBM9bPoAIGgC
         ieZhrcflD6+KFNGw3qWI2j06pE0olE53FMfSbaNRHl+amEJuAYuEP3Ef+EHn8AAZkJfu
         lJJ3irDJOvnX6hfeAITGhsBkJ7zwE7PQjSULBrU5Kx1lunxUCFTC00JOVsN/cKdABZjy
         Gxb5ndf9d88GiiwkSzCteNmM4yYJi3GnuQQekoD5/mngZFhAbNBvjn69396k3U0lc0kD
         /AqOLbje8cztPaWaIMtOpzTutgYMds9H1NO428n8y8iUXmWUqVMG3boulgXWvPa4TDPX
         0ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=salIVG6IU1qO9+Y2xD9JoQLL+B4NFrGXD3mN+nXjp6E=;
        b=JYY8VfOgDTGuGOcNV3MyehAmHALysOU/ObL7ngE9qk12v8iwoktbEz8Xa6Ix73Yk7w
         o8HTkNTcEUok690k7Mu1/FCGWFm+vrRG3UckN88ichJCeMMOAGNgl33HtxLpssx7PH3t
         02KRJjjDcGZQCK0XquuFssh6z2CMWcZsrNiL0oY1FowpOeVIxTJu+jKwvn7b1GDheY5Y
         1NPTnOkqRr7HgYbmH4oUwoOL7+5EDbFysdb0aijVs40OxXmm/rTsfA4BY6bAty8ew9JZ
         I+cwEoXRnfGsVdw7IBYwCHU0idIJmKw7j3xXJHV9kqIchWGO3ChXXiTvZZ3w4LnB76V2
         L61A==
X-Gm-Message-State: AOAM533NTijf63yBhaV8iawXjm95m231qJBXWFyX2myCc2EKelKbfQmU
        SGB/S24JCOVIcNch64ghSj2t6wAm6E0FRBkO
X-Google-Smtp-Source: ABdhPJwHqtr5Z4GpH4c0B9EVEw46ccDNIxl1uMDtXZxAYYjSpPMSjWJGrvbbm00t8vodSLInV/WlUg==
X-Received: by 2002:a63:1163:0:b0:3fa:5e1c:f86f with SMTP id 35-20020a631163000000b003fa5e1cf86fmr3971282pgr.543.1653313719436;
        Mon, 23 May 2022 06:48:39 -0700 (PDT)
Received: from f34-buildvm.eng.vmware.com ([66.170.99.2])
        by smtp.googlemail.com with ESMTPSA id u11-20020a17090a6a8b00b001ded49491basm10491546pjj.2.2022.05.23.06.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 06:48:38 -0700 (PDT)
From:   Shreenidhi Shedi <yesshedi@gmail.com>
To:     srivatsa@csail.mit.edu, amakhalov@vmware.com
Cc:     linux-kernel-review@vmware.com, yesshedi@gmail.com,
        stable@vger.kernel.org, Shreenidhi Shedi <sshedi@vmware.com>
Subject: [PATCH v3] x86/vmware: use unsigned integer for shifting
Date:   Mon, 23 May 2022 19:18:20 +0530
Message-Id: <20220523134820.744830-1-yesshedi@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shreenidhi Shedi <sshedi@vmware.com>

Shifting signed 32-bit value by 31 bits is implementation-defined
behaviour. Using unsigned is better option for this.

Fixes: 4cca6ea04d31 ("x86/apic: Allow x2apic without IR on VMware platform")
Cc: stable@vger.kernel.org
Signed-off-by: Shreenidhi Shedi <sshedi@vmware.com>
---
 arch/x86/kernel/cpu/vmware.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index c04b933f48d3..25a4366dc5e3 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/reboot.h>
 #include <linux/static_call.h>
+#include <linux/bits.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
@@ -476,8 +477,8 @@ static bool __init vmware_legacy_x2apic_available(void)
 {
 	uint32_t eax, ebx, ecx, edx;
 	VMWARE_CMD(GETVCPU_INFO, eax, ebx, ecx, edx);
-	return (eax & (1 << VMWARE_CMD_VCPU_RESERVED)) == 0 &&
-	       (eax & (1 << VMWARE_CMD_LEGACY_X2APIC)) != 0;
+	return !(eax & BIT(VMWARE_CMD_VCPU_RESERVED)) &&
+		(eax & BIT(VMWARE_CMD_LEGACY_X2APIC));
 }

 #ifdef CONFIG_AMD_MEM_ENCRYPT
--
2.36.1

