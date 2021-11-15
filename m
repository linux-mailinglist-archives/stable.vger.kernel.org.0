Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A0B451153
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbhKOTEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243419AbhKOTA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB546632FA;
        Mon, 15 Nov 2021 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000051;
        bh=/A8UUi9gIgtJyekcrxEmk2W0fgEVgkaZLrTGsXxbZEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUgP0thpjvVmc1DczK6BA8R/o38da/5oPTSnBl38q5hiLx3V1httY0r3FkucCIBsb
         EcRbmDl5s0xeDrkMsUgf42ITrcnbFVHcNRgkefTBiYqESOo4nzVcJ4WYJzWQG4vegM
         V0D/DVFtkJsYN2Hbmqs9UDBQl+dRGaapuApjwh1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 519/849] KVM: s390: Fix handle_sske page fault handling
Date:   Mon, 15 Nov 2021 18:00:02 +0100
Message-Id: <20211115165437.831703374@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 9928f785c6773..12dcf97571082 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -397,6 +397,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		mmap_read_unlock(current->mm);
 		if (rc == -EFAULT)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		if (rc == -EAGAIN)
+			continue;
 		if (rc < 0)
 			return rc;
 		start += PAGE_SIZE;
-- 
2.33.0



