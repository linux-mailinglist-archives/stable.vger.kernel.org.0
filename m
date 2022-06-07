Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F0B5405BB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346491AbiFGR3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346526AbiFGR3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2949310D915;
        Tue,  7 Jun 2022 10:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57FC60DE2;
        Tue,  7 Jun 2022 17:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE4CC385A5;
        Tue,  7 Jun 2022 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622681;
        bh=DgrERhmiPRNQUiFMyWldud2/MZurlP6RAhmt8cL/kkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkP5sEAxqdqe9xARuEPRD0dUTdPyaHaS6u0sszurTJeY2Vq9UzsP5Zkr+FqN9xcoM
         ApIL35sGIrbeyuHZoqCx2x7huRMuTnJxXnTRsOh0GTPEE/yECsFvbqoKr0+T9bqveg
         iNNcI61Q5mqUb80EIzF/lvjDaWuf8IYfi6cnO+oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/452] target: remove an incorrect unmap zeroes data deduction
Date:   Tue,  7 Jun 2022 19:00:02 +0200
Message-Id: <20220607164912.881571689@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 179d8609d8424529e95021df939ed7b0b82b37f1 ]

For block devices, the SCSI target drivers implements UNMAP as calls to
blkdev_issue_discard, which does not guarantee zeroing just because
Write Zeroes is supported.

Note that this does not affect the file backed path which uses
fallocate to punch holes.

Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220415045258.199825-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 109f019d2148..1eded5c4ebda 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -831,7 +831,6 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
 	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
 								block_size;
-	attrib->unmap_zeroes_data = !!(q->limits.max_write_zeroes_sectors);
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.35.1



