Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0945843A2FF
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhJYTzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237340AbhJYTwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5699A6113E;
        Mon, 25 Oct 2021 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191031;
        bh=Fakm2LNz3isYtSaSCUdlCrJmZFgluWjBbJuA0mEu4I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1ggvizT3wb8f8bHrkdL74q0KivRmuRlI4vw18Af611w02Cv5U21IUfxKpduipJp3
         uzvAyDam9GnXw3JjhRYqrB696KIKkYwB8dxzmZ0y5EYbz+rkP4jzIHf2g4v0lJFRyY
         qkQafqDVLUCTvQQqP33fxFA8E9PuRQP9zuUEgI4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 109/169] KVM: SEV-ES: fix length of string I/O
Date:   Mon, 25 Oct 2021 21:14:50 +0200
Message-Id: <20211025191031.878969762@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 019057bd73d1751fdfec41e43148baf3303d98f9 upstream.

The size of the data in the scratch buffer is not divided by the size of
each port I/O operation, so vcpu->arch.pio.count ends up being larger
than it should be by a factor of size.

Cc: stable@vger.kernel.org
Fixes: 7ed9abfe8e9f ("KVM: SVM: Support string IO operations for an SEV-ES guest")
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2591,7 +2591,7 @@ int sev_es_string_io(struct vcpu_svm *sv
 		return -EINVAL;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port,
-				    svm->ghcb_sa, svm->ghcb_sa_len, in);
+				    svm->ghcb_sa, svm->ghcb_sa_len / size, in);
 }
 
 void sev_es_init_vmcb(struct vcpu_svm *svm)


