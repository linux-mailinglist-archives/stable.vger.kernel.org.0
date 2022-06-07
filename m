Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05108541582
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376495AbiFGUgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377897AbiFGUej (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96481326C4;
        Tue,  7 Jun 2022 11:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FEE5B8237B;
        Tue,  7 Jun 2022 18:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BE1C385A2;
        Tue,  7 Jun 2022 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626994;
        bh=54oShyB5o9LvImQ36NGWJacrxO3osSvxe7sccidCXN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbinMt9kdmc7LkMVaq94Zs1GFnMrxzw/lF/aI3u9Dja/LMMWFKmMA5ZlNacxMZOY2
         P1xAPrH08PEDiDYOQh+ilJWHmuwO9iIqJqWwoEHkF+qhrXa/hM3Wl9ZCx+BFlRrWuR
         zkM7AeOXrlYYqZPUruHktUxj2j6WEDp9b5+M2GNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 579/772] dmaengine: idxd: Fix the error handling path in idxd_cdev_register()
Date:   Tue,  7 Jun 2022 19:02:51 +0200
Message-Id: <20220607165006.011961651@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



