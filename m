Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80F5657B2C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiL1PS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiL1PSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:18:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63F713F85
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:18:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD15B8172C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDF2C433D2;
        Wed, 28 Dec 2022 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240716;
        bh=l9HWFXL6iqJaCWp0n0E1sik/5WoiJBg7NENzeQiWgc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeGAw8kEziB4zXrqzTG4bkwv34pQofD/jBZdptoPhTSYp8nCTizfdMcPT3Z5NV+Iz
         1HWkciFZK/Gpi3fWg4RnMG7yaoZN9kkJju6X2om7I01t7kb17Lu2hyUEKu0+Ta+6Nv
         3V2sB2F0qMX0UJVzdtAN0dMp10aQSEnxH2hvBDMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/731] RDMA/siw: Set defined status for work completion with undefined status
Date:   Wed, 28 Dec 2022 15:38:16 +0100
Message-Id: <20221228144307.836760440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 60da2d11fcbc043304910e4d2ca82f9bab953e63 ]

A malicious user may write undefined values into memory mapped completion
queue elements status or opcode. Undefined status or opcode values will
result in out-of-bounds access to an array mapping siw internal
representation of opcode and status to RDMA core representation when
reaping CQ elements. While siw detects those undefined values, it did not
correctly set completion status to a defined value, thus defeating the
whole purpose of the check.

This bug leads to the following Smatch static checker warning:

	drivers/infiniband/sw/siw/siw_cq.c:96 siw_reap_cqe()
	error: buffer overflow 'map_cqe_status' 10 <= 21

Fixes: bdf1da5df9da ("RDMA/siw: Fix immediate work request flush to completion queue")
Link: https://lore.kernel.org/r/20221115170747.1263298-1-bmt@zurich.ibm.com
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cq.c b/drivers/infiniband/sw/siw/siw_cq.c
index acc7bcd538b5..403029de6b92 100644
--- a/drivers/infiniband/sw/siw/siw_cq.c
+++ b/drivers/infiniband/sw/siw/siw_cq.c
@@ -88,9 +88,9 @@ int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *wc)
 
 			if (opcode >= SIW_NUM_OPCODES) {
 				opcode = 0;
-				status = IB_WC_GENERAL_ERR;
+				status = SIW_WC_GENERAL_ERR;
 			} else if (status >= SIW_NUM_WC_STATUS) {
-				status = IB_WC_GENERAL_ERR;
+				status = SIW_WC_GENERAL_ERR;
 			}
 			wc->opcode = map_wc_opcode[opcode];
 			wc->status = map_cqe_status[status].ib;
-- 
2.35.1



