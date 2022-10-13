Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8715FD28A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJMB10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJMB1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF801903B;
        Wed, 12 Oct 2022 18:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C76616E4;
        Thu, 13 Oct 2022 00:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BC8C433B5;
        Thu, 13 Oct 2022 00:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620602;
        bh=Wn3oSxO3heTPfc3NTmNAvwL+9w/ee0D9B9DE8PlDHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO4Ed1nfWG4tSJFyE7rrVaLDbY2U31qWTKIAOJNUAeYt7C6aCUz3uQsH3d7D0GrnY
         kUZf4ZFA+1x2QUrYXU1IH9aHB37rS8ZXwev1yC1yvj4kR2UWLTzq/5DdLKnToPAzTL
         CLIolZeF8pveJKYoaqmElzW3nrVioZoPhK5S3eH4f11RfIFQdbX4TL5vxYrF2CXo8w
         YimQk2iGv9Qjkqdaoc85qRet7jEhmsw66Unw5PcL/xxc8uRduITxcDoTF3dZOp6NGg
         VwAym/uAkcnWqasOxMd/BUFvILzKyQyKze9yjEhzgQ9V8M0Ab8yez9NA0z6JM6LqdE
         aO27/BeshHqOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        jk@ozlabs.org, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 44/47] fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe
Date:   Wed, 12 Oct 2022 20:21:19 -0400
Message-Id: <20221013002124.1894077-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
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
index 24292acdbaf8..5f608ef8b53c 100644
--- a/drivers/fsi/fsi-master-ast-cf.c
+++ b/drivers/fsi/fsi-master-ast-cf.c
@@ -1324,12 +1324,14 @@ static int fsi_master_acf_probe(struct platform_device *pdev)
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

