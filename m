Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46B15A488D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiH2LMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiH2LLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:11:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042C36BD6F;
        Mon, 29 Aug 2022 04:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0BFFB80EFE;
        Mon, 29 Aug 2022 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F29C433D6;
        Mon, 29 Aug 2022 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771147;
        bh=iNS9lmGg7cs0ns3adudyXzKIqRSAekCu57/qbPqQYDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFzLzp57ToYjkc/0O8Lxwhm8IUc6sESRoFHxU4W4UI7oJJvqdDg3uV6KXXaHCWOaC
         Jh4xu6jwVX3BqHBRkFSOQXwc2eCvNQp/8hyeE4L6iQ5kF8CZdr3UQfbJlFW9pVVkDz
         VtA1zPfkSPhBv94R5cvC5MWPnK2yDacCzq1HmhQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/86] bnxt_en: fix NQ resource accounting during vf creation on 57500 chips
Date:   Mon, 29 Aug 2022 12:58:57 +0200
Message-Id: <20220829105757.828198418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index 23b80aa171dd0..819f9df9425c6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -599,7 +599,7 @@ static int bnxt_hwrm_func_vf_resc_cfg(struct bnxt *bp, int num_vfs, bool reset)
 		hw_resc->max_stat_ctxs -= le16_to_cpu(req.min_stat_ctx) * n;
 		hw_resc->max_vnics -= le16_to_cpu(req.min_vnics) * n;
 		if (bp->flags & BNXT_FLAG_CHIP_P5)
-			hw_resc->max_irqs -= vf_msix * n;
+			hw_resc->max_nqs -= vf_msix;
 
 		rc = pf->active_vfs;
 	}
-- 
2.35.1



