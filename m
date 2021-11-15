Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B63451EA5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347214AbhKPAgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345036AbhKOT0D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64E546370E;
        Mon, 15 Nov 2021 19:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003358;
        bh=/gMAH+Fp3yv3zlWr0R6/xJbcRFSl1Ziv3e1Ze7uyz7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRUe6vMz/L/l4VjPAxXiDlaI/9s3oLglP22Dz2m8jR4GXpcoET3t6BPJKK+Ltan7I
         NdR13R6VMSj4QX3wj4WUTVPVdrFBPCsHJNBvtHmdNWE43JdMR4JkpePEAZYoCYY5mK
         z8gQc/BcM3dzag/5VNq+J4O24wDZhteYNFPYJcXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 905/917] powerpc/vas: Fix potential NULL pointer dereference
Date:   Mon, 15 Nov 2021 18:06:40 +0100
Message-Id: <20211115165459.721757620@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 61cb9ac66b30374c7fd8a8b2a3c4f8f432c72e36 upstream.

(!ptr && !ptr->foo) strikes again. :)

The expression (!ptr && !ptr->foo) is bogus and in case ptr is NULL,
it leads to a NULL pointer dereference: ptr->foo.

Fix this by converting && to ||

This issue was detected with the help of Coccinelle, and audited and
fixed manually.

Fixes: 1a0d0d5ed5e3 ("powerpc/vas: Add platform specific user window operations")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211015050345.GA1161918@embeddedor
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/book3s/vas-api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -303,7 +303,7 @@ static int coproc_ioc_tx_win_open(struct
 		return -EINVAL;
 	}
 
-	if (!cp_inst->coproc->vops && !cp_inst->coproc->vops->open_win) {
+	if (!cp_inst->coproc->vops || !cp_inst->coproc->vops->open_win) {
 		pr_err("VAS API is not registered\n");
 		return -EACCES;
 	}
@@ -373,7 +373,7 @@ static int coproc_mmap(struct file *fp,
 		return -EINVAL;
 	}
 
-	if (!cp_inst->coproc->vops && !cp_inst->coproc->vops->paste_addr) {
+	if (!cp_inst->coproc->vops || !cp_inst->coproc->vops->paste_addr) {
 		pr_err("%s(): VAS API is not registered\n", __func__);
 		return -EACCES;
 	}


