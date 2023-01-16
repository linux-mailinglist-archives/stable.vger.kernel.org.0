Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EB466C77F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjAPQb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjAPQaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:30:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DBE279A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:19:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3FC6104E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B107C433EF;
        Mon, 16 Jan 2023 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885961;
        bh=6Tz1WXaCeJ/SbJlqbv1erdWNU89yL0kKSF3WJGH5hok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1h84XQFg3LsKrYo9o4dNCXhYPSrb3Hs1VUzFLf/HpDkL7QtWfkNYnLGXdeR3y5TV
         eZjD8xaredQ15+ypvc90fv240eNYwBEGwq8Vnn2vTUsigFUobXbsLeHi9lRgtrgdwF
         V9BjS1KIDyY+hdF8iL7Q2+hfQUD3SOqy1hvrtx1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/658] RDMA/siw: Set defined status for work completion with undefined status
Date:   Mon, 16 Jan 2023 16:45:36 +0100
Message-Id: <20230116154920.899737508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 26d4eb44a9d0..214714afacb7 100644
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



