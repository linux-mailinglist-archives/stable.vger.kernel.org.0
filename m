Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF764D5D14
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 09:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiCKIOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 03:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiCKIOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 03:14:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58C7A9A5F
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 00:13:47 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z15so7269018pfe.7
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 00:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uf03VKBh1/17RnB2PyIvsmN/uXb9NGcbASVIKPzR+Kg=;
        b=YT6vH8Pw7mZNLjmoc9y5+cGlkwT7/KOTIn5tKA6iSSkIEzOuqxVe8RJpHUqQrhuxx6
         COn747JH+B3evj8okGmse5R2nvZZLcfj5XsGuHEZ7NFKoWHsgk0xvyqCP3gv6Y6H4l3E
         oOdQlLUqMZQlxfrdCbQi2OQkHfH3NqcBH4MKsYaEwa+jMio631pH/nkdB9gb185kD8AC
         EDfI+Mtv7iJ7Tr3pqfDCefCDclt1LYbFiJhoRQrLcVE1yxgEb0iPTM8rRlWnMhULUAKA
         /xVrLuh1TESm7TOqmpmG22dlY/xR6NtjrYh2qkBgILjD+a8t3PLafmyQv0ugcoHOEGNm
         DdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uf03VKBh1/17RnB2PyIvsmN/uXb9NGcbASVIKPzR+Kg=;
        b=MKVxVZYa/vsRJ7nICv4ytn1SazcPIsEPpbUAksJ9CxZochK7Quha4e34UCYCHxb23i
         E+KDFCyqleIRP+rZ4iD03SC9bTKmWIv8+qudVVUURt9s6rekFdBvrp9sNPLmoTTEjEcD
         0pfGfS74dFQ91McFOHxfgR4G0B1VdNSsNTMNjg1nkpiMhrlO9+9cLsZJBfiVx23YfeSa
         qKTMn51SPOvby2SwObgcbhhKbBdYA7nne5IjqpoUtT0lk7uM+fq5dS6XmdYf5I69Ea/X
         ttJ2LTu56jIJPTxwqNDz0ffjGhKbL9weIf2n9xPoFcvthqwye7omNlwmiYkm/Qs2ApbW
         oXOQ==
X-Gm-Message-State: AOAM533o2V1WXtYzpqcYLLsA0lvQsrS70O7FkxrQvnSQTEkMo+u6A/Kw
        /QBdIBN0jPeJ86s6Ji1y4/8=
X-Google-Smtp-Source: ABdhPJxpyHSi1yfPAVfwLnTB7Pt/VyWCJ3HrAlgj0fVP0eyv1dkKy+hRLjsyUgfZWf7VUl2pOYbuKg==
X-Received: by 2002:a63:68c8:0:b0:380:3fbd:2ec9 with SMTP id d191-20020a6368c8000000b003803fbd2ec9mr7400607pgc.608.1646986427111;
        Fri, 11 Mar 2022 00:13:47 -0800 (PST)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:8500:5f14:bd71:fea:c430:7b0a])
        by smtp.gmail.com with ESMTPSA id a2-20020a056a000c8200b004f7203ae8dasm9880852pfv.29.2022.03.11.00.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 00:13:46 -0800 (PST)
From:   Andrei Vagin <avagin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Andrei Vagin <avagin@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15] KVM: x86/mmu: kvm_faultin_pfn has to return false if pfh is returned
Date:   Fri, 11 Mar 2022 00:13:33 -0800
Message-Id: <20220311081333.3855-1-avagin@gmail.com>
X-Mailer: git-send-email 2.35.1
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

[ Upstream commit a7cc099f2ec3117678adeb69749bef7e9dde3148 ]

This looks like a typo in 8f32d5e563cb. This change didn't intend to do
any functional changes.

The problem was caught by gVisor tests.

Fixes: 8f32d5e563cb ("KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Message-Id: <20211015163221.472508-1-avagin@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2297dd90fe4a..d6579bae25ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3967,6 +3967,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
 				    write, writable, hva);
+	return false;
 
 out_retry:
 	*r = RET_PF_RETRY;
-- 
2.35.1

