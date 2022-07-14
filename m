Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189FC57436B
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGNEeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiGNEeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476ED3AE74;
        Wed, 13 Jul 2022 21:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB85261EB7;
        Thu, 14 Jul 2022 04:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560ADC385A9;
        Thu, 14 Jul 2022 04:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772769;
        bh=LR5BiutOma/0B/U/EoBoNYPeDfUNWk7C5GzJ7/aCzNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LELWtHleY4LZgN5UnPFPe/q+szrcgmanKFeALFe4ClyFPe4XD6pK71bUCB/RXz4RQ
         mDgeALdKa2drFtW0kL8xruzXUQkcIX1tXbCulmh54OMZ6hyp0crEUQf/qyVmJVoqYz
         Xif70E18y5U20TB9btY0iGWXg2g+1FoIrff3FTi2DiSw1ZVNK85hPTmYCjJbBskMI5
         J008UyP9RR39OEyXWA5wV/mcvNQNJLAzBatN4BwtKEDz2I0aOz9RadCVr/iiVzewAd
         7SRxNSvrv8/x2qjRbrV86aL1FHiErFWVzORWmWRs5neApQcAz3qqr2NQwBy9B+XpKu
         X/9LokPFp1arw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Chris Egolf <cegolf@ugholf.net>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 14/15] nvme-pci: phison e16 has bogus namespace ids
Date:   Thu, 14 Jul 2022 00:25:39 -0400
Message-Id: <20220714042541.282175-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042541.282175-1-sashal@kernel.org>
References: <20220714042541.282175-1-sashal@kernel.org>
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

[ Upstream commit 73029c9b23cf1213e5f54c2b59efce08665199e7 ]

Add the quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216049
Reported-by: Chris Egolf <cegolf@ugholf.net>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3622c5c9515f..ce129655ef0a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3234,7 +3234,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
-- 
2.35.1

