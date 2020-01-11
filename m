Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9D2137E0B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgAKKEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729510AbgAKKEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:04:21 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F9F2082E;
        Sat, 11 Jan 2020 10:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737060;
        bh=p5dwTaPMJdCvDh7Dvuak61KLF/ftAgyeRcG3MUwknos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zng8ASsNEOAQViXfEL/Z/sAUctKKDvxHp5LovM76RcO6jPvzBhSdX2YLHDU75vr/O
         Odmp4vRPgUMq197oLt1a35OmGA1E27YvqRcfvLknaA/zZ0YOmLQiJshP5PXIyOenUP
         cOEoCL8tPkG8Pxl2LmblM8XZSjgbknQLTGtGv0j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.de>,
        Maximilian Heyne <mheyne@amazon.de>,
        Paul Durrant <pdurrant@amazon.co.uk>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        SeongJae Park <sjpark@amazon.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 54/91] xen/blkback: Avoid unmapping unmapped grant pages
Date:   Sat, 11 Jan 2020 10:49:47 +0100
Message-Id: <20200111094905.256448047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit f9bd84a8a845d82f9b5a081a7ae68c98a11d2e84 ]

For each I/O request, blkback first maps the foreign pages for the
request to its local pages.  If an allocation of a local page for the
mapping fails, it should unmap every mapping already made for the
request.

However, blkback's handling mechanism for the allocation failure does
not mark the remaining foreign pages as unmapped.  Therefore, the unmap
function merely tries to unmap every valid grant page for the request,
including the pages not mapped due to the allocation failure.  On a
system that fails the allocation frequently, this problem leads to
following kernel crash.

  [  372.012538] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
  [  372.012546] IP: [<ffffffff814071ac>] gnttab_unmap_refs.part.7+0x1c/0x40
  [  372.012557] PGD 16f3e9067 PUD 16426e067 PMD 0
  [  372.012562] Oops: 0002 [#1] SMP
  [  372.012566] Modules linked in: act_police sch_ingress cls_u32
  ...
  [  372.012746] Call Trace:
  [  372.012752]  [<ffffffff81407204>] gnttab_unmap_refs+0x34/0x40
  [  372.012759]  [<ffffffffa0335ae3>] xen_blkbk_unmap+0x83/0x150 [xen_blkback]
  ...
  [  372.012802]  [<ffffffffa0336c50>] dispatch_rw_block_io+0x970/0x980 [xen_blkback]
  ...
  Decompressing Linux... Parsing ELF... done.
  Booting the kernel.
  [    0.000000] Initializing cgroup subsys cpuset

This commit fixes this problem by marking the grant pages of the given
request that didn't mapped due to the allocation failure as invalid.

Fixes: c6cc142dac52 ("xen-blkback: use balloon pages for all mappings")

Reviewed-by: David Woodhouse <dwmw@amazon.de>
Reviewed-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Paul Durrant <pdurrant@amazon.co.uk>
Reviewed-by: Roger Pau Monné <roger.pau@citrix.com>
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/blkback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index d6eaaa25d1cc..a700e525535c 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -929,6 +929,8 @@ next:
 out_of_memory:
 	pr_alert("%s: out of memory\n", __func__);
 	put_free_pages(ring, pages_to_gnt, segs_to_map);
+	for (i = last_map; i < num; i++)
+		pages[i]->handle = BLKBACK_INVALID_HANDLE;
 	return -ENOMEM;
 }
 
-- 
2.20.1



