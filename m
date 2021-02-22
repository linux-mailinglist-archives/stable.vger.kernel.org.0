Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75494321608
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhBVMQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ED3C64EDB;
        Mon, 22 Feb 2021 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996122;
        bh=lFXH9yD4FLpqSZmobFWj8tNlzTUfEw3WmYS6LT7yVMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzkgumbZUmNGgtcyHRiJFEglbps07TmkUDEwRJzEvGOQ/ivGhBP7tWw/83KWWcLH1
         zuiU0SyOQBDRI3zbJ8jFF9GSVhaXd6K7XkXDcWFZL67vCiQoZ8ImyFzguyOG3ptdhI
         /JG0vCzAc4g6tGeDW12AxaPE2vyWeXY3MViEwTfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/13] KVM: SEV: fix double locking due to incorrect backport
Date:   Mon, 22 Feb 2021 13:13:18 +0100
Message-Id: <20210222121016.859927439@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index 296b0d7570d06..1da558f28aa57 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7104,7 +7104,6 @@ static int svm_register_enc_region(struct kvm *kvm,
 	region->uaddr = range->addr;
 	region->size = range->size;
 
-	mutex_lock(&kvm->lock);
 	list_add_tail(&region->list, &sev->regions_list);
 	mutex_unlock(&kvm->lock);
 
-- 
2.27.0



