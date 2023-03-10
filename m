Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903EF6B4399
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjCJOQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjCJOPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:15:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0912911CBC7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9127061380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5935C433EF;
        Fri, 10 Mar 2023 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457674;
        bh=qb+KCG4feqfcL+4WEq3pRq76ehB7utZ3BMRoQoUz9R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/lWKt7IecUd/LTA7M2vPOpbXhmlSkGv9wST0JNdifTBOL+4Oow5zrxRNIi0MAHdB
         CSBDuObwg+bFwvjLa1amZpV1hGG6/kgljiomei6W9GtD80uSACmmDJHzg9bnX0D3BO
         coiZdb6I0LDvYQH9D4mTjcnHkJL8tY00nqQ3UKfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saurav Kashyap <skashyap@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/252] block: bio-integrity: Copy flags when bio_integrity_payload is cloned
Date:   Fri, 10 Mar 2023 14:36:29 +0100
Message-Id: <20230310133719.407589198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit b6a4bdcda430e3ca43bbb9cb1d4d4d34ebe15c40 ]

Make sure to copy the flags when a bio_integrity_payload is cloned.
Otherwise per-I/O properties such as IP checksum flag will not be
passed down to the HBA driver. Since the integrity buffer is owned by
the original bio, the BIP_BLOCK_INTEGRITY flag needs to be masked off
to avoid a double free in the completion path.

Fixes: aae7df50190a ("block: Integrity checksum flag")
Fixes: b1f01388574c ("block: Relocate bio integrity flags")
Reported-by: Saurav Kashyap <skashyap@marvell.com>
Tested-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20230215171801.21062-1-martin.petersen@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2e22a3f7466a8..469e30a6d3cde 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -444,6 +444,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
-- 
2.39.2



