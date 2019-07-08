Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA0622E2
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389585AbfGHPaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfGHPaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE4F20645;
        Mon,  8 Jul 2019 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599801;
        bh=h/g+fnyqelDIBef6lZ+o2cuNEp5nnEToVRY3PLkrDnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wXTDn/4x8odbEdu1cd0cOqflBHrt9PsRD/Ivu2nOdhTHYCxXHKtKQc3g6IDW3MR6
         DLnujIMJUJZY2OEOqTuYIr9LysO+69eBb5g9LQrnBMMz+YVl6yjpTV2oJFLUdBbs4B
         02Z5DbtdtI7VPpkD5xSqXU5OmyGimblljI3w5pgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 82/90] KVM: x86: degrade WARN to pr_warn_ratelimited
Date:   Mon,  8 Jul 2019 17:13:49 +0200
Message-Id: <20190708150526.553674137@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3f16a5c318392cbb5a0c7a3d19dff8c8ef3c38ee upstream.

This warning can be triggered easily by userspace, so it should certainly not
cause a panic if panic_on_warn is set.

Reported-by: syzbot+c03f30b4f4c46bdf8575@syzkaller.appspotmail.com
Suggested-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1447,7 +1447,7 @@ static int set_tsc_khz(struct kvm_vcpu *
 			vcpu->arch.tsc_always_catchup = 1;
 			return 0;
 		} else {
-			WARN(1, "user requested TSC rate below hardware speed\n");
+			pr_warn_ratelimited("user requested TSC rate below hardware speed\n");
 			return -1;
 		}
 	}
@@ -1457,8 +1457,8 @@ static int set_tsc_khz(struct kvm_vcpu *
 				user_tsc_khz, tsc_khz);
 
 	if (ratio == 0 || ratio >= kvm_max_tsc_scaling_ratio) {
-		WARN_ONCE(1, "Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
-			  user_tsc_khz);
+		pr_warn_ratelimited("Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
+			            user_tsc_khz);
 		return -1;
 	}
 


