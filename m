Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7AE6E6397
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjDRMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjDRMl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF0A14461
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B34063303
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF5CC433EF;
        Tue, 18 Apr 2023 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821695;
        bh=AKW1dDCDd0AQBWu2Xp6du7/cxT3/7AFpBbRk2aR/Da0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxjSIxZBvQhAx0AMcZTc56MYyFt+EF6LppkuoOnMioS2+Q8JynYQZqPOsO+FFEGSC
         I17eav2ZnXIl9OEt+J32AMeI8GDd7OuU916bdCbSH7nULcTNhGNQVFeWpJXhRdVqiM
         iPO5RoUiRF6oUd2VdbmKnwE4Pyfw/uiantI5UweY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ning Wang <ningwang35@outlook.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 78/91] nvme-pci: avoid the deepest sleep state on ZHITAI TiPro7000 SSDs
Date:   Tue, 18 Apr 2023 14:22:22 +0200
Message-Id: <20230418120308.265345722@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e0f0c9aa9391a..7b0331848664d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3390,6 +3390,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



