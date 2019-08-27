Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A239E0B7
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbfH0IFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731410AbfH0IFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 245F52173E;
        Tue, 27 Aug 2019 08:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893108;
        bh=qxtuKSUg3eurnCP7YIA3t2QLRNZ0xE9YzzYPXHpgpbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwJxMuYnOgILVt/ikzjio/YV/G2Lkcg4EC6imd2tZGMtpg2Cy4zwrTGkQztzGE9Ax
         HLFpGmAXT6M7J4U4WkxniNwzVAgvH4LRxWzrWjSPm67RgVS7tSFDCiFeEToH1S8leJ
         qZO+gkI1Gg2FicY0ReGjV1Q+ugMyfTLjSur+P0PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Subject: [PATCH 5.2 123/162] Drivers: hv: vmbus: Fix virt_to_hvpfn() for X86_PAE
Date:   Tue, 27 Aug 2019 09:50:51 +0200
Message-Id: <20190827072742.758392913@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit a9fc4340aee041dd186d1fb8f1b5d1e9caf28212 upstream.

In the case of X86_PAE, unsigned long is u32, but the physical address type
should be u64. Due to the bug here, the netvsc driver can not load
successfully, and sometimes the VM can panic due to memory corruption (the
hypervisor writes data to the wrong location).

Fixes: 6ba34171bcbd ("Drivers: hv: vmbus: Remove use of slow_virt_to_phys()")
Cc: stable@vger.kernel.org
Cc: Michael Kelley <mikelley@microsoft.com>
Reported-and-tested-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -26,7 +26,7 @@
 
 static unsigned long virt_to_hvpfn(void *addr)
 {
-	unsigned long paddr;
+	phys_addr_t paddr;
 
 	if (is_vmalloc_addr(addr))
 		paddr = page_to_phys(vmalloc_to_page(addr)) +


