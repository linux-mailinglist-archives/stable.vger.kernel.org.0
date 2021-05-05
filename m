Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC6373A92
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhEEMLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhEEMKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CB5613E6;
        Wed,  5 May 2021 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216555;
        bh=JhQqfY6l6fIy6r+bHxa1HO9lFgmKSe4vsm/N6D/zt6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf9cu5QPwKP5k1V/pQl8MzXMz8qIxn2fTHZszJt8VwQOTFSiVv9cmi1x095Pe95Kh
         rTiQ1cjLIusrPyTekb1M/Bl12KEJ2wMq47eeWeyHfwJYHbzXtMBvYDSdt3YX6VgwMC
         FTU4ofuxmwp4UTg1nXGdT9pwlxPMyyuhPsZJ8AAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.11 19/31] swiotlb: dont modify orig_addr in swiotlb_tbl_sync_single
Date:   Wed,  5 May 2021 14:06:08 +0200
Message-Id: <20210505112327.292797579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianxiong Gao <jxgao@google.com>

commit: 16fc3cef33a04632ab6b31758abdd77563a20759

swiotlb_tbl_map_single currently nevers sets a tlb_addr that is not
aligned to the tlb bucket size.  But we're going to add such a case
soon, for which this adjustment would be bogus.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jianxiong Gao <jxgao@google.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/swiotlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -660,7 +660,6 @@ void swiotlb_tbl_sync_single(struct devi
 
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
-	orig_addr += (unsigned long)tlb_addr & (IO_TLB_SIZE - 1);
 
 	switch (target) {
 	case SYNC_FOR_CPU:


