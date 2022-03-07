Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7716B4CF7A1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238042AbiCGJqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiCGJpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:45:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC7C65432;
        Mon,  7 Mar 2022 01:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC64F612C9;
        Mon,  7 Mar 2022 09:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4053C340F3;
        Mon,  7 Mar 2022 09:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646103;
        bh=ZRudVY4cCl8/MQQO5V8VjUC2mo62hikaH/uo7E/qylE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuQMm6qa3dqfBS5uEaTT7yYFViHRx2O/T5d7UIL8aYlmRFDHC0E68bM8mKwWhXjsb
         7YOeUPgUfDaCWigEJaZIfZTqV/rcPVQmUyv9u0ubH7YWoRGkw8KL+Q3Osmt86HaHLt
         n0y5l5NG1+XIR4pqqhqUU+Y//dBxSTzp7BuPXxUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Pallotta <jmpallotta@gmail.com>,
        Kelvin Cao <kelvin.cao@microchip.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/262] ntb_hw_switchtec: Fix pff ioread to read into mmio_part_cfg_all
Date:   Mon,  7 Mar 2022 10:17:08 +0100
Message-Id: <20220307091704.855171721@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



