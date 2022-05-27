Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4BA5366C9
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 19:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbiE0R5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 13:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbiE0R5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 13:57:45 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C861E5044C;
        Fri, 27 May 2022 10:57:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n10so5214742pjh.5;
        Fri, 27 May 2022 10:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5QFowwOZJQmkHEp2EzjttzGFfwdBQSpAUNmh7E93SI=;
        b=fHm7TFJ4g/dP9hNS1doPpoMon9EyokDJ7EgXIpneOiB+O/7BscHvKG8nzXcTBGf/4a
         ll5l0n1Ev1EAa6FRIopSWJR8B9HLiRsCeNIlAxLUjp701hAPft8xgjYXwof4uhbKHNrx
         CdimHHhAquLgf6I2r68ijBczd4xNL+Opf1xcAvBllW+ruJZHq6N76CaspwW3mbTjUyQc
         9BJe9UA3SCIsrjC3Axb+dyHDq35iQdq8VUvz7+nGscLwd8PH0DgtHiaZmNvpfRiXppZ7
         pu4tuHB+GDYVjQTr+jC3EXwzF7dj9iNlX8cnpenTFfrIS+ZgvqFltCAdxAOgVwniQPhn
         GTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5QFowwOZJQmkHEp2EzjttzGFfwdBQSpAUNmh7E93SI=;
        b=4fy10v+zJZxLin3rMc9a4k97JOo2iy4oOsBj9KHvRe1eyyiLHZ5ouXSwVea1EXbNi8
         mqwlZF+863IhnW+KVJbKTyO7j1v2lR3x+56PwlMlgTpPDxoLUaMH9O+KCHzu8UFHxYlf
         zG99j/NkNv+zfO0KDzymUCPySLCVnYVZRysbJRgz4qtlNcn0Kip3+j3PLowVmREoftc8
         tHAmKUFHwVcXAJ7d5/fNrkbqsFQUiBkjzul0ZkhjylvbLc3zImxLMOzfiusl0pv0sRbp
         1oZO7+Yb27/29Y2PltUjInuPgtfWznc+flWiRsGNrqtHD065R7DqbOfu+pIVYuqUcjws
         tGPw==
X-Gm-Message-State: AOAM533cFikTaEBZ3JeM6WyK6yiC2CGLNTF36v4X4NLsXNW3b5qTGX73
        iI+p3uZjn3J7xRFbxVuolwQ=
X-Google-Smtp-Source: ABdhPJwdud74IhEwCnCm2GpVwX5cKHpOXGXwDkM4SjvD5+chTcQarv0embQkFjRPc+d8qqzNMZBM/g==
X-Received: by 2002:a17:902:e809:b0:163:9baf:1fbc with SMTP id u9-20020a170902e80900b001639baf1fbcmr3519201plg.54.1653674262311;
        Fri, 27 May 2022 10:57:42 -0700 (PDT)
Received: from f34-buildvm.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y63-20020a638a42000000b003fadfd7be5asm3680740pgd.18.2022.05.27.10.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 10:57:41 -0700 (PDT)
From:   Shreenidhi Shedi <yesshedi@gmail.com>
X-Google-Original-From: Shreenidhi Shedi <sshedi@vmware.com>
To:     srivatsa@csail.mit.edu, amakhalov@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com
Cc:     virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, yesshedi@gmail.com,
        stable@vger.kernel.org, Shreenidhi Shedi <sshedi@vmware.com>
Subject: [PATCH v3] x86/vmware: use unsigned integer for shifting
Date:   Fri, 27 May 2022 23:27:37 +0530
Message-Id: <20220527175737.915284-1-sshedi@vmware.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 arch/x86/kernel/cpu/vmware.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index c04b933f4..02039ec35 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -476,8 +476,8 @@ static bool __init vmware_legacy_x2apic_available(void)
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

