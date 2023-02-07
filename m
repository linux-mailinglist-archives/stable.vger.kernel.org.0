Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67768DE97
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 18:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjBGROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 12:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjBGROu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 12:14:50 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9FA3E0BB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:14:00 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id e9-20020a62ee09000000b0058db55a8d7aso4728212pfi.21
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 09:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gaqlkUHlROHo1Iu/mvu/VhOVerpPZOfXGd0nbt/7zs8=;
        b=aFSF+mDkwXMPhNXoGe9Q/j26WS0JRqyy750UYsBMIHe2uxsn5RTNKfWiXtceSvhxa5
         jtE+wKy5v7XDg0HNBzSH2kcs5k0RPiVdlmiHEigKt+L/Dx/GRZ95cfV/8haSHCcm6e/6
         OybLUuEDpssvqVROntd3VOoMTRGRn3FgHA9N+aXExjoJwgShq1wHpm1S9S4NV9pWuTKE
         i5zm3mZuh6Ca6I6q+iuYH0CnU3MAA2KomIjb8tuhX7oH1H7M0Apn3rrYCm++euStY1AV
         PNE0SoqrGOrbbcoQEfj7ugB8nDtisZYJRPB0h5jKDccuxm6DHEpGAQlJRqPlDIfjEJLR
         nlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gaqlkUHlROHo1Iu/mvu/VhOVerpPZOfXGd0nbt/7zs8=;
        b=R1qJMgbFTto0CkgZtTP2gQUq5ad657yKhoiy4KsQLJawAl6yzyr92I0ro+38sXDVXY
         bbjXmmGUBweCD4i4T8nqQMw0oWlfGd7uZpP1wN0i7Jx6JXXGq3ZAjwTToUa1/eaMT6wt
         LAnyrpppSm19Ee+ZHLjstkyr6ykqImnEbhgj1rhMGoV6c4TGYtsF1I9ukEQaxuW0Gnbk
         M4nQc/x+GNgZFyPjJAwIYBCbgsbZ6h034FXBtlFP02LnUre+gpxIrLpCpQf/ime09R10
         vKAc1Vb4Wvdt8JfLubuSYR/aYjaK+s/RdOuQZRAkpnUUmK63NL1pOQlMTMeJCH0EE/k4
         AdeQ==
X-Gm-Message-State: AO0yUKVWv8F3JYe1G83PkMzabbH0KA59Bjqeo4ay5swDkbKerHPFttMB
        stw8kHb2Pv2tWOH38Amjd2876vj7IG4=
X-Google-Smtp-Source: AK7set+er4Uv/iKukfLeR1lCffkTft0lTR8HoB29ISgFrwHdoSYSqGHr9L2MtrFudzW2cCM4F0rt08AXC9k=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:346e:6fd8:c3bf:b38f])
 (user=pgonda job=sendgmr) by 2002:a17:902:a3ce:b0:196:3672:f24b with SMTP id
 q14-20020a170902a3ce00b001963672f24bmr868930plb.32.1675790039532; Tue, 07 Feb
 2023 09:13:59 -0800 (PST)
Date:   Tue,  7 Feb 2023 09:13:54 -0800
Message-Id: <20230207171354.4012821-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Subject: [PATCH V2] KVM: sev: Fix potential overflow send|recieve_update_data
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Andy Nguyen <theflow@google.com>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KVM_SEV_SEND_UPDATE_DATA and KVM_SEV_RECEIVE_UPDATE_DATA have an integer
overflow issue. Params.guest_len and offset are both 32bite wide, with a
large params.guest_len the check to confirm a page boundary is not
crossed can falsely pass:

    /* Check if we are crossing the page boundary *
    offset = params.guest_uaddr & (PAGE_SIZE - 1);
    if ((params.guest_len + offset > PAGE_SIZE))

Add an additional check to this conditional to confirm that
params.guest_len itself is not greater than PAGE_SIZE.

The current code is can only overflow with a params.guest_len of greater
than 0xfffff000. And the FW spec says these commands fail with lengths
greater than 16KB. So this issue should not be a security concern

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

V2
 * Updated conditional based on feedback from Tom.

---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 273cba809328..3d74facaead8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1294,7 +1294,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	/* Pin guest memory */
@@ -1474,7 +1474,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
-- 
2.39.1.519.gcb327c4b5f-goog

