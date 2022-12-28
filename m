Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D577F657D23
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiL1Pju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiL1Pjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FFC167C4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F336154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C06C433D2;
        Wed, 28 Dec 2022 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241987;
        bh=+2dJZuyYiHi5jVntV7hCl5NkvZc/l+kFFIZ04IK9BBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaDf2QmVGDRKm6lkk1pHltXMgRXW/75yEwO8Xx9+7wyNtTDCmp62XwPAI9mCSDRmn
         Plt1YE6gKoGfOVpT6/XyJeRWAYmRb118vXfm/WCA/+MDMbmJvyErE9Y8pAxOrzRzxL
         ZUs8fBCtOoKkuLIwjEZGn8hzOB9iaQgZemu1vj6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/731] iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()
Date:   Wed, 28 Dec 2022 15:40:57 +0100
Message-Id: <20221228144312.483452430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 73f5fc5f884ad0c5f7d57f66303af64f9f002526 ]

The fsl_pamu_probe() returns directly when create_csd() failed, leaving
irq and memories unreleased.
Fix by jumping to error if create_csd() returns error.

Fixes: 695093e38c3e ("iommu/fsl: Freescale PAMU driver and iommu implementation.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221121082022.19091-1-yuancan@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/fsl_pamu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index fc38b1fba7cf..bb5d253188a1 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -865,7 +865,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
 		if (ret) {
 			dev_err(dev, "could not create coherence subdomain\n");
-			return ret;
+			goto error;
 		}
 	}
 
-- 
2.35.1



