Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1F5FD20D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJMBAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiJMBA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BDB129770;
        Wed, 12 Oct 2022 17:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB45B81CD4;
        Thu, 13 Oct 2022 00:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FCEC433C1;
        Thu, 13 Oct 2022 00:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620693;
        bh=oBBHYhW7o8DZRzw1fv/Etpl+SCeiAJ40Ubf4Pt1UoXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qm9PyiEgtv4u7BHVBZox5DlTsClmQZrei92rMtqVTPnsv97we0yPM3Y96gOggYg8D
         cfBAWkjk9ppVLALaaNq1Kfw9DslGXUWyADQozP0fLBZqXwuoK3Icsvhuy9m54sgzmr
         KPZlYqbNiooLqXUr+IbnxkK/fYMbjXU/IHvj6b1zYgpkNr7YgN0ThRkzRqq8Upf/0X
         OBvbBtmW13vEuGStYrqjKvfWGpAQyK+3QsDOaHua84HAQqoX4auft5HYZ85+dAKDif
         knwx2BfGfC66FFnwekLBWHlbR0F0dKtZakxEResCVuyFUEo9ln/ujsOJjxFO/P4nlW
         yKGh2OFZJCJag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        jk@ozlabs.org, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 31/33] fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe
Date:   Wed, 12 Oct 2022 20:23:30 -0400
Message-Id: <20221013002334.1894749-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 182d98e00e4745fe253cb0c24c63bbac253464a2 ]

of_parse_phandle returns node pointer with refcount incremented, use
of_node_put() on it when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Link: https://lore.kernel.org/r/20220407085911.2491719-1-lv.ruyi@zte.com.cn
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-ast-cf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/fsi/fsi-master-ast-cf.c b/drivers/fsi/fsi-master-ast-cf.c
index 70c03e304d6c..ae27ea30fe2d 100644
--- a/drivers/fsi/fsi-master-ast-cf.c
+++ b/drivers/fsi/fsi-master-ast-cf.c
@@ -1325,12 +1325,14 @@ static int fsi_master_acf_probe(struct platform_device *pdev)
 		}
 		master->cvic = devm_of_iomap(&pdev->dev, np, 0, NULL);
 		if (IS_ERR(master->cvic)) {
+			of_node_put(np);
 			rc = PTR_ERR(master->cvic);
 			dev_err(&pdev->dev, "Error %d mapping CVIC\n", rc);
 			goto err_free;
 		}
 		rc = of_property_read_u32(np, "copro-sw-interrupts",
 					  &master->cvic_sw_irq);
+		of_node_put(np);
 		if (rc) {
 			dev_err(&pdev->dev, "Can't find coprocessor SW interrupt\n");
 			goto err_free;
-- 
2.35.1

