Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C63664876
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbjAJSLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbjAJSKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E96865FD
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08466186D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43A7C433EF;
        Tue, 10 Jan 2023 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374162;
        bh=LolvUDwdmMy6uXD2MfeDzzgWrtgUtC7qWzba5APy6ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y382+W7bAT98gLXJIm96vFPcT05NB61Ose8x2cWtn1HOuSSz46uO9WsCf1jTf2GXl
         VHC5rCzWSpAAww/lpXhXiYCb0YOsCvQqiuv65zpM+p3FD5JprbpL1xhyVyGAOlRId9
         JTOkwC98LG8feNzmhP7aDR6P/eb4dFSbXkXuvuls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 038/148] bnxt_en: Fix HDS and jumbo thresholds for RX packets
Date:   Tue, 10 Jan 2023 19:02:22 +0100
Message-Id: <20230110180018.429858414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit a056ebcc30e2f78451d66f615d2f6bdada3e6438 ]

The recent XDP multi-buffer feature has introduced regressions in the
setting of HDS and jumbo thresholds.  HDS was accidentally disabled in
the nornmal mode without XDP.  This patch restores jumbo HDS placement
when not in XDP mode.  In XDP multi-buffer mode, HDS should be disabled
and the jumbo threshold should be set to the usable page size in the
first page buffer.

Fixes: 32861236190b ("bnxt: change receive ring space parameters")
Reviewed-by: Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be82464e1a77..1b38295254e2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5371,15 +5371,16 @@ static int bnxt_hwrm_vnic_set_hds(struct bnxt *bp, u16 vnic_id)
 	req->flags = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_JUMBO_PLACEMENT);
 	req->enables = cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_JUMBO_THRESH_VALID);
 
-	if (BNXT_RX_PAGE_MODE(bp) && !BNXT_RX_JUMBO_MODE(bp)) {
+	if (BNXT_RX_PAGE_MODE(bp)) {
+		req->jumbo_thresh = cpu_to_le16(bp->rx_buf_use_size);
+	} else {
 		req->flags |= cpu_to_le32(VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV4 |
 					  VNIC_PLCMODES_CFG_REQ_FLAGS_HDS_IPV6);
 		req->enables |=
 			cpu_to_le32(VNIC_PLCMODES_CFG_REQ_ENABLES_HDS_THRESHOLD_VALID);
+		req->jumbo_thresh = cpu_to_le16(bp->rx_copy_thresh);
+		req->hds_threshold = cpu_to_le16(bp->rx_copy_thresh);
 	}
-	/* thresholds not implemented in firmware yet */
-	req->jumbo_thresh = cpu_to_le16(bp->rx_copy_thresh);
-	req->hds_threshold = cpu_to_le16(bp->rx_copy_thresh);
 	req->vnic_id = cpu_to_le32(vnic->fw_vnic_id);
 	return hwrm_req_send(bp, req);
 }
-- 
2.35.1



