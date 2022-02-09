Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DDC4AFD26
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiBITRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:17:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiBITRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:17:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5429C1DF8FA;
        Wed,  9 Feb 2022 11:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0D476197E;
        Wed,  9 Feb 2022 19:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FCBC340E7;
        Wed,  9 Feb 2022 19:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434127;
        bh=hZXirXigZI9GoouC6CuizAWFEKIWwDBONOJmuuybl44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zD7HvA67XcD6Pv/zPupBR46gMPD6dD8oDgOcrPypFNeO2HV0q0VWlumjboeihKeR0
         6X70NCgLkWMoq4ZtsgIgVxFRz0s1hzQxBPO4DFkJKoTUqnHFzAwbJxqsU3LSAJFItc
         bRjUoKxtpvi7/CGplVFYh6r6meB/eLqW2f0BxdHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 5.10 2/3] KVM: s390: Return error on SIDA memop on normal guest
Date:   Wed,  9 Feb 2022 20:14:20 +0100
Message-Id: <20220209191248.973709059@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
References: <20220209191248.892853405@linuxfoundation.org>
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
@@ -4654,6 +4654,8 @@ static long kvm_s390_guest_sida_op(struc
 		return -EINVAL;
 	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
 		return -E2BIG;
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:


