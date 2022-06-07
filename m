Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E92540B3B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350112AbiFGS1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349148AbiFGSTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66665B36C0;
        Tue,  7 Jun 2022 10:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E39AB82366;
        Tue,  7 Jun 2022 17:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61C4C34119;
        Tue,  7 Jun 2022 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624399;
        bh=M8Pp6pza3e588Ahg60DnN2QhEs1nBBAuhap4x/rPUHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/rpBg75bWlPLK21qxp98DHVZqOn4cidH+/CliRgYsqQ/cj0pklAb/aS0b48rSCBS
         lHuQK2iukolPvvmSkCLk0g2bbWFclc7rWFqQub0NJpyfAER5UD0exl+Qvh+kASKPMH
         SOhfDKzZ3neGDD+kMHt4u1aE1EIHbYNIVsfr2/n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 314/667] block: Fix the bio.bi_opf comment
Date:   Tue,  7 Jun 2022 18:59:39 +0200
Message-Id: <20220607164944.189598565@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5d2ae14276e698c76fa0c8ce870103f343b38263 ]

Commit ef295ecf090d modified the Linux kernel such that the bottom bits
of the bi_opf member contain the operation instead of the topmost bits.
That commit did not update the comment next to bi_opf. Hence this patch.

>From commit ef295ecf090d:
-#define bio_op(bio)    ((bio)->bi_opf >> BIO_OP_SHIFT)
+#define bio_op(bio)    ((bio)->bi_opf & REQ_OP_MASK)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Fixes: ef295ecf090d ("block: better op and flags encoding")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220511235152.1082246-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk_types.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index be622b5a21ed..17c92c0f15b2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -215,9 +215,8 @@ static inline void bio_issue_init(struct bio_issue *issue,
 struct bio {
 	struct bio		*bi_next;	/* request queue link */
 	struct block_device	*bi_bdev;
-	unsigned int		bi_opf;		/* bottom bits req flags,
-						 * top bits REQ_OP. Use
-						 * accessors.
+	unsigned int		bi_opf;		/* bottom bits REQ_OP, top bits
+						 * req_flags.
 						 */
 	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
-- 
2.35.1



