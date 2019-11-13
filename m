Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46353FA327
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbfKMCIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730345AbfKMCAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94098222CF;
        Wed, 13 Nov 2019 02:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610402;
        bh=HbgVx4qjb6kTQShWNZlxWmMuVhrxfteiZTihwmQgvoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aadU0IQIT+HLt1mKlF9BASIMVAVA5teMW71EQJO79ZBICyyAprVPfxXuMBvoYMTZA
         Ze0Oxh2GeqqMIJZIXtuQkz9mDOFyQegUPkzWPtokwGaFmFiqGxko2x7745en4RZ/hA
         I9XvUCRzyUReXKR45zbWBmPJSJkgO3Tn+VuxElDQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 19/68] powerpc/pseries: Fix DTL buffer registration
Date:   Tue, 12 Nov 2019 20:58:43 -0500
Message-Id: <20191113015932.12655-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit db787af1b8a6b4be428ee2ea7d409dafcaa4a43c ]

When CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set, we register the DTL
buffer for a cpu when the associated file under powerpc/dtl in debugfs
is opened. When doing so, we need to set the size of the buffer being
registered in the second u32 word of the buffer. This needs to be in big
endian, but we are not doing the conversion resulting in the below error
showing up in dmesg:

	dtl_start: DTL registration for cpu 0 (hw 0) failed with -4

Fix this in the obvious manner.

Fixes: 7c105b63bd98 ("powerpc: Add CONFIG_CPU_LITTLE_ENDIAN kernel config option.")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 39049e4884fbd..37de83c5ef172 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -150,7 +150,7 @@ static int dtl_start(struct dtl *dtl)
 
 	/* Register our dtl buffer with the hypervisor. The HV expects the
 	 * buffer size to be passed in the second word of the buffer */
-	((u32 *)dtl->buf)[1] = DISPATCH_LOG_BYTES;
+	((u32 *)dtl->buf)[1] = cpu_to_be32(DISPATCH_LOG_BYTES);
 
 	hwcpu = get_hard_smp_processor_id(dtl->cpu);
 	addr = __pa(dtl->buf);
-- 
2.20.1

