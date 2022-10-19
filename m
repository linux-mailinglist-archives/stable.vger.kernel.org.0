Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401206041EB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiJSKuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiJSKtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:49:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E511A979;
        Wed, 19 Oct 2022 03:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D59B824B4;
        Wed, 19 Oct 2022 09:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F9C433D6;
        Wed, 19 Oct 2022 09:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170676;
        bh=YHvVHIJX2HPHSLT4eGLhe20mkccL+miqWFxNvBZc7ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRaxY+nTAH1QeTJ8BG6T1OfZoC/RXEP5s8sVEThS9re9LYkrXGm+QEP6MucfvBNVF
         oSbj1/Ob+x/yAOJhIDGerHfwvyHS6vidGqFLCMEwaIIyRh5om08CoYfH1tKUfe8RoF
         KipfUZlf3+paDM3JYemLcfgKWAnCoBH0L1X/M47c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 711/862] bnxt_en: replace reset with config timestamps
Date:   Wed, 19 Oct 2022 10:33:18 +0200
Message-Id: <20221019083321.353699696@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 8db3d514e96715c897fe793c4d5fc0fd86aca517 ]

Any change to the hardware timestamps configuration triggers nic restart,
which breaks transmition and reception of network packets for a while.
But there is no need to fully restart the device because while configuring
hardware timestamps. The code for changing configuration runs after all
of the initialisation, when the NIC is actually up and running. This patch
changes the code that ioctl will only update configuration registers and
will not trigger carrier status change, but in case of timestamps for
all rx packetes it fallbacks to close()/open() sequnce because of
synchronization issues in the hardware. Tested on BCM57504.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220922191038.29921-1-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 8e316367f6ce..2132ce63193c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -505,9 +505,13 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 	ptp->tstamp_filters = flags;
 
 	if (netif_running(bp->dev)) {
-		rc = bnxt_close_nic(bp, false, false);
-		if (!rc)
-			rc = bnxt_open_nic(bp, false, false);
+		if (ptp->rx_filter == HWTSTAMP_FILTER_ALL) {
+			rc = bnxt_close_nic(bp, false, false);
+			if (!rc)
+				rc = bnxt_open_nic(bp, false, false);
+		} else {
+			bnxt_ptp_cfg_tstamp_filters(bp);
+		}
 		if (!rc && !ptp->tstamp_filters)
 			rc = -EIO;
 	}
-- 
2.35.1



