Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507FD11B813
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfLKPJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbfLKPJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA9F424658;
        Wed, 11 Dec 2019 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076974;
        bh=gmWCkjQVPPfidX2Tuqq9EuA+KCH/LpIU+IvlQpr4yBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukgpba1zmRgVgi+kexOs6SFCJf4AbWaNmweLNx0VDN52OT+vP2hzyqlEiufbkyyCg
         ZDpw7m9Vfmzh8IZhBhwqS5xH2JmgY5Fuy+4MA9emKOqcziX+Ib103A0MJsvWpKFhJX
         3rdkuGP9rNyDZnwOhSS+d0UVVkvxzIdtbnlw4KdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH 5.4 61/92] KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
Date:   Wed, 11 Dec 2019 16:05:52 +0100
Message-Id: <20191211150250.436265473@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit e7d71c943040c23f2fd042033d319f56e84f845b upstream.

If we cannot allocate the XIVE VPs in OPAL, the creation of a XIVE or
XICS-on-XIVE device is aborted as expected, but we leave kvm->arch.xive
set forever since the release method isn't called in this case. Any
subsequent tentative to create a XIVE or XICS-on-XIVE for this VM will
thus always fail (DoS). This is a problem for QEMU since it destroys
and re-creates these devices when the VM is reset: the VM would be
restricted to using the much slower emulated XIVE or XICS forever.

As an alternative to adding rollback, do not assign kvm->arch.xive before
making sure the XIVE VPs are allocated in OPAL.

Cc: stable@vger.kernel.org # v5.2
Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive.c        |   11 +++++------
 arch/powerpc/kvm/book3s_xive_native.c |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2005,6 +2005,10 @@ static int kvmppc_xive_create(struct kvm
 
 	pr_devel("Creating xive for partition\n");
 
+	/* Already there ? */
+	if (kvm->arch.xive)
+		return -EEXIST;
+
 	xive = kvmppc_xive_get_device(kvm, type);
 	if (!xive)
 		return -ENOMEM;
@@ -2014,12 +2018,6 @@ static int kvmppc_xive_create(struct kvm
 	xive->kvm = kvm;
 	mutex_init(&xive->lock);
 
-	/* Already there ? */
-	if (kvm->arch.xive)
-		ret = -EEXIST;
-	else
-		kvm->arch.xive = xive;
-
 	/* We use the default queue size set by the host */
 	xive->q_order = xive_native_default_eq_shift();
 	if (xive->q_order < PAGE_SHIFT)
@@ -2039,6 +2037,7 @@ static int kvmppc_xive_create(struct kvm
 	if (ret)
 		return ret;
 
+	kvm->arch.xive = xive;
 	return 0;
 }
 
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1095,7 +1095,6 @@ static int kvmppc_xive_native_create(str
 	dev->private = xive;
 	xive->dev = dev;
 	xive->kvm = kvm;
-	kvm->arch.xive = xive;
 	mutex_init(&xive->mapping_lock);
 	mutex_init(&xive->lock);
 
@@ -1116,6 +1115,7 @@ static int kvmppc_xive_native_create(str
 	if (ret)
 		return ret;
 
+	kvm->arch.xive = xive;
 	return 0;
 }
 


