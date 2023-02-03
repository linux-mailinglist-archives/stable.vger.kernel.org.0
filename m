Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2C689547
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBCKSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjBCKRx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:17:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE07C9E9DF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B9BB82A6A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EDBC4339B;
        Fri,  3 Feb 2023 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419457;
        bh=0YPwNPiOFEzX4+43YB82x9sDmQ4Vka+SLvGPPPgIAFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoJnJBJ3fcsUJ98MFEw2f67hY0dga5C0tWPvjeOc73pk+7FqMOJ7wZ8GkhC89r6+s
         EoFl7dvs3AHV9OoHpuhhN48xLuIc0Z5I+jlcVHR2WdAYqzA5kCHaOj+C7tW1w6y+iq
         chVXmPGHQsUcZKzntVuDdIQFi1aVHOPzjMhO/Wtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Andre Przywara <andre.przywara@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/80] EDAC/highbank: Fix memory leak in highbank_mc_probe()
Date:   Fri,  3 Feb 2023 11:11:58 +0100
Message-Id: <20230203101015.447558368@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e7a293658c20a7945014570e1921bf7d25d68a36 ]

When devres_open_group() fails, it returns -ENOMEM without freeing memory
allocated by edac_mc_alloc().

Call edac_mc_free() on the error handling path to avoid a memory leak.

  [ bp: Massage commit message. ]

Fixes: a1b01edb2745 ("edac: add support for Calxeda highbank memory controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20221229054825.1361993-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/highbank_mc_edac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 6092e61be605..bcf41601a977 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -185,8 +185,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	drvdata = mci->pvt_info;
 	platform_set_drvdata(pdev, mci);
 
-	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
+		res = -ENOMEM;
+		goto free;
+	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -254,6 +256,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
+free:
 	edac_mc_free(mci);
 	return res;
 }
-- 
2.39.0



