Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F1C3A03E5
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhFHTWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238799AbhFHTUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B41D61477;
        Tue,  8 Jun 2021 18:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178348;
        bh=aEDxG6h29ivDTypq5aoukTCRXsGpyc6ZjU+N2yJn6Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRZh3X13O175tBWps/jDGyeZgsgswnrSh6QR6LB4AMadXRdq6rbo1uiONywe0MjI8
         OmS05qcJ9JCSYQYJW9u+i6XKyDqqQAGgvXPgnLxIxUiboUGU3SoMmK+O3nFVq+qtF1
         D7wQGcv7bVTfZVZaLO94bROhSNFiWfNDs9Gkg9d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.12 155/161] KVM: arm64: Resolve all pending PC updates before immediate exit
Date:   Tue,  8 Jun 2021 20:28:05 +0200
Message-Id: <20210608175950.700983250@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit e3e880bb1518eb10a4b4bb4344ed614d6856f190 upstream.

Commit 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
returning to userspace") fixed the PC updating issue by forcing an explicit
synchronisation of the exception state on vcpu exit to userspace.

However, we forgot to take into account the case where immediate_exit is
set by userspace and KVM_RUN will exit immediately. Fix it by resolving all
pending PC updates before returning to userspace.

Since __kvm_adjust_pc() relies on a loaded vcpu context, I moved the
immediate_exit checking right after vcpu_load(). We will get some overhead
if immediate_exit is true (which should hopefully be rare).

Fixes: 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before returning to userspace")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210526141831.1662-1-yuzenghui@huawei.com
Cc: stable@vger.kernel.org # 5.11
[yuz: stable-5.12.y backport]
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -715,11 +715,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 			return ret;
 	}
 
-	if (run->immediate_exit)
-		return -EINTR;
-
 	vcpu_load(vcpu);
 
+	if (run->immediate_exit) {
+		ret = -EINTR;
+		goto out;
+	}
+
 	kvm_sigset_activate(vcpu);
 
 	ret = 1;
@@ -892,6 +894,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 
 	kvm_sigset_deactivate(vcpu);
 
+out:
 	/*
 	 * In the unlikely event that we are returning to userspace
 	 * with pending exceptions or PC adjustment, commit these


