Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F90579C1C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbiGSMgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbiGSMfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:35:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99002ADE;
        Tue, 19 Jul 2022 05:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC16DB81B31;
        Tue, 19 Jul 2022 12:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142F2C341C6;
        Tue, 19 Jul 2022 12:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232828;
        bh=rpiQO8Sjibs+LwSJCBHBCpxHAgLFPuQs1Ttf3a7TM9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BojNICCq/qnoEsqEsLnrWQJ1yEh6pPjECY8FwDvGfUA62Yi5Olto1FGr2YhUVOWAx
         AMJbRWuzVj4T+DnYHPx+IeJ0uIrtsTXc+AQF3JhjQi9AvE9zBrqfKxDwF9aGaWjWxs
         aRdeTiK4RKY1xBkXfGHoyp7s7VKOMLOIB0YGF+64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/167] bnxt_en: Fix bnxt_reinit_after_abort() code path
Date:   Tue, 19 Jul 2022 13:53:32 +0200
Message-Id: <20220719114704.316223780@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 4279414bff8af9898e8c53ae6c5bc17f68ad67b7 ]

bnxt_reinit_after_abort() is called during ifup when a previous
FW reset sequence has aborted or a previous ifup has failed after
detecting FW reset.  In all cases, it is safe to assume that a
previous FW reset has completed and the driver may not have fully
reinitialized.

Prior to this patch, it is assumed that the
FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE flag will always be
set by the firmware in bnxt_hwrm_if_change().  This may not be true if
the driver has already attempted to register with the firmware.  The
firmware may not set the RESET_DONE flag again after the driver has
registered, assuming that the driver has seen the flag already.

Fix it to always go through the FW reset initialization path if
the BNXT_STATE_FW_RESET_DET flag is set.  This flag is always set
by the driver after successfully going through bnxt_reinit_after_abort().

Fixes: 6882c36cf82e ("bnxt_en: attempt to reinitialize after aborted reset")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cb5314945589..6962abe2358b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9806,7 +9806,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)
 		resc_reinit = true;
-	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
+	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE ||
+	    test_bit(BNXT_STATE_FW_RESET_DET, &bp->state))
 		fw_reset = true;
 	else if (bp->fw_health && !bp->fw_health->status_reliable)
 		bnxt_try_map_fw_health_reg(bp);
-- 
2.35.1



