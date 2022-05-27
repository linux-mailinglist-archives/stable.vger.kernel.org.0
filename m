Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4A5366B4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiE0Rvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 13:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353554AbiE0Rvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 13:51:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83DA1C92D
        for <stable@vger.kernel.org>; Fri, 27 May 2022 10:51:38 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m14-20020a17090a414e00b001df77d29587so7740921pjg.2
        for <stable@vger.kernel.org>; Fri, 27 May 2022 10:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5QFowwOZJQmkHEp2EzjttzGFfwdBQSpAUNmh7E93SI=;
        b=jFqRsFKv1nSn3ccGB2u/ZDDYhDpb/QcxvnfVbjOt72JdX/gnAp9QxdekZr6f/2NTud
         5GkqjmWsdmvWg1y54uv9okj9S0A6bY8RZsSA2bGCu1G84DwqL+GdCoPSumZMNdG1sCz2
         NVT7P3B+eVK6LYGTLoxMC7YCvBwuXhzrP6T+sVNakkCMTD0PqmdhvsZ31mK4UqE2Ms32
         YW2BEBWpgAu4p8CNA+oXrPD77pXAcOW4dgQoKF79AYWl9g8T4izZ86mBCWJdNmM4EX1I
         P/cu6hsIqvxw22mU3lS4ZvMVq9S3tu0bfWEAyEXdg+6ATHaaPLrUAM/PZoReg3nw31lH
         LvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c5QFowwOZJQmkHEp2EzjttzGFfwdBQSpAUNmh7E93SI=;
        b=r5oybZnxysQAlYubtvsR/QlJM0c7qcDRajo84Ot0krfoy+TAi2xoeNBRzfJkumg0el
         ZyZCOEVRo9gzY5R7IFyNni4D09EF357MMmx7934tF3NKvBpAEP6zlW0K3BQqaJTnQ0zc
         HmdCzph0z6kfIyjeJKxKQyHxNunRo1uMbafN8/lnvS/zQF+NUq9vSPCxjcNIizIlvLbq
         DaIiRnC6JZJljDNDGmWESnQ4KNTGQ1suarXFEm9GYSTI4E9lHN7JfKMV1lxqzJaD/VSq
         DFlgBC1Kp/IutVxJ6X/g8rqK5eWTbbncadx9djP7rEInYwN/OBZ10O9kUuOavzujtH/h
         jTEw==
X-Gm-Message-State: AOAM53072Kiux027nahDefz7DcaTLWX/dRK537xEG/+kzLDk+o1PnZzq
        4Qm9ObzGiZsXzQqO4IFZhaM=
X-Google-Smtp-Source: ABdhPJxGJoz4XhqR5bpNRxVdU7bLkrFqHbhRfMZly7oXkRigaGFf8AM+kQNGTdNGHe77UiQWt5vfng==
X-Received: by 2002:a17:90a:ba15:b0:1c6:7873:b192 with SMTP id s21-20020a17090aba1500b001c67873b192mr9660930pjr.76.1653673898138;
        Fri, 27 May 2022 10:51:38 -0700 (PDT)
Received: from f34-buildvm.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id a23-20020a170902b59700b001616c3bd5c2sm3959531pls.162.2022.05.27.10.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 10:51:37 -0700 (PDT)
From:   Shreenidhi Shedi <yesshedi@gmail.com>
X-Google-Original-From: Shreenidhi Shedi <sshedi@vmware.com>
To:     yesshedi@gmail.com
Cc:     stable@vger.kernel.org, Shreenidhi Shedi <sshedi@vmware.com>
Subject: [PATCH v3] x86/vmware: use unsigned integer for shifting
Date:   Fri, 27 May 2022 23:21:30 +0530
Message-Id: <20220527175130.915171-1-sshedi@vmware.com>
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

