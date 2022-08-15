Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2923159506D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiHPEmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiHPEka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EB637187;
        Mon, 15 Aug 2022 13:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02201B81197;
        Mon, 15 Aug 2022 20:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B5EC433C1;
        Mon, 15 Aug 2022 20:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595507;
        bh=49uVIo5yxX6YOHCXdzDZ21EmAzU5bpz2xA4aVGHhjq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuZuVQvaLkJcxQ6wSjzb9zomn6MpEP4N29Ktpos8iUoLYX+hOIUb7gZ2GibGLJLcS
         Bz5i+JU7YncpeQN3tEBggJeDrb6/REsYphURapA4BxelhD9jQg3olChHuSndKXEvQC
         2iM39EmHuXUeNI70HTwrWXBoShb2MNckrSWrOhS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0786/1157] intel_th: Fix a resource leak in an error handling path
Date:   Mon, 15 Aug 2022 20:02:22 +0200
Message-Id: <20220815180510.930699398@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 7da4f298ed01..fcd0aca75007 100644
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



