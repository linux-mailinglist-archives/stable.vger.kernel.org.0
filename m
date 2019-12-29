Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3312C83C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbfL2Rwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbfL2Rwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78997206DB;
        Sun, 29 Dec 2019 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641949;
        bh=eQgGoSK8L92lrFgEVaHF+VYPl7BHmvS6Maj48KdwIjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpkz+sLVu89PSE4OeV25IJUybAQf02bdR/KKQTP1mtlS1kC6kuY5ta4KWiiQUA8BJ
         1BGcBWJkb+3RbB31jQHUKOytGbTClbQcAUL4HhzI7p2k4GWUMVlpoOY4Stf5hAQwqx
         6rmchgVbh3DjaAR5obLHugrECH2+zv4orZ3LvBjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 277/434] soundwire: intel: fix PDI/stream mapping for Bulk
Date:   Sun, 29 Dec 2019 18:25:30 +0100
Message-Id: <20191229172720.342150950@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit c134f914e9f55b7817e2bae625ec0e5f1379f7cd ]

The previous formula is incorrect for PDI0/1, the mapping is not
linear but has a discontinuity between PDI1 and PDI2.

This change has no effect on PCM PDIs (same mapping).

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191022232948.17156-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 13c54eac0cc3..d1839707128a 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -479,7 +479,10 @@ intel_pdi_shim_configure(struct sdw_intel *sdw, struct sdw_cdns_pdi *pdi)
 	unsigned int link_id = sdw->instance;
 	int pdi_conf = 0;
 
-	pdi->intel_alh_id = (link_id * 16) + pdi->num + 5;
+	/* the Bulk and PCM streams are not contiguous */
+	pdi->intel_alh_id = (link_id * 16) + pdi->num + 3;
+	if (pdi->num >= 2)
+		pdi->intel_alh_id += 2;
 
 	/*
 	 * Program stream parameters to stream SHIM register
@@ -508,7 +511,10 @@ intel_pdi_alh_configure(struct sdw_intel *sdw, struct sdw_cdns_pdi *pdi)
 	unsigned int link_id = sdw->instance;
 	unsigned int conf;
 
-	pdi->intel_alh_id = (link_id * 16) + pdi->num + 5;
+	/* the Bulk and PCM streams are not contiguous */
+	pdi->intel_alh_id = (link_id * 16) + pdi->num + 3;
+	if (pdi->num >= 2)
+		pdi->intel_alh_id += 2;
 
 	/* Program Stream config ALH register */
 	conf = intel_readl(alh, SDW_ALH_STRMZCFG(pdi->intel_alh_id));
-- 
2.20.1



