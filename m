Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ED5409122
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbhIMN6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343688AbhIMN4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E6B061252;
        Mon, 13 Sep 2021 13:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540170;
        bh=pFePtBldSYTnQ7NFMd9MKqLtrH421DrCfA14diGFJJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LBXq+9ZHVlC4nTNGc9WvJ6iIYA1Ikf1Og3f523utlJ+VofU5qh/u8gW22eLqoZMj
         19n3HT93D95jxCMc30F1FtHz5o7TyopEpMlY/WR5QuSrXVcd5RBiuSX8XqdJQQ9lnD
         ZTL+aeOUzBd1Aw+gS29oI25HyZ8FyTvabG0NhT3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fan Du <fan.du@intel.com>,
        Wen Jin <wen.jin@intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/300] EDAC/i10nm: Fix NVDIMM detection
Date:   Mon, 13 Sep 2021 15:12:21 +0200
Message-Id: <20210913131112.072875092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 37b4e875420e..1cea5d8fa434 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -26,8 +26,8 @@
 	pci_read_config_dword((d)->uracu, 0xd8 + (i) * 4, &(reg))
 #define I10NM_GET_DIMMMTR(m, i, j)	\
 	readl((m)->mbase + 0x2080c + (i) * (m)->chan_mmio_sz + (j) * 4)
-#define I10NM_GET_MCDDRTCFG(m, i, j)	\
-	readl((m)->mbase + 0x20970 + (i) * (m)->chan_mmio_sz + (j) * 4)
+#define I10NM_GET_MCDDRTCFG(m, i)	\
+	readl((m)->mbase + 0x20970 + (i) * (m)->chan_mmio_sz)
 #define I10NM_GET_MCMTR(m, i)		\
 	readl((m)->mbase + 0x20ef8 + (i) * (m)->chan_mmio_sz)
 #define I10NM_GET_AMAP(m, i)		\
@@ -185,10 +185,10 @@ static int i10nm_get_dimm_config(struct mem_ctl_info *mci,
 
 		ndimms = 0;
 		amap = I10NM_GET_AMAP(imc, i);
+		mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i);
 		for (j = 0; j < I10NM_NUM_DIMMS; j++) {
 			dimm = edac_get_dimm(mci, i, j, 0);
 			mtr = I10NM_GET_DIMMMTR(imc, i, j);
-			mcddrtcfg = I10NM_GET_MCDDRTCFG(imc, i, j);
 			edac_dbg(1, "dimmmtr 0x%x mcddrtcfg 0x%x (mc%d ch%d dimm%d)\n",
 				 mtr, mcddrtcfg, imc->mc, i, j);
 
-- 
2.30.2



