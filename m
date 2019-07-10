Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1764935
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfGJPDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbfGJPDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EBBB21537;
        Wed, 10 Jul 2019 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770991;
        bh=dmapSBUedn56N9Tupt3bHzW6V4y7Yij7aY/sxyhGbiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RH1yL1mezV1jL8luutItMPy4KsCGOvekCEn1BqZQYerGw42nGKUg6Nb8dmShqTIVM
         rSeNRu6IRKcZfALp1WtJtAg5sEsmiQcOs/GfbmUB9RJcXZUDyORMzq6lBEVhXT08Ku
         5GbFIwTPD2EW0JDrmmieRSxygVwqqFNZ3H6vSvGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/9] KVM: x86: degrade WARN to pr_warn_ratelimited
Date:   Wed, 10 Jul 2019 11:02:55 -0400
Message-Id: <20190710150301.7129-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150301.7129-1-sashal@kernel.org>
References: <20190710150301.7129-1-sashal@kernel.org>
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
index 7fed1d6dd1a1..cea6568667c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1447,7 +1447,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 			vcpu->arch.tsc_always_catchup = 1;
 			return 0;
 		} else {
-			WARN(1, "user requested TSC rate below hardware speed\n");
+			pr_warn_ratelimited("user requested TSC rate below hardware speed\n");
 			return -1;
 		}
 	}
@@ -1457,8 +1457,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
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

