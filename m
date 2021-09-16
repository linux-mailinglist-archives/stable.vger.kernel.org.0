Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8154440E522
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbhIPRIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349562AbhIPRGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9125D61994;
        Thu, 16 Sep 2021 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810151;
        bh=9ys4q/Cq6uxiYo0LVkXwRkBOrR9jLBigOEKO29P6kHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zewKGH/G7byP4RwyurZIf7rOEnoKkSMLvNFsgQAwlcM5OtBs376yDgSNOEuoYL8Xu
         6hiAv0bB4Y4faCY2fU1a4S6ZUuv7kNa2N49iYQMhcgr8AHDtkl3cGRbnOkFSqzhvxh
         raf7kCZiP3vwHTLEdZnDaDjtPoZOR9VMGD7B8AFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@aj.id.au>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 5.14 036/432] soc: aspeed: p2a-ctrl: Fix boundary check for mmap
Date:   Thu, 16 Sep 2021 17:56:25 +0200
Message-Id: <20210916155812.039268767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iwona Winiarska <iwona.winiarska@intel.com>

commit 8b07e990fb254fcbaa919616ac77f981cb48c73d upstream.

The check mixes pages (vm_pgoff) with bytes (vm_start, vm_end) on one
side of the comparison, and uses resource address (rather than just the
resource size) on the other side of the comparison.
This can allow malicious userspace to easily bypass the boundary check and
map pages that are located outside memory-region reserved by the driver.

Fixes: 01c60dcea9f7 ("drivers/misc: Add Aspeed P2A control driver")
Cc: stable@vger.kernel.org
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Tested-by: Andrew Jeffery <andrew@aj.id.au>
Reviewed-by: Joel Stanley <joel@aj.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/aspeed/aspeed-p2a-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/aspeed/aspeed-p2a-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-p2a-ctrl.c
@@ -110,7 +110,7 @@ static int aspeed_p2a_mmap(struct file *
 	vsize = vma->vm_end - vma->vm_start;
 	prot = vma->vm_page_prot;
 
-	if (vma->vm_pgoff + vsize > ctrl->mem_base + ctrl->mem_size)
+	if (vma->vm_pgoff + vma_pages(vma) > ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */


