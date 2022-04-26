Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67C450F892
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbiDZJH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347395AbiDZJFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F401114F9B;
        Tue, 26 Apr 2022 01:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68893CE1BC9;
        Tue, 26 Apr 2022 08:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B25BC385B1;
        Tue, 26 Apr 2022 08:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962671;
        bh=1XJ1Sf60yZQU4IASk4WLywESxjLgzcT8qGbx2geJLIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPT7lObJB2Dho6jYke9Eoj6X84bCWj3Uy5vT/fREBl4+f4FMIctXHjIKBh68tGIib
         REFEWr7cfscVI2Svs/mYavZi+pnMVPeY1uucplIjRGdL0/RbMuupP5auvIditxHtNX
         kcxxGAsoeT/CTa413VfOAhLAjWyryQIv7/Cbi9U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 049/146] dmaengine: idxd: fix retry value to be constant for duration of function call
Date:   Tue, 26 Apr 2022 10:20:44 +0200
Message-Id: <20220426081751.449551776@linuxfoundation.org>
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

[ Upstream commit bc3452cdfc468a65965d0ac397c940acb787ea4d ]

When retries is compared to wq->enqcmds_retries each loop of idxd_enqcmds(),
wq->enqcmds_retries can potentially changed by user. Assign the value
of retries to wq->enqcmds_retries during initialization so it is the
original value set when entering the function.

Fixes: 7930d8553575 ("dmaengine: idxd: add knob for enqcmds retries")
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/165031760154.3658664.1983547716619266558.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 554b0602d2e9..c01db23e3333 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -150,7 +150,7 @@ static void llist_abort_desc(struct idxd_wq *wq, struct idxd_irq_entry *ie,
  */
 int idxd_enqcmds(struct idxd_wq *wq, void __iomem *portal, const void *desc)
 {
-	unsigned int retries = 0;
+	unsigned int retries = wq->enqcmds_retries;
 	int rc;
 
 	do {
@@ -158,7 +158,7 @@ int idxd_enqcmds(struct idxd_wq *wq, void __iomem *portal, const void *desc)
 		if (rc == 0)
 			break;
 		cpu_relax();
-	} while (retries++ < wq->enqcmds_retries);
+	} while (retries--);
 
 	return rc;
 }
-- 
2.35.1



