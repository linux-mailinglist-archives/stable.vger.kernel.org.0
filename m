Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852A46675A5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbjALOXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbjALOWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:22:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB75F54725
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486C16202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C352C433D2;
        Thu, 12 Jan 2023 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532865;
        bh=l9HWFXL6iqJaCWp0n0E1sik/5WoiJBg7NENzeQiWgc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dSJD9s4QDL2c8MoC9cSFt+PyphkN7dUVgVggp28c+voEhRrZFW7JsChVfqW/JEax
         c7W8V9+fP8O5RhEct0zwQQPl5E/C9nDMLbhDlm3YRap+aZjeFv/RIXvL67SKHy2pm8
         ofGaIBv/oJ3EAvvbcJnf7zGi9Nq746n1LYSw7qOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/783] RDMA/siw: Set defined status for work completion with undefined status
Date:   Thu, 12 Jan 2023 14:50:16 +0100
Message-Id: <20230112135538.248914645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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



