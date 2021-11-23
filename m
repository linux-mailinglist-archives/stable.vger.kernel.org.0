Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7A45A86E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhKWQlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238906AbhKWQkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FF460FE3;
        Tue, 23 Nov 2021 16:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685452;
        bh=WKFuSZs7TvQ0plzPL1JN89aERWNX28JCoIhsqX/IAsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3KT4T8tnR974WoHzuy2bHlzjCpEsapfz7sJCAaS+8zROOIUWM6qRtSmEYVhfWpkE
         A50asATh3Oy8u2HRuSlt0XUZjCY7jLgslklX6IP3vhMaCf3XC9Hr/57YIpSAuI6+gL
         WB78/Sya/HKRPEhp4r58htskH4/m32GNtDIMsY5NyhWulRyD9ZQvjJMgcba41G6/vy
         GFidxjsBbxVErNLU0Hox3BGKiJrRxBKLCbppkzS5rtUkKDVE+i+GIJ1pZb02CfOuLP
         JOdGEmduIRNuuSRzIuVyO7s/w4Ibiq4ZiG5ftyG9RtVJ1mEmILCqpMwJ/SCevUlVpG
         8l+lEMEwga+mA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 4.14 3/3] KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:24 -0500
Message-Id: <20211123163725.289694-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163725.289694-1-sashal@kernel.org>
References: <20211123163725.289694-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 57a2e13ebdda8b65602b44ec8b80e385603eb84c ]

It doesn't make sense to return the recommended maximum number of
vCPUs which exceeds the maximum possible number of vCPUs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kvm/mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8614225e92eb5..8733585385dee 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1075,7 +1075,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.0

