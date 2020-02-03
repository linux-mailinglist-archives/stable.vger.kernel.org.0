Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C851150BDB
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgBCQbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbgBCQbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:31:06 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBFB72080D;
        Mon,  3 Feb 2020 16:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747466;
        bh=hwXRl+Lx/wvWDC0qswCYyJICTS5Jv0MsAO4f/H81hn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjsnkHtBHaTyrCPH0JQP6YLaXslSe8ghm4UMkW8G63n2Pz4NeHvKgzBoZ+ToNDSl4
         D20LLTQ998oMcmrMMv2YioktVbjlcQ7bIEMN+WCmXQY+s/0+1u9fENebYhrGTqhMU9
         U/BO94BSUeD9ITh1qwki3Ys/M+vyxR3v+9ig+JbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 75/89] tee: optee: Fix compilation issue with nommu
Date:   Mon,  3 Feb 2020 16:20:00 +0000
Message-Id: <20200203161926.121917970@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 9e0caab8e0f96f0af7d1dd388e62f44184a75372 ]

The optee driver uses specific page table types to verify if a memory
region is normal. These types are not defined in nommu systems. Trying
to compile the driver in these systems results in a build error:

  linux/drivers/tee/optee/call.c: In function ‘is_normal_memory’:
  linux/drivers/tee/optee/call.c:533:26: error: ‘L_PTE_MT_MASK’ undeclared
     (first use in this function); did you mean ‘PREEMPT_MASK’?
     return (pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC;
                             ^~~~~~~~~~~~~
                             PREEMPT_MASK
  linux/drivers/tee/optee/call.c:533:26: note: each undeclared identifier is
     reported only once for each function it appears in
  linux/drivers/tee/optee/call.c:533:44: error: ‘L_PTE_MT_WRITEALLOC’ undeclared
     (first use in this function)
     return (pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC;
                                            ^~~~~~~~~~~~~~~~~~~

Make the optee driver depend on MMU to fix the compilation issue.

Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
[jw: update commit title]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/optee/Kconfig b/drivers/tee/optee/Kconfig
index 0126de898036c..108600c6eb564 100644
--- a/drivers/tee/optee/Kconfig
+++ b/drivers/tee/optee/Kconfig
@@ -2,6 +2,7 @@
 config OPTEE
 	tristate "OP-TEE"
 	depends on HAVE_ARM_SMCCC
+	depends on MMU
 	help
 	  This implements the OP-TEE Trusted Execution Environment (TEE)
 	  driver.
-- 
2.20.1



