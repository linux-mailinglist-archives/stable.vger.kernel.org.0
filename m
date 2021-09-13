Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B33408D17
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbhIMNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240079AbhIMNU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D4FB61159;
        Mon, 13 Sep 2021 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539112;
        bh=GF0wmKyEZ1is/K26gPTaNSagtSgWTYlGb4yWxQni9ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eN2UcV0R+6k8KXB/XOBA0npB/wqeTPxTSru7cTj6ylWEKO5wIiR/BPYhjCwS0Gt8K
         P0myaEFLy3Xmp4EJN8Rd+7pB7qP8iQJ88w3vQ/Fal/qeKWDgu6bTEOUgI1G+U5/yca
         tfmSNu6gbRUIEMDRusM2xjx4tURhhFP1Mrp3kDKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fan Du <fan.du@intel.com>,
        Wen Jin <wen.jin@intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/144] EDAC/i10nm: Fix NVDIMM detection
Date:   Mon, 13 Sep 2021 15:13:46 +0200
Message-Id: <20210913131049.449919700@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 2294a7299f5e51667b841f63c6d69474491753fb ]

MCDDRCFG is a per-channel register and uses bit{0,1} to indicate
the NVDIMM presence on DIMM slot{0,1}. Current i10nm_edac driver
wrongly uses MCDDRCFG as per-DIMM register and fails to detect
the NVDIMM.

Fix it by reading MCDDRCFG as per-channel register and using its
bit{0,1} to check whether the NVDIMM is populated on DIMM slot{0,1}.

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Reported-by: Fan Du <fan.du@intel.com>
Tested-by: Wen Jin <wen.jin@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20210818175701.1611513-2-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index f72be5f94e6f..29576922df78 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -26,8 +26,8 @@
 	pci_read_config_dword((d)->uracu, 0xd8 + (i) * 4, &(reg))
 #define I10NM_GET_DIMMMTR(m, i, j)	\
 	readl((m)->mbase + 0x2080c + (i) * 0x4000 + (j) * 4)
-#define I10NM_GET_MCDDRTCFG(m, i, j)	\
-	readl((m)->mbase + 0x20970 + (i) * 0x4000 + (j) * 4)
+#define I10NM_GET_MCDDRTCFG(m, i)	\
+	readl((m)->mbase + 0x20970 + (i) * 0x4000)
 #define I10NM_GET_MCMTR(m, i)		\
 	readl((m)->mbase + 0x20ef8 + (i) * 0x4000)
 
@@ -156,11 +156,11 @@ static int i10nm_get_dimm_config(struct mem_ctl_info *mci)
 			continue;
 
 		ndimms = 0;
+		mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i);
 		for (j = 0; j < I10NM_NUM_DIMMS; j++) {
 			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 					     mci->n_layers, i, j, 0);
 			mtr = I10NM_GET_DIMMMTR(imc, i, j);
-			mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i, j);
 			edac_dbg(1, "dimmmtr 0x%x mcddrtcfg 0x%x (mc%d ch%d dimm%d)\n",
 				 mtr, mcddrtcfg, imc->mc, i, j);
 
-- 
2.30.2



