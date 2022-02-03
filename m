Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496744A8DBA
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354534AbiBCUcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354535AbiBCUbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EECC061796;
        Thu,  3 Feb 2022 12:31:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 544FC61A6A;
        Thu,  3 Feb 2022 20:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40C2C340F3;
        Thu,  3 Feb 2022 20:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920301;
        bh=E/9jBRbIyyEtc+13I+rJm5xa1JZLQM7ZW8OBG5cbk8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlYMsQFquu/XpCa93XXMAa8BJNGOcWhHcGusvAMmPorNEzTZLu12/U5Pg3eLtcWVu
         A3vKTTG+j+5a03xfexgD1vO6zrlun+IMRoAbEX0cpaK5bU76Xkt5LJdjVSzg+NIh9s
         K3HsTaxE/V6FloREdgz35WrOFqih8UxL5y48QwCEzgs4I1EsmUFRArls2h7LjIN0L5
         YuZRPY8VnAlcR2Wum3WgZh0B3/tk4S8cCZMJf8dgPMThyeZMda+QEjRPEoqim5K7+r
         JBZImMZi9SVMZ/o2GOonH4+qXDKOkQjeOlbeOs5lPS7BYMQT7D+7wtvCkfl4MlVxxr
         MppV3FQKFZ+BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Zheng <wu.zheng@intel.com>, Ye Jinhe <jinhe.ye@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, axboe@fb.com,
        sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 43/52] nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs
Date:   Thu,  3 Feb 2022 15:29:37 -0500
Message-Id: <20220203202947.2304-43-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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

