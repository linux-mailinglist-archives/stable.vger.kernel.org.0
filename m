Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2468961F
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjBCKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbjBCKZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CE91043E
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:24:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CDDB61ECF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23579C433D2;
        Fri,  3 Feb 2023 10:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419888;
        bh=VvIdiigehAz4PxJOaDkEDsq4A8cHs3gn6LdfPo6Cieg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXASnaJhIOffszLkicu9Y/Laxb3Ig3UKN1zAzmC5HagA8U1ruiEmCrQ07GgF2fK6l
         +B64up77i3N/Pad4En6N9nREdNPJcGzK8HT8jXtNhOjteXNQ7vgLDzv3Uqn8Ko0Uql
         6KqgVcEoEvceSNL0ofEIAm+kZ3ATGE1xlwBgcvnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Andre Przywara <andre.przywara@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/134] EDAC/highbank: Fix memory leak in highbank_mc_probe()
Date:   Fri,  3 Feb 2023 11:11:56 +0100
Message-Id: <20230203101024.363844517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 61b76ec226af..19fba258ae10 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -174,8 +174,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
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
@@ -243,6 +245,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
+free:
 	edac_mc_free(mci);
 	return res;
 }
-- 
2.39.0



