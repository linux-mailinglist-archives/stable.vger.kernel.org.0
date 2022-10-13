Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A742F5FCFC5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJMAWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiJMAVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:21:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AA512345D;
        Wed, 12 Oct 2022 17:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0022EB81CC2;
        Thu, 13 Oct 2022 00:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1927C433D7;
        Thu, 13 Oct 2022 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620301;
        bh=Wn3oSxO3heTPfc3NTmNAvwL+9w/ee0D9B9DE8PlDHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/uDTVDsEe2W/TcRhBROUUuUVP/3aeQPjQWo1NP9F7MhmP4Zxv7n1EfJmcgKHBiiD
         1Oy15gLd0N1t4x9lKWvd06kRR2DXunnOes6LrWTXt84kLkr6OXm/sgYrVQr9nHrysI
         KZw4Z4qWiRiXeaC1h0cB06GGQQF7vkLGtlV9eqY7kymi/bO8P/GqNDQkW68+vvoXwF
         xlUNrdvEq8aMbnmwEVARTH6HFgrcIcGp8Sg75Gy/N7uznswFybypBdXOJVDl3z3vWb
         Kj1ece4z9V1LPUZ0aICbeacyGZOUE+SKMTPQ+8pReyj2o1pMl2mec4nbqSculnCTm8
         AiffUMvaJxNiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>,
        jk@ozlabs.org, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 62/67] fsi: master-ast-cf: Fix missing of_node_put in fsi_master_acf_probe
Date:   Wed, 12 Oct 2022 20:15:43 -0400
Message-Id: <20221013001554.1892206-62-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
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

