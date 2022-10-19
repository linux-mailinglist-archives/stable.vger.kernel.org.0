Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBF5604026
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiJSJnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiJSJmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8BCD73F0;
        Wed, 19 Oct 2022 02:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0B7617FB;
        Wed, 19 Oct 2022 09:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13464C433C1;
        Wed, 19 Oct 2022 09:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170916;
        bh=Wn3oSxO3heTPfc3NTmNAvwL+9w/ee0D9B9DE8PlDHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvCILIrPnb7zHIYGP+v/Ktt27NvAoudo9I76oee7foDhDrJAPVVBavazlgg4HiM1d
         TADpQ+SZ8pKaWqNk3DH1AXmnZrdhk8w2UBu6fZ3Ro0OppEi0TXafGrD7cIt5lbHbVm
         cf42O33UQdHodtkKOcSW3Z69AfqLbKKeq7F3BF5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Joel Stanley <joel@jms.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 835/862] fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe
Date:   Wed, 19 Oct 2022 10:35:22 +0200
Message-Id: <20221019083326.777737679@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



