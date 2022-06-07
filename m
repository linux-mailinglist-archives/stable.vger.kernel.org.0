Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906B95411F0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356678AbiFGTnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356727AbiFGTjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2BFC4DA;
        Tue,  7 Jun 2022 11:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE4FC60B25;
        Tue,  7 Jun 2022 18:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE64DC385A2;
        Tue,  7 Jun 2022 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625659;
        bh=8fyaHLfs66JSD8DWARG4Vmw9VaXoP4pQwZnrSrmzxME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlIQoSOdb1elOutsRmgBVSIgMJDte6H3WnaQRKZhsIcSOXyR8doOU04aFyZS5J9FQ
         yeg85072GD9/OH6pmmR/8X8pV2Ret7Q+zpDDOX52IE/irYcUnb5XNdmIttPTziL26v
         0Cv9TPAUx1+6lYOs2gTuyeD62AFb2bQoNXNlFIGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 097/772] scsi: ufs: Use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()
Date:   Tue,  7 Jun 2022 18:54:49 +0200
Message-Id: <20220607164951.906934641@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit 75b8715e20a20bc7b4844835e4035543a2674200 ]

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync() and
pm_runtime_put_noidle(). This change is just to simplify the code, no
actual functional changes.

Link: https://lore.kernel.org/r/20220420090353.2588804-1-chi.minghao@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ti-j721e-ufs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index eafe0db98d54..122d650d0810 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -29,11 +29,9 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 		return PTR_ERR(regbase);
 
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
 		goto disable_pm;
-	}
 
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
-- 
2.35.1



