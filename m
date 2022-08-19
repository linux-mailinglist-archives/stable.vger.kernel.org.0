Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8E59A08B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352122AbiHSQVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352273AbiHSQU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:20:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8813F109A38;
        Fri, 19 Aug 2022 09:01:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27A30B8280F;
        Fri, 19 Aug 2022 16:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62639C433D6;
        Fri, 19 Aug 2022 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924873;
        bh=WQmwcwkSAkbHRkR++9IsuWEB1OqnHSvSHLZ3n5R9+nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdzY0FRIxDATtznd01d8Gi29CJGgnec2OwsOG5vKR19xZycEPYstvvZxvj1PfY4Mc
         i1q7f2WgYCFV67jHZpk6rZkibpFZsojlrROxiUE6BbDRbnRLYdXGhUkqQkIAsYI2Ce
         0coq/Vj5neGTaOVqIB2INfHkk8bloX7WTQbtJPtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/545] intel_th: Fix a resource leak in an error handling path
Date:   Fri, 19 Aug 2022 17:41:19 +0200
Message-Id: <20220819153843.183637595@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 086c28ab7c5699256aced0049aae9c42f1410313 ]

If an error occurs after calling 'pci_alloc_irq_vectors()',
'pci_free_irq_vectors()' must be called as already done in the remove
function.

Fixes: 7b7036d47c35 ("intel_th: pci: Use MSI interrupt signalling")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20220705082637.59979-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/pci.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/pci.c b/drivers/hwtracing/intel_th/pci.c
index 817cdb29bbd8..d032c4de9ce6 100644
--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -100,8 +100,10 @@ static int intel_th_pci_probe(struct pci_dev *pdev,
 		}
 
 	th = intel_th_alloc(&pdev->dev, drvdata, resource, r);
-	if (IS_ERR(th))
-		return PTR_ERR(th);
+	if (IS_ERR(th)) {
+		err = PTR_ERR(th);
+		goto err_free_irq;
+	}
 
 	th->activate   = intel_th_pci_activate;
 	th->deactivate = intel_th_pci_deactivate;
@@ -109,6 +111,10 @@ static int intel_th_pci_probe(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	return 0;
+
+err_free_irq:
+	pci_free_irq_vectors(pdev);
+	return err;
 }
 
 static void intel_th_pci_remove(struct pci_dev *pdev)
-- 
2.35.1



