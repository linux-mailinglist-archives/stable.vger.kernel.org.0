Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E64513E9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348741AbhKOT7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344120AbhKOTX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738C463628;
        Mon, 15 Nov 2021 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002341;
        bh=kcIgI3I56zoz/vcWGl/lSsKaLxkYb43a1hPCNXb7ESM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjQJpAF7MtsVoVBLTeUuOH245Yw48scefnPpOAXWXhnQO/rch4tDGZER9t+2yWEKh
         xznaQsETOD7le/oz6Fbzh841ziIVLaA1lttq3LvgPqXxrTvyBEmiyqkcXXpxKLCusi
         mnM+DjlvYEPCVqx0C07XYUdLkbXDB1DwNciU8WqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/917] KVM: s390: Fix handle_sske page fault handling
Date:   Mon, 15 Nov 2021 18:00:25 +0100
Message-Id: <20211115165446.733898134@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 53da4ceb16a3a..417154b314a64 100644
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



