Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31643A30A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhJYTzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238841AbhJYTxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DC960F70;
        Mon, 25 Oct 2021 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191088;
        bh=Mhb4SjUAVdFEQRiSaW5Zizaqvfh04ebxu5QAhsq6kOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhVyCIB4k++o0vZ0ptl3LeOumwgpHWUoVX2E6q6DbKO6DUfmF2dstdTosUN1CbduV
         dNXc1GOT7KwboOwbAzfzbQYF39lN4emDnyqydRMbg7AnCeX2Pwjhp9QBJhIUnZL+Ag
         m2VmqzEcoftt9zUedm2JRrzedjFWukb+KnFw1FSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.14 124/169] KVM: MMU: Reset mmu->pkru_mask to avoid stale data
Date:   Mon, 25 Oct 2021 21:15:05 +0200
Message-Id: <20211025191033.518954123@linuxfoundation.org>
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

From: Chenyi Qiang <chenyi.qiang@intel.com>

commit a3ca5281bb771d8103ea16f0a6a8a5df9a7fb4f3 upstream.

When updating mmu->pkru_mask, the value can only be added but it isn't
reset in advance. This will make mmu->pkru_mask keep the stale data.
Fix this issue.

Fixes: 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Message-Id: <20211021071022.1140-1-chenyi.qiang@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4465,10 +4465,10 @@ static void update_pkru_bitmask(struct k
 	unsigned bit;
 	bool wp;
 
-	if (!is_cr4_pke(mmu)) {
-		mmu->pkru_mask = 0;
+	mmu->pkru_mask = 0;
+
+	if (!is_cr4_pke(mmu))
 		return;
-	}
 
 	wp = is_cr0_wp(mmu);
 


