Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD07B419CA2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhI0Raf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238220AbhI0R2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A448861501;
        Mon, 27 Sep 2021 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763055;
        bh=oEZUQg/xVn0SgdN7rNqBHSguMu2bwqsXX/umi3xsmsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEwokB2EWJo4BoL6Bh1BrzgOJ2T5wNdPIz+bO8RfLLrwrzeOfFWflySIP1prfF/xB
         jYeCmstm8LNerf616BB5bbRsPzP0fF4haYB1AOxQsHJvtdxzLPwIk6doWL/LxdpSuT
         9FkyoHXcphIYlvpSYGQ/KRwn496vd1bU1M89LCpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 150/162] EDAC/synopsys: Fix wrong value type assignment for edac_mode
Date:   Mon, 27 Sep 2021 19:03:16 +0200
Message-Id: <20210927170238.622224817@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>

commit 5297cfa6bdf93e3889f78f9b482e2a595a376083 upstream.

dimm->edac_mode contains values of type enum edac_type - not the
corresponding capability flags. Fix that.

Issue caught by Coverity check "enumerated type mixed with another
type."

 [ bp: Rewrite commit message, add tags. ]

Fixes: ae9b56e3996d ("EDAC, synps: Add EDAC support for zynq ddr ecc controller")
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210818072315.15149-1-shubhrajyoti.datta@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/synopsys_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -782,7 +782,7 @@ static void init_csrows(struct mem_ctl_i
 
 		for (j = 0; j < csi->nr_channels; j++) {
 			dimm		= csi->channels[j]->dimm;
-			dimm->edac_mode	= EDAC_FLAG_SECDED;
+			dimm->edac_mode	= EDAC_SECDED;
 			dimm->mtype	= p_data->get_mtype(priv->baseaddr);
 			dimm->nr_pages	= (size >> PAGE_SHIFT) / csi->nr_channels;
 			dimm->grain	= SYNPS_EDAC_ERR_GRAIN;


