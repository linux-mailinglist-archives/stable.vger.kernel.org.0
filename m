Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA1F22646A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgGTPou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgGTPot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88FED2065E;
        Mon, 20 Jul 2020 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259889;
        bh=dxPAn9gjsJi3cfQmbFjDRfi/Ywh6j3TDJZWaFzsP95U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTMnzJBJ+MzSp2UrOZzanoP0FRy4k3RL2r9/jXvKqMSLwuYHCh+QU90Iz/EAebDs9
         Q4OB59HCkZ5VebqEctR5k1eXzBQsPX0U/i7qJvdNEOjU4VTOq9Wg2swoU9ybpxxH+4
         MUrfXry+D5rYlrUv34CINRBVK77/dOP29y1AlwCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Scull <ascull@google.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.14 030/125] KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART
Date:   Mon, 20 Jul 2020 17:36:09 +0200
Message-Id: <20200720152804.435058832@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Scull <ascull@google.com>

commit b9e10d4a6c9f5cbe6369ce2c17ebc67d2e5a4be5 upstream.

HVC_SOFT_RESTART is given values for x0-2 that it should installed
before exiting to the new address so should not set x0 to stub HVC
success or failure code.

Fixes: af42f20480bf1 ("arm64: hyp-stub: Zero x0 on successful stub handling")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Scull <ascull@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200706095259.1338221-1-ascull@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/hyp-init.S |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -147,11 +147,15 @@ ENTRY(__kvm_handle_stub_hvc)
 
 1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
-reset:
+
 	/*
-	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
-	 * case we coming via HVC_SOFT_RESTART.
+	 * Set the HVC_RESET_VECTORS return code before entering the common
+	 * path so that we do not clobber x0-x2 in case we are coming via
+	 * HVC_SOFT_RESTART.
 	 */
+	mov	x0, xzr
+reset:
+	/* Reset kvm back to the hyp stub. */
 	mrs	x5, sctlr_el2
 	ldr	x6, =SCTLR_ELx_FLAGS
 	bic	x5, x5, x6		// Clear SCTL_M and etc
@@ -162,7 +166,6 @@ reset:
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-	mov	x0, xzr
 	eret
 
 1:	/* Bad stub call */


