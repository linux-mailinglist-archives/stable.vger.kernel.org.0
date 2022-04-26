Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D39650F7AB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346305AbiDZJH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347352AbiDZJFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9EC111CA6;
        Tue, 26 Apr 2022 01:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E0F26133B;
        Tue, 26 Apr 2022 08:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2DDC385A4;
        Tue, 26 Apr 2022 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962668;
        bh=boMH+JABDXmSGHJzf6Di9Kg3rMGRkIRz2H3gt25TXfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbio1GR3nXc464jxJx0wzUzDeYP/te2h8yADQ4Y8RK3I+gdX2SxIBueLxRd/A6+KX
         GXc85alZ3AN5n3bfb/yDnmLh8gR47lrqFFBIkbUphwHKYguT7ylzpFlG5RmlGULyVb
         N9WS107cI7s5V1lb/vnQFIw9deovm0G0fP3RneD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Macieira <thiago.macieira@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 048/146] dmaengine: idxd: match type for retries var in idxd_enqcmds()
Date:   Tue, 26 Apr 2022 10:20:43 +0200
Message-Id: <20220426081751.422610194@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 5d9d16e5aa0cf023e600bf716239fd9caa2d4148 ]

wq->enqcmds_retries is defined as unsigned int. However, retries on the
stack is defined as int. Change retries to unsigned int to compare the same
type.

Fixes: 7930d8553575 ("dmaengine: idxd: add knob for enqcmds retries")
Suggested-by: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/165031747059.3658198.6035308204505664375.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index e289fd48711a..554b0602d2e9 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -150,7 +150,8 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
  */
 int idxd_enqcmds(struct idxd_wq *wq, void __iomem *portal, const void *desc)
 {
-	int rc, retries = 0;
+	unsigned int retries = 0;
+	int rc;
 
 	do {
 		rc = enqcmds(portal, desc);
-- 
2.35.1



