Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC815553C6B
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355660AbiFUVBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355815AbiFUU7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC6D32EF6;
        Tue, 21 Jun 2022 13:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD53B81B30;
        Tue, 21 Jun 2022 20:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298FAC341C7;
        Tue, 21 Jun 2022 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844656;
        bh=8C6eUvmeIqf1eVhYlOTKQKW5QCSVOQr6XtnpsllgtdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgpdC/AD6uxsFuz67rAE8RnrwRWIz+RL2pZFFIbshe0bj7ZHtUxYa4Qf2cFpafqWq
         24XjsVrVmap/pVRwXtvBDkPNxKCczOQVdbvFx6xqV+JwBUqFDFzmy4qxgBui0H40ne
         EKtOLPgJ6KxVrove1GfBo5J2BelseGOjyr9UX8dU0zwjdxg/+2Vi+7+66fV4JjflWA
         vqfENURfxL4ymbU1SZL7F9EQCX+5WjVphHTuvRr2xQ5uL/Fo9EE8e05sUudAHmpjJ8
         UpCxDbUVmP0S7H9Blix5weowPaUIMlDo7Mq6X+CfIvGrm3ftntBMmK9n7oH/yqvQXg
         AoRYoWVlayEvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ning Wang <ningwang35@outlook.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 10/17] nvme-pci: avoid the deepest sleep state on ZHITAI TiPro7000 SSDs
Date:   Tue, 21 Jun 2022 16:50:33 -0400
Message-Id: <20220621205041.250426-10-sashal@kernel.org>
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

From: Ning Wang <ningwang35@outlook.com>

[ Upstream commit 6b961bce50e489186232cef51036ddb8d672bc3b ]

When ZHITAI TiPro7000 SSDs entered deepest power state(ps4)
it has the same APST sleep problem as Kingston A2000.
by chance the system crashes and displays the same dmesg info:

https://bugzilla.kernel.org/show_bug.cgi?id=195039#c65

As the Archlinux wiki suggest (enlat + exlat) < 25000 is fine
and my testing shows no system crashes ever since.
Therefore disabling the deepest power state will fix the APST sleep issue.

https://wiki.archlinux.org/title/Solid_state_drive/NVMe

This is the APST data from 'nvme id-ctrl /dev/nvme1'

NVME Identify Controller:
vid       : 0x1e49
ssvid     : 0x1e49
sn        : [...]
mn        : ZHITAI TiPro7000 1TB
fr        : ZTA32F3Y
[...]
ps    0 : mp:3.50W operational enlat:5 exlat:5 rrt:0 rrl:0
          rwt:0 rwl:0 idle_power:- active_power:-
ps    1 : mp:3.30W operational enlat:50 exlat:100 rrt:1 rrl:1
          rwt:1 rwl:1 idle_power:- active_power:-
ps    2 : mp:2.80W operational enlat:50 exlat:200 rrt:2 rrl:2
          rwt:2 rwl:2 idle_power:- active_power:-
ps    3 : mp:0.1500W non-operational enlat:500 exlat:5000 rrt:3 rrl:3
          rwt:3 rwl:3 idle_power:- active_power:-
ps    4 : mp:0.0200W non-operational enlat:2000 exlat:60000 rrt:4 rrl:4
          rwt:4 rwl:4 idle_power:- active_power:-

Signed-off-by: Ning Wang <ningwang35@outlook.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 78e382651198..9847a20f9623 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3375,6 +3375,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.35.1

