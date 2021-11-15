Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F621451E90
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbhKPAgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345083AbhKOT0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 212CB6109E;
        Mon, 15 Nov 2021 19:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003391;
        bh=QQ/EFiM1Q3qH70HEMMkXoE5EpmYyYlh00KibiceVI/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rboIeZJevYqPEZvO/4cHgl1soD3QfPj/4Kxr02vJLrbNswgcvl3eSDjV9bYtbosSR
         ZocBy1p8Itb6CbrM/sCQ3WQn5G83aewalvcWUAzGfjHc3vgqyI4tkOMTpFCfzJlEB4
         4K1EJJx097aOK0eg7PlVj3dXcClSyjYkLPZwGLjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 885/917] bcache: Revert "bcache: use bvec_virt"
Date:   Mon, 15 Nov 2021 18:06:20 +0100
Message-Id: <20211115165459.060259009@linuxfoundation.org>
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

From: Coly Li <colyli@suse.de>

commit 2878feaed543c35f9dbbe6d8ce36fb67ac803eef upstream.

This reverts commit 2fd3e5efe791946be0957c8e1eed9560b541fe46.

The above commit replaces page_address(bv->bv_page) by bvec_virt(bv) to
avoid directly access to bv->bv_page, but in situation bv->bv_offset is
not zero and page_address(bv->bv_page) is not equal to bvec_virt(bv). In
such case a memory corruption may happen because memory in next page is
tainted by following line in do_btree_node_write(),
	memcpy(bvec_virt(bv), addr, PAGE_SIZE);

This patch reverts the mentioned commit to avoid the memory corruption.

Fixes: 2fd3e5efe791 ("bcache: use bvec_virt")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org # 5.15
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211103151041.70516-1-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -378,7 +378,7 @@ static void do_btree_node_write(struct b
 		struct bvec_iter_all iter_all;
 
 		bio_for_each_segment_all(bv, b->bio, iter_all) {
-			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
+			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
 			addr += PAGE_SIZE;
 		}
 


