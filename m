Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCCD321668
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhBVMWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhBVMSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:18:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4129064F0B;
        Mon, 22 Feb 2021 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996268;
        bh=S8915CbhBsjillSZqACQXA5HZhtddyAJ4OH+gnStirk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eP2kBvZxI8EFTPri2Qv5auOJzr+vEh6ajTEMUQijloBuMRyfPkSKoprRryMXVkxU
         RyrktVoQtRF7W4I2XaCP4F8jWxaJcT56yJCGpgD6GOcy7FvQjT5yQVzcJSBoZT3E2P
         yf8089wlgXckSHkO7ylyb2qriX1a6b27+XLXUnj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/50] KVM: SEV: fix double locking due to incorrect backport
Date:   Mon, 22 Feb 2021 13:13:29 +0100
Message-Id: <20210222121026.451759010@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Fix an incorrect line in the 5.4.y and 4.19.y backports of commit
19a23da53932bc ("Fix unsynchronized access to sev members through
svm_register_enc_region"), first applied to 5.4.98 and 4.19.176.

Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
Reported-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # 5.4.x
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b34d11f22213f..8cb9277aa6ff2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7097,7 +7097,6 @@ static int svm_register_enc_region(struct kvm *kvm,
 	region->uaddr = range->addr;
 	region->size = range->size;
 
-	mutex_lock(&kvm->lock);
 	list_add_tail(&region->list, &sev->regions_list);
 	mutex_unlock(&kvm->lock);
 
-- 
2.27.0



