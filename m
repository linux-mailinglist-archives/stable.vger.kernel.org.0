Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5784AFD57
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiBIT1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:27:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiBIT0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35611C002B5D;
        Wed,  9 Feb 2022 11:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EECB5B82395;
        Wed,  9 Feb 2022 19:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF6C340E7;
        Wed,  9 Feb 2022 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434141;
        bh=1Wm1gNghXMtZ7I8Snz5L3JEYpfnmU2oBw40ORPRvRyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHopcZdqrNI9H71eMtHLhjV7KRqW3H7KwOYqWc0gbSeWLpRM2xgYIYC5NQm8C7o7F
         uSHRtcpal2jd4rk+COx6zXjNbyB1rdB09qREBZemF4otsO9zMu4iUo/ZqVcl2HzIoT
         4vegbczwUEEmPVPV9gnBQIjRxPCkH5IEOHl9vEyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 5.15 3/5] KVM: s390: Return error on SIDA memop on normal guest
Date:   Wed,  9 Feb 2022 20:14:28 +0100
Message-Id: <20220209191250.100205353@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
References: <20220209191249.980911721@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

commit 2c212e1baedcd782b2535a3f86bc491977677c0e upstream.

Refuse SIDA memops on guests which are not protected.
For normal guests, the secure instruction data address designation,
which determines the location we access, is not under control of KVM.

Fixes: 19e122776886 (KVM: S390: protvirt: Introduce instruction data area bounce buffer)
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4708,6 +4708,8 @@ static long kvm_s390_guest_sida_op(struc
 		return -EINVAL;
 	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
 		return -E2BIG;
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:


