Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2C76B44E9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjCJO3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjCJO3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2365D1CBFA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC5B0B8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0446C4339B;
        Fri, 10 Mar 2023 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458451;
        bh=CcP5LYOwVFnlVTm+leKXpZ/wLPDpZvvsaX2P0EAwDQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUp0l56lBPzleQNjbAHxCYYuUkipGq3eBCtr+Wv0H22E2edglZXktzsBLaBykoJ3r
         A1ciHBeO6G8dLY9brQHVRN7RivGFWZvW5H18v/SKv2sK7MT7zd+W9EXTYuinQYzaLF
         kKWgOUV5vDT6gQnL0IN7IxF4f8/q+GuGm6c7LB94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saurav Kashyap <skashyap@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/357] block: bio-integrity: Copy flags when bio_integrity_payload is cloned
Date:   Fri, 10 Mar 2023 14:35:20 +0100
Message-Id: <20230310133735.388047316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index ec295be93ca0d..247f7c480e662 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -424,6 +424,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
-- 
2.39.2



