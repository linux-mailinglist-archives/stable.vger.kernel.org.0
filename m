Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE6345C049
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345813AbhKXNGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345473AbhKXNEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:04:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A622C61A03;
        Wed, 24 Nov 2021 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757432;
        bh=rMin8QwGPoFWvsDczyBLPvIlUBGaWsbPgd+IINFcfUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jW0H5YzFAyms9T7B2wma6X3eUaQq4lHqQ/svkBlxhLj2UEDvHsYK9lOkZ+TaFZj75
         tLV+tnHzv9rTiFlE44DKC7Eks4nx8iN9oln8HTRrD0djKWmXgXnv/hIOShpIfrHITk
         fxH2f4O/ea85iLT6fsMSGg61CKMbzyHZ+XVKwe8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/323] KVM: s390: Fix handle_sske page fault handling
Date:   Wed, 24 Nov 2021 12:55:57 +0100
Message-Id: <20211124115724.586990370@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

[ Upstream commit 85f517b29418158d3e6e90c3f0fc01b306d2f1a1 ]

If handle_sske cannot set the storage key, because there is no
page table entry or no present large page entry, it calls
fixup_user_fault.
However, currently, if the call succeeds, handle_sske returns
-EAGAIN, without having set the storage key.
Instead, retry by continue'ing the loop without incrementing the
address.
The same issue in handle_pfmf was fixed by
a11bdb1a6b78 ("KVM: s390: Fix pfmf and conditional skey emulation").

Fixes: bd096f644319 ("KVM: s390: Add skey emulation fault handling")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211022152648.26536-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/priv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 8679bd74d337a..9abdfb8b1a1ea 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -397,6 +397,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		up_read(&current->mm->mmap_sem);
 		if (rc == -EFAULT)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		if (rc == -EAGAIN)
+			continue;
 		if (rc < 0)
 			return rc;
 		start += PAGE_SIZE;
-- 
2.33.0



