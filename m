Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18995FD1B5
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiJMAov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiJMAo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683F11BDB3;
        Wed, 12 Oct 2022 17:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A019B81CF3;
        Thu, 13 Oct 2022 00:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127A9C43143;
        Thu, 13 Oct 2022 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620647;
        bh=PyVuP224LTfOgKeY7PGhWDcswJIc+RIZ/ujbhn1tRm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5/dTYUxizyF7NvyZyQZ75mgeAGMOMiw3CV3AtuuMXVEkRfRwgu1MDvKQH9y1CvpX
         gnQTWkLQpjbWvp8zXGaokA2a/qcF6s4siQn14jnQ+YNdGKgNhdIzuLU7b+IhpAVhdz
         rSzOT6ZlLTr5Rs5/h8EgVdjVSKwtcT6K8PSB0kVjl//Dj+Y3TpcMjTmscs6CHzyzS/
         DxzYFqaQuE2YxAn1fpcBgSc3SO5rj9p+zVulbCPjJhNLdcxSYU0THlO23BQzQlVI94
         AYJWgCiz/kMcmiUmGV0aAjkG05wqsDyzFNFvkcD8/uPpewnB9qjSG3EUv0dz90/gMi
         QCnSn2XmQEK3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, Michael.Hennerich@analog.com,
        sre@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/33] power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()
Date:   Wed, 12 Oct 2022 20:23:10 -0400
Message-Id: <20221013002334.1894749-11-sashal@kernel.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9d47e01b9d807808224347935562f7043a358054 ]

ADP5061_CHG_STATUS_1_CHG_STATUS is masked with 0x07, which means a length
of 8, but adp5061_chg_type array size is 4, may end up reading 4 elements
beyond the end of the adp5061_chg_type[] array.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/adp5061.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/adp5061.c b/drivers/power/supply/adp5061.c
index 003557043ab3..daee1161c305 100644
--- a/drivers/power/supply/adp5061.c
+++ b/drivers/power/supply/adp5061.c
@@ -427,11 +427,11 @@ static int adp5061_get_chg_type(struct adp5061_state *st,
 	if (ret < 0)
 		return ret;
 
-	chg_type = adp5061_chg_type[ADP5061_CHG_STATUS_1_CHG_STATUS(status1)];
-	if (chg_type > ADP5061_CHG_FAST_CV)
+	chg_type = ADP5061_CHG_STATUS_1_CHG_STATUS(status1);
+	if (chg_type >= ARRAY_SIZE(adp5061_chg_type))
 		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
 	else
-		val->intval = chg_type;
+		val->intval = adp5061_chg_type[chg_type];
 
 	return ret;
 }
-- 
2.35.1

