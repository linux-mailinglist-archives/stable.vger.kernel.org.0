Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D680659A1F6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352163AbiHSQ0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352718AbiHSQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927884DB41;
        Fri, 19 Aug 2022 09:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47D4761698;
        Fri, 19 Aug 2022 16:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C8FC433C1;
        Fri, 19 Aug 2022 16:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924998;
        bh=njgtn/5vil/3SWQGkDVgSDn7wCT+1DXns7cLGzDpX1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKJUuOHuy753EzjgGzx10A5Am9hf6GW2HFoJBYPuxgN0YbOtT1Z5zQdKz88zmGCVc
         W9mMnPY/vCbetvxRaP3ukMlnndr4/cwjgOlIXZBqXKpRdqySiedn6FyjZ6sd0JJ0P0
         3dGArlXGEjKMNG0yaLyume8en7szDuq3m8Cn7oMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Robert Richter <rric@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/545] mmc: cavium-thunderx: Add of_node_put() when breaking out of loop
Date:   Fri, 19 Aug 2022 17:41:53 +0200
Message-Id: <20220819153844.746624238@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 7ee480795e41db314f2c445c65ed854a5d6e8e32 ]

In thunder_mmc_probe(), we should call of_node_put() when breaking
out of for_each_child_of_node() which has increased and decreased
the refcount during each iteration.

Fixes: 166bac38c3c5 ("mmc: cavium: Add MMC PCI driver for ThunderX SOCs")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Robert Richter <rric@kernel.org>
Link: https://lore.kernel.org/r/20220719095216.1241601-2-windhl@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/cavium-thunderx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/cavium-thunderx.c b/drivers/mmc/host/cavium-thunderx.c
index 76013bbbcff3..202b1d6da678 100644
--- a/drivers/mmc/host/cavium-thunderx.c
+++ b/drivers/mmc/host/cavium-thunderx.c
@@ -142,8 +142,10 @@ static int thunder_mmc_probe(struct pci_dev *pdev,
 				continue;
 
 			ret = cvm_mmc_of_slot_probe(&host->slot_pdev[i]->dev, host);
-			if (ret)
+			if (ret) {
+				of_node_put(child_node);
 				goto error;
+			}
 		}
 		i++;
 	}
-- 
2.35.1



