Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701FF65B091
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjABL0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjABLZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:25:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A466552
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D3E4B80CA9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D02C433EF;
        Mon,  2 Jan 2023 11:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658661;
        bh=Ns3IM7zhWhwo5ZlzdMkW2V99noe8MRUfyrw3mytHUPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaZlNcPsTElZWLKkHVwzBmPiJCmnB8nusenRCXMWhAxyHuhRuG6HHnjeBp780l21J
         qr7Lb4cmORjUF2Rj3e5JBW2z/yywU0hrm8KPizS/WQ7irMldzR1i0KpblHATZHH+HT
         36lhR2K1oNWH5/KLpNkMPzdrxgv/obvkR6ZnTY9c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/71] nvme-pci: fix mempool alloc size
Date:   Mon,  2 Jan 2023 12:21:30 +0100
Message-Id: <20230102110551.727152377@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c89a529e823d51dd23c7ec0c047c7a454a428541 ]

Convert the max size to bytes to match the units of the divisor that
calculates the worst-case number of PRP entries.

The result is used to determine how many PRP Lists are required. The
code was previously rounding this to 1 list, but we can require 2 in the
worst case. In that scenario, the driver would corrupt memory beyond the
size provided by the mempool.

While unlikely to occur (you'd need a 4MB in exactly 127 phys segments
on a queue that doesn't support SGLs), this memory corruption has been
observed by kfence.

Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 943e942e6266f ("nvme-pci: limit max IO size and segments to avoid high order allocations")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4ed8a14e2803..3116a0e2ec27 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -378,8 +378,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
  */
 static int nvme_pci_npages_prp(void)
 {
-	unsigned nprps = DIV_ROUND_UP(NVME_MAX_KB_SZ + NVME_CTRL_PAGE_SIZE,
-				      NVME_CTRL_PAGE_SIZE);
+	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
+	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
 	return DIV_ROUND_UP(8 * nprps, PAGE_SIZE - 8);
 }
 
-- 
2.35.1



