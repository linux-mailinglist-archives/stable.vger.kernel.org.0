Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0CA420C91
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhJDNHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235007AbhJDNE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099F561373;
        Mon,  4 Oct 2021 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352438;
        bh=bofRQF8V4KZ0GU9jbM7DDLS1tyHH/1lOTOy5XoKg1+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCMShRk5dp12Mk5oE4ZjIJrZpYKp0IFxG2x65dCHikUTLHJkgVjYP1Vsys9rexCE8
         DC88bm5lX3t75uWnO2lv5dAdlmG7/GVI2a0GprfTgtbb2EWZgFI4o1/DYabk9MXsAz
         X+WpEMtBeHsImckiIYmYbk8xfY1oaNWur96sKCPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 62/75] EDAC/synopsys: Fix wrong value type assignment for edac_mode
Date:   Mon,  4 Oct 2021 14:52:37 +0200
Message-Id: <20211004125033.615719687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
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
@@ -371,7 +371,7 @@ static int synps_edac_init_csrows(struct
 
 		for (j = 0; j < csi->nr_channels; j++) {
 			dimm            = csi->channels[j]->dimm;
-			dimm->edac_mode = EDAC_FLAG_SECDED;
+			dimm->edac_mode = EDAC_SECDED;
 			dimm->mtype     = synps_edac_get_mtype(priv->baseaddr);
 			dimm->nr_pages  = (size >> PAGE_SHIFT) / csi->nr_channels;
 			dimm->grain     = SYNPS_EDAC_ERR_GRAIN;


