Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655104D8337
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240893AbiCNMM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242376AbiCNMJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F39D14004;
        Mon, 14 Mar 2022 05:07:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49AF16130D;
        Mon, 14 Mar 2022 12:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D74FC340E9;
        Mon, 14 Mar 2022 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259646;
        bh=wqjYFkslxvrZjmqfbYf5nUKxy5nRUxoIo/P8qVlyWeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NEWTHpzm0GbK5U9XmID0/rdWPmSfS/25LmNXdb4+pLRwzKQtby98t/swniBVnb1z
         G5FwI8QK72zr7vXRUu+juBeRDFihe11laTbmf61NDmDgV7oIC9LnmvBTam1g6W2uGk
         HjYO/0gtIiTQbDMRgdwQvRXH7H+SsSwrX+AscbEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Romanov <romanton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/110] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode
Date:   Mon, 14 Mar 2022 12:53:59 +0100
Message-Id: <20220314112744.627462723@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Romanov <romanton@google.com>

[ Upstream commit 3a55f729240a686aa8af00af436306c0cd532522 ]

If vcpu has tsc_always_catchup set each request updates pvclock data.
KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
host's side and do hypercall inside pvclock_read_retry loop leading to
infinite loop in such situation.

v3:
    Removed warn
    Changed return code to KVM_EFAULT
v2:
    Added warn

Signed-off-by: Anton Romanov <romanton@google.com>
Message-Id: <20220216182653.506850-1-romanton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8213f7fb71a7..61bc54748f22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8666,6 +8666,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	if (clock_type != KVM_CLOCK_PAIRING_WALLCLOCK)
 		return -KVM_EOPNOTSUPP;
 
+	/*
+	 * When tsc is in permanent catchup mode guests won't be able to use
+	 * pvclock_read_retry loop to get consistent view of pvclock
+	 */
+	if (vcpu->arch.tsc_always_catchup)
+		return -KVM_EOPNOTSUPP;
+
 	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
 		return -KVM_EOPNOTSUPP;
 
-- 
2.34.1



