Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A2949A4DF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387606AbiAYAFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1841162AbiAXX2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB87C075951;
        Mon, 24 Jan 2022 13:34:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F88D61305;
        Mon, 24 Jan 2022 21:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAC8C340E4;
        Mon, 24 Jan 2022 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060041;
        bh=ZRudVY4cCl8/MQQO5V8VjUC2mo62hikaH/uo7E/qylE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQDubghmpfXcXk7zXNdKok0fI7mDKQpULL/tCqin1osYycLXS0Tr5MrDumPuVYclA
         CO97lsOmMeLAEnZNzFV717zS1xNzqnQ9MX/6nwymOhG7mSYoJ9EBZIxIRiLdhOKDwP
         PT4wSmodJw+umF4XDamUtAmRPtHKyF39qcN0L+xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Pallotta <jmpallotta@gmail.com>,
        Kelvin Cao <kelvin.cao@microchip.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0819/1039] ntb_hw_switchtec: Fix pff ioread to read into mmio_part_cfg_all
Date:   Mon, 24 Jan 2022 19:43:28 +0100
Message-Id: <20220124184152.831999577@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Pallotta <jmpallotta@gmail.com>

[ Upstream commit 32c3d375b0ed84b6acb51ae5ebef35ff0d649d85 ]

Array mmio_part_cfg_all holds the partition configuration of all
partitions, with partition number as index. Fix this by reading into
mmio_part_cfg_all for pff.

Fixes: 0ee28f26f378 ("NTB: switchtec_ntb: Add link management")
Signed-off-by: Jeremy Pallotta <jmpallotta@gmail.com>
Signed-off-by: Kelvin Cao <kelvin.cao@microchip.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 4c6eb61a6ac62..6603c77c0a848 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -419,8 +419,8 @@ static void switchtec_ntb_part_link_speed(struct switchtec_ntb *sndev,
 					  enum ntb_width *width)
 {
 	struct switchtec_dev *stdev = sndev->stdev;
-
-	u32 pff = ioread32(&stdev->mmio_part_cfg[partition].vep_pff_inst_id);
+	u32 pff =
+		ioread32(&stdev->mmio_part_cfg_all[partition].vep_pff_inst_id);
 	u32 linksta = ioread32(&stdev->mmio_pff_csr[pff].pci_cap_region[13]);
 
 	if (speed)
-- 
2.34.1



