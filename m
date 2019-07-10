Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0264908
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfGJPDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbfGJPD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2D9321655;
        Wed, 10 Jul 2019 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562771008;
        bh=nkIVLuUcip7zK4hli8E14iBflLln8ApaMqsmcZaY+Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3Si3QUXL0kU1qVCp/tbw7A6oKk8EyU3fFTK3xh04ytoR2l5bZElRG3DLJKcSPFV5
         ckIn8IteR/K/Fb/2KFHxZFdJ0/qOqTswFLiLqmN4vx7Ks2ZJjE2OuQZFl0f4iIfpv9
         0xAIs8XfN01hcR8rRNO7NIEBucAWLarcAOMzJoXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/8] KVM: x86: degrade WARN to pr_warn_ratelimited
Date:   Wed, 10 Jul 2019 11:03:14 -0400
Message-Id: <20190710150319.7258-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150319.7258-1-sashal@kernel.org>
References: <20190710150319.7258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 3f16a5c318392cbb5a0c7a3d19dff8c8ef3c38ee ]

This warning can be triggered easily by userspace, so it should certainly not
cause a panic if panic_on_warn is set.

Reported-by: syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com
Suggested-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 858dd0d89b02..a8526042d176 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1392,7 +1392,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 			vcpu->arch.tsc_always_catchup = 1;
 			return 0;
 		} else {
-			WARN(1, "user requested TSC rate below hardware speed\n");
+			pr_warn_ratelimited("user requested TSC rate below hardware speed\n");
 			return -1;
 		}
 	}
@@ -1402,8 +1402,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 				user_tsc_khz, tsc_khz);
 
 	if (ratio == 0 || ratio >= kvm_max_tsc_scaling_ratio) {
-		WARN_ONCE(1, "Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
-			  user_tsc_khz);
+		pr_warn_ratelimited("Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
+			            user_tsc_khz);
 		return -1;
 	}
 
-- 
2.20.1

