Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3724B4B0B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbiBNKYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:24:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347041AbiBNKXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56EC6CA5D;
        Mon, 14 Feb 2022 01:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82A2960F25;
        Mon, 14 Feb 2022 09:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644EDC340E9;
        Mon, 14 Feb 2022 09:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832580;
        bh=E/9jBRbIyyEtc+13I+rJm5xa1JZLQM7ZW8OBG5cbk8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIXF5GDAM2R/BtpeqtotWNV6bpwqu0zRUNrz3RYmzNToPnSUGGU5Ps4Vg5NxuLbni
         GaoD8XY/Z92F5rc169M5yET94RsYFtCrH4EMCDvirUsXYgOKFWMm9IiVkHcWfqYIdz
         XGYt2vbxxG05J8nVwhsjL7q5a4IGJdDi300DVaZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Wu <wu.zheng@intel.com>,
        Ye Jinhe <jinhe.ye@intel.com>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 059/203] nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs
Date:   Mon, 14 Feb 2022 10:25:03 +0100
Message-Id: <20220214092512.259122874@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Zheng <wu.zheng@intel.com>

[ Upstream commit 25e58af4be412d59e056da65cc1cefbd89185bd2 ]

The Intel P4500/P4600 SSDs do not report a subsystem NQN despite claiming
compliance to a standards version where reporting one is required.

Add the IGNORE_DEV_SUBNQN quirk to not fail the initialization of a
second such SSDs in a system.

Signed-off-by: Zheng Wu <wu.zheng@intel.com>
Signed-off-by: Ye Jinhe <jinhe.ye@intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ca2ee806d74b6..953ea3d5d4bfb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3326,7 +3326,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x0a54),	/* Intel P4500/P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DEALLOCATE_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_VDEVICE(INTEL, 0x0a55),	/* Dell Express Flash P4600 */
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
 				NVME_QUIRK_DEALLOCATE_ZEROES, },
-- 
2.34.1



