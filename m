Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C280F2F51D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfE3DLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728676AbfE3DLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:47 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EDB624502;
        Thu, 30 May 2019 03:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185906;
        bh=XMg1VJPFU8dRxGPVBd3Y/ZFiH2pYiUvj9KpvL6JtE/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VA4AA1Jqb2pOj+SdtoiO1joQ8Bgw1JA9QTHFYOA7IN4vEtxQ5igRGsSei+ovEsOTt
         ZozCH9uneWHWi5YczIitWGI2O+Bqqh2K+LPy10BGjj2AMd+aJWhYO0nR1fFZ2wYejJ
         7KWbR+qefySQ9zaoaWEBXlv6f77mKFZaEs0cTKqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Omar Sandoval <osandov@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Juergen Gross <jgross@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 279/405] block: avoid to break XEN by multi-page bvec
Date:   Wed, 29 May 2019 20:04:37 -0700
Message-Id: <20190530030555.005862356@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db5ebd6edd2627d7e81a031643cf43587f63e66c ]

XEN has special page merge requirement, see xen_biovec_phys_mergeable().
We can't merge pages into one bvec simply for XEN.

So move XEN's specific check on page merge into __bio_try_merge_page(),
then abvoid to break XEN by multi-page bvec.

Cc: ris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xenproject.org
Cc: Omar Sandoval <osandov@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 716510ecd7ffa..a3c80a6c1fe51 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -776,6 +776,8 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 
 		if (vec_end_addr + 1 != page_addr + off)
 			return false;
+		if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
+			return false;
 		if (same_page && (vec_end_addr & PAGE_MASK) != page_addr)
 			return false;
 
-- 
2.20.1



