Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A7553C6E
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355668AbiFUVAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355627AbiFUU6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E43207D;
        Tue, 21 Jun 2022 13:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D9BB81B31;
        Tue, 21 Jun 2022 20:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336FDC341C4;
        Tue, 21 Jun 2022 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844650;
        bh=JeBr1bFqE2A6C5zJTr/9zSU6USgH72iHiRljlSjX1VE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQiEhxgm2O9Lnv7mVkec0arstDyR/qZXK8cXEyCJEVHCyL1bw5DU2tGoC6ATc6fIL
         uj0racNchQ07lSaEmHxvjxgPqkxxpYvHguubeJFkHcv/hgYNi7f9FC6wX01IAIIR67
         sniEZM39DVupRAvkfw/IuPzuMvoBtpGaN8JD1xGmj1BRbEOcU9QftACmvwZ55Ku13C
         w7q4Q732vDdsm4l9p7x+NFK28KsOwBUglzfTguddGhFrYTzyJkHfXyS3M3uafPrey3
         y/3DEQFz9ngjsIT7Xazy9874GbDeVB21agJ9lUDBgmy+botbhoOehNHN0hGPN3aeov
         rsMnmMptQP8Xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/17] nvme-pci: add trouble shooting steps for timeouts
Date:   Tue, 21 Jun 2022 16:50:28 -0400
Message-Id: <20220621205041.250426-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4641a8e6e145f595059e695f0f8dbbe608134086 ]

Many users have encountered IO timeouts with a CSTS value of 0xffffffff,
which indicates a failure to read the register. While there are various
potential causes for this observation, faulty NVMe APST has been the
culprit quite frequently. Add the recommended troubleshooting steps in
the error output when this condition occurs.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3ddd24a42043..e0accbf40f49 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1241,6 +1241,14 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 		dev_warn(dev->ctrl.device,
 			 "controller is down; will reset: CSTS=0x%x, PCI_STATUS read failed (%d)\n",
 			 csts, result);
+
+	if (csts != ~0)
+		return;
+
+	dev_warn(dev->ctrl.device,
+		 "Does your device have a faulty power saving mode enabled?\n");
+	dev_warn(dev->ctrl.device,
+		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off\" and report a bug\n");
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
-- 
2.35.1

