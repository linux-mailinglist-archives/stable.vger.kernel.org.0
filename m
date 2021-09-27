Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46F54192AC
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhI0LCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhI0LCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 07:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7138F60F3A;
        Mon, 27 Sep 2021 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632740455;
        bh=ARhMCGkjNarQ3TvQ7tEXrozrOZ37V/jFJTJgnJ4/gG8=;
        h=Subject:To:Cc:From:Date:From;
        b=V2yYVzfEP05jyHq69Jy0uc57sXkxiOuY7fP/wvGRc/n0btacdXSdr15IUDDEN7ZuK
         Zbu6nhYjjxn1KVNd5spnABQu1D2vyZPc7jKgAQyRh24JeY54Lr4wWdQ7TED35WLpHF
         MJ2MsVkBXXDU7d8vbpXDLc2PZwotMfhsdTB2SJW8=
Subject: FAILED: patch "[PATCH] EDAC/synopsys: Fix wrong value type assignment for edac_mode" failed to apply to 4.19-stable tree
To:     lakshmi.sai.krishna.potthuri@xilinx.com, bp@suse.de,
        shubhrajyoti.datta@xilinx.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Sep 2021 13:00:53 +0200
Message-ID: <163274045325350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5297cfa6bdf93e3889f78f9b482e2a595a376083 Mon Sep 17 00:00:00 2001
From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Date: Wed, 18 Aug 2021 12:53:14 +0530
Subject: [PATCH] EDAC/synopsys: Fix wrong value type assignment for edac_mode

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

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 7e7146b22c16..7d08627e738b 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -782,7 +782,7 @@ static void init_csrows(struct mem_ctl_info *mci)
 
 		for (j = 0; j < csi->nr_channels; j++) {
 			dimm		= csi->channels[j]->dimm;
-			dimm->edac_mode	= EDAC_FLAG_SECDED;
+			dimm->edac_mode	= EDAC_SECDED;
 			dimm->mtype	= p_data->get_mtype(priv->baseaddr);
 			dimm->nr_pages	= (size >> PAGE_SHIFT) / csi->nr_channels;
 			dimm->grain	= SYNPS_EDAC_ERR_GRAIN;

