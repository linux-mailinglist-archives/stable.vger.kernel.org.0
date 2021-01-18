Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26A72FA9E2
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390467AbhARTP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390454AbhARLiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8435C224B0;
        Mon, 18 Jan 2021 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969857;
        bh=velFEvr9vGZQoXrs7U56Ggklq13fpI3OW3qX4bLkrGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoQCaJhR0aMIhHnesV/JawZEGxIPauSry74PYVttCougenbsTnvtrLUriiSTf4NBE
         CGx43Ts8jrR+ZZFHyCOotsUnF4lOlVp5SfkGf/fIW0TZ1p4HBALUaIjB9JGrr2tCkE
         C8atYKm/9L+E5eW26X0cmnRsmLMhsK0mStjz1890=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 11/76] RDMA/ocrdma: Fix use after free in ocrdma_dealloc_ucontext_pd()
Date:   Mon, 18 Jan 2021 12:34:11 +0100
Message-Id: <20210118113341.529435390@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit f2bc3af6353cb2a33dfa9d270d999d839eef54cb upstream.

In ocrdma_dealloc_ucontext_pd() uctx->cntxt_pd is assigned to the variable
pd and then after uctx->cntxt_pd is freed, the variable pd is passed to
function _ocrdma_dealloc_pd() which dereferences pd directly or through
its call to ocrdma_mbx_dealloc_pd().

Reorder the free using the variable pd.

Cc: stable@vger.kernel.org
Fixes: 21a428a019c9 ("RDMA: Handle PD allocations by IB/core")
Link: https://lore.kernel.org/r/20201230024653.1516495-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -442,9 +442,9 @@ static void ocrdma_dealloc_ucontext_pd(s
 		pr_err("%s(%d) Freeing in use pdid=0x%x.\n",
 		       __func__, dev->id, pd->id);
 	}
-	kfree(uctx->cntxt_pd);
 	uctx->cntxt_pd = NULL;
 	_ocrdma_dealloc_pd(dev, pd);
+	kfree(pd);
 }
 
 static struct ocrdma_pd *ocrdma_get_ucontext_pd(struct ocrdma_ucontext *uctx)


