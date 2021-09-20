Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019CE41201A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354117AbhITRsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348345AbhITRqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A92961B7C;
        Mon, 20 Sep 2021 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157837;
        bh=mNINtN00EoE5fNjTY0n3xsXJqBYhlUF+h6yxqaYywuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ads+7+DGwAGq5b04hFQA2hVF+n+ov2sDRmU8hzwuI/C7V6wt3zKwH/9/4gSJr+Jg+
         jKjTy1CGvsL2JyIT36h2WqlyHgYIwthxjYuZa8io2UGHRDfwfE8uOmxheLppDs5cLk
         iP2OCfcjStc75wfz+mr9S2FK4BUf9LH5QXFQxP0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@aj.id.au>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 4.19 141/293] soc: aspeed: lpc-ctrl: Fix boundary check for mmap
Date:   Mon, 20 Sep 2021 18:41:43 +0200
Message-Id: <20210920163938.108245817@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iwona Winiarska <iwona.winiarska@intel.com>

commit b49a0e69a7b1a68c8d3f64097d06dabb770fec96 upstream.

The check mixes pages (vm_pgoff) with bytes (vm_start, vm_end) on one
side of the comparison, and uses resource address (rather than just the
resource size) on the other side of the comparison.
This can allow malicious userspace to easily bypass the boundary check and
map pages that are located outside memory-region reserved by the driver.

Fixes: 6c4e97678501 ("drivers/misc: Add Aspeed LPC control driver")
Cc: stable@vger.kernel.org
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Tested-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@aj.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/aspeed-lpc-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/aspeed-lpc-ctrl.c
+++ b/drivers/misc/aspeed-lpc-ctrl.c
@@ -50,7 +50,7 @@ static int aspeed_lpc_ctrl_mmap(struct f
 	unsigned long vsize = vma->vm_end - vma->vm_start;
 	pgprot_t prot = vma->vm_page_prot;
 
-	if (vma->vm_pgoff + vsize > lpc_ctrl->mem_base + lpc_ctrl->mem_size)
+	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */


