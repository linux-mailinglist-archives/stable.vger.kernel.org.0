Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3B879721
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391056AbfG2T6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbfG2TyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C20204EC;
        Mon, 29 Jul 2019 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430041;
        bh=NUbrjwjYeXygtv84i9f7XHC8o03n9nhYjKpLang2j+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA4oiwcdUoZh4ri8MHzszB4qJrUpsqnQZnFRz8qHyfM5kE5YDXR0bwtV/MRLB5d4F
         8OzBq+C5NLLIET3+TgppgIFDSIRT7WYsxIpRvrouZO2pjRXvSKMRLgPV1bwMNQhdgS
         Caaax9YguKUKt32dtGeVE+hzF9lrBw8egOjaEVhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.2 177/215] KVM: PPC: Book3S HV: XIVE: fix rollback when kvmppc_xive_create fails
Date:   Mon, 29 Jul 2019 21:22:53 +0200
Message-Id: <20190729190810.703221068@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 9798f4ea71eaf8eaad7e688c5b298528089c7bf8 upstream.

The XIVE device structure is now allocated in kvmppc_xive_get_device()
and kfree'd in kvmppc_core_destroy_vm(). In case of an OPAL error when
allocating the XIVE VPs, the kfree() call in kvmppc_xive_*create()
will result in a double free and corrupt the host memory.

Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/6ea6998b-a890-2511-01d1-747d7621eb19@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xive.c        |    4 +---
 arch/powerpc/kvm/book3s_xive_native.c |    4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1986,10 +1986,8 @@ static int kvmppc_xive_create(struct kvm
 
 	xive->single_escalation = xive_native_has_single_escalation();
 
-	if (ret) {
-		kfree(xive);
+	if (ret)
 		return ret;
-	}
 
 	return 0;
 }
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1090,9 +1090,9 @@ static int kvmppc_xive_native_create(str
 	xive->ops = &kvmppc_xive_native_ops;
 
 	if (ret)
-		kfree(xive);
+		return ret;
 
-	return ret;
+	return 0;
 }
 
 /*


