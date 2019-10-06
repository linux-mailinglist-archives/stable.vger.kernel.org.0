Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D947BCD683
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfJFRnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfJFRnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915CC2087E;
        Sun,  6 Oct 2019 17:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383787;
        bh=RElNQWC1sL5bV1os5V5P26hwdNH57/88suKAzPs2f5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3oqOGIrv3oFVIipYhzKaWl1ye5sVhyHBqGq7VMTeTGsdkQlaIeDzerMBnSttDy1s
         OhOS9hZASqw/JYh7/ZXPCAJgzhgnKiBVErBf5Qd91AqThsiw5VuWfimFVYzM3XW549
         NQrGrCx7stdpVqV1bMC6B0qAB4+jN48ndvoJUIe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 096/166] soundwire: intel: fix channel number reported by hardware
Date:   Sun,  6 Oct 2019 19:21:02 +0200
Message-Id: <20191006171221.661344351@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 18046335643de6d21327f5ae034c8fb8463f6715 ]

On all released Intel controllers (CNL/CML/ICL), PDI2 reports an
invalid count, force the correct hardware-supported value

This may have to be revisited with platform-specific values if the
hardware changes, but for now this is good enough.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190806005522.22642-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 317873bc0555d..ec25a71d08873 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -289,6 +289,16 @@ intel_pdi_get_ch_cap(struct sdw_intel *sdw, unsigned int pdi_num, bool pcm)
 
 	if (pcm) {
 		count = intel_readw(shim, SDW_SHIM_PCMSYCHC(link_id, pdi_num));
+
+		/*
+		 * WORKAROUND: on all existing Intel controllers, pdi
+		 * number 2 reports channel count as 1 even though it
+		 * supports 8 channels. Performing hardcoding for pdi
+		 * number 2.
+		 */
+		if (pdi_num == 2)
+			count = 7;
+
 	} else {
 		count = intel_readw(shim, SDW_SHIM_PDMSCAP(link_id));
 		count = ((count & SDW_SHIM_PDMSCAP_CPSS) >>
-- 
2.20.1



