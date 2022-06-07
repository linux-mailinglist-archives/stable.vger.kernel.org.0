Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B986541D07
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383627AbiFGWHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383732AbiFGWGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5082534C9;
        Tue,  7 Jun 2022 12:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F462B82182;
        Tue,  7 Jun 2022 19:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA97C385A5;
        Tue,  7 Jun 2022 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629442;
        bh=54oShyB5o9LvImQ36NGWJacrxO3osSvxe7sccidCXN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08WB348VGe1mB4x85kMoFcIfUKEIFCfvOlhjVzMEetdCyS2BU9cD5ZekyvOPYcrzB
         MF2sSMQ4UxGQiv+1QuxqA/tgYTLFVasOv78Bj//pkCnremycEtPs4+atVkV67JiBlI
         6/W2GBo213vRdOmTHLE97g51Fk8WlFmkF9IwLI98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 675/879] dmaengine: idxd: Fix the error handling path in idxd_cdev_register()
Date:   Tue,  7 Jun 2022 19:03:13 +0200
Message-Id: <20220607165022.441765444@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aab08c1aac01097815fbcf10fce7021d2396a31f ]

If a call to alloc_chrdev_region() fails, the already allocated resources
are leaking.

Add the needed error handling path to fix the leak.

Fixes: 42d279f9137a ("dmaengine: idxd: add char driver to expose submission portal to userland")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/1b5033dcc87b5f2a953c413f0306e883e6114542.1650521591.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index b9b2b4a4124e..033df43db0ce 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -369,10 +369,16 @@ int idxd_cdev_register(void)
 		rc = alloc_chrdev_region(&ictx[i].devt, 0, MINORMASK,
 					 ictx[i].name);
 		if (rc)
-			return rc;
+			goto err_free_chrdev_region;
 	}
 
 	return 0;
+
+err_free_chrdev_region:
+	for (i--; i >= 0; i--)
+		unregister_chrdev_region(ictx[i].devt, MINORMASK);
+
+	return rc;
 }
 
 void idxd_cdev_remove(void)
-- 
2.35.1



