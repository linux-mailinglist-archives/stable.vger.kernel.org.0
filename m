Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD44B5AAFA2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiIBMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiIBMkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ADAE68C6;
        Fri,  2 Sep 2022 05:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07CA5B82A9B;
        Fri,  2 Sep 2022 12:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B10AC433D6;
        Fri,  2 Sep 2022 12:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121779;
        bh=ra/Uw8WmSXQfY+fMpLEKrLdp7DcB7dUfee/hSdOc/sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFYiwa/gVl1HeFpFDOvuPKbDs+dM9Ws1JF1lHhm/23QHyzPJP5byls2I2zALviarR
         200irtTrWrJQArRcHwndksDibgAjv6Vl7W4d9Wyr9RZKmLyi6zgj9DDIiq+sTfnMf5
         cnCSy22fi50bRO5QlkqpOYsIQv3U/mYdCkZL5pZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/77] bnxt_en: fix NQ resource accounting during vf creation on 57500 chips
Date:   Fri,  2 Sep 2022 14:18:30 +0200
Message-Id: <20220902121404.354208596@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 09a89cc59ad67794a11e1d3dd13c5b3172adcc51 ]

There are 2 issues:

1. We should decrement hw_resc->max_nqs instead of hw_resc->max_irqs
   with the number of NQs assigned to the VFs.  The IRQs are fixed
   on each function and cannot be re-assigned.  Only the NQs are being
   assigned to the VFs.

2. vf_msix is the total number of NQs to be assigned to the VFs.  So
   we should decrement vf_msix from hw_resc->max_nqs.

Fixes: b16b68918674 ("bnxt_en: Add SR-IOV support for 57500 chips.")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 452be9749827a..3434ad6824a05 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -597,7 +597,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		hw_resc->max_stat_ctxs -= le16_to_cpu(req.min_stat_ctx) * n;
 		hw_resc->max_vnics -= le16_to_cpu(req.min_vnics) * n;
 		if (bp->flags & BNXT_FLAG_CHIP_P5)
-			hw_resc->max_irqs -= vf_msix * n;
+			hw_resc->max_nqs -= vf_msix;
 
 		rc = pf->active_vfs;
 	}
-- 
2.35.1



