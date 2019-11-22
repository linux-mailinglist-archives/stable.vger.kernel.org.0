Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A761106EE4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfKVLL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:11:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbfKVK6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C914320706;
        Fri, 22 Nov 2019 10:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420327;
        bh=6r+JJYD0lQTpwxkp1+u+3SUOZCOH5567WtYs3wa8vqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xU/UcWS0crExJMfFuESPLJyUNsyJaPOFX2YsN97KUcvoHslzHwSICNcp9jy83nbcw
         qv/zB0gh0gyXeSq0Jp4lJ6h8RVw1bD7oyL1c5xdlDiC+YGmQxchR/ONjQHyH8IcxdK
         ww6/C7GVWeb2grMcDbW2qJWVyUM6H4nU0L9UWFAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/220] powerpc/pseries: Fix DTL buffer registration
Date:   Fri, 22 Nov 2019 11:27:12 +0100
Message-Id: <20191122100916.956196923@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

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
index 18014cdeb590a..c762689e0eb33 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -149,7 +149,7 @@ static int dtl_start(struct dtl *dtl)
 
 	/* Register our dtl buffer with the hypervisor. The HV expects the
 	 * buffer size to be passed in the second word of the buffer */
-	((u32 *)dtl->buf)[1] = DISPATCH_LOG_BYTES;
+	((u32 *)dtl->buf)[1] = cpu_to_be32(DISPATCH_LOG_BYTES);
 
 	hwcpu = get_hard_smp_processor_id(dtl->cpu);
 	addr = __pa(dtl->buf);
-- 
2.20.1



