Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8284C95F5
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiCAUSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiCAUR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:17:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD017ED87;
        Tue,  1 Mar 2022 12:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F7761718;
        Tue,  1 Mar 2022 20:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65035C340EE;
        Tue,  1 Mar 2022 20:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165819;
        bh=eq80Nvoud4uFSN/cBnnpuZbATzFNxwDc8gYn/gxfBqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWU05+UUltubaLFReUIIDFJPbv5QyJhv4mmwzlyG12GZxsLmjeDZ1f105UK0KUGKE
         rYXkYBgiusWziLqt5sW1k8MeE5HHRoAjbK7PkRd3mVBy5dpPzSjsnz7KInFHOlWWC8
         jvFQrwlpRqbTQTq4AO1JfU3x3BiZ2zXCVwrNN+12R0J4UfC8DwFd48FyNr8vn/XKAZ
         TrE8lzvWEizFiX22yOap27hfL4PfMkMwoNh5qL40q/t6yw+ky823bjMgMItn6ht2F9
         n00ic3RD5nVJiYlg2JollTsbXVWw/O/ckO+Cy3CDXVD0HCMX+CIPnM9SeFtsBQszlm
         5BOSDaafWfYMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Romanov <romanton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/23] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in always catchup mode
Date:   Tue,  1 Mar 2022 15:16:05 -0500
Message-Id: <20220301201629.18547-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 33cb065181248..c804122bb6e3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8657,6 +8657,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
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

