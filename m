Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB2A475E96
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245370AbhLORXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbhLORXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1E5C06175B;
        Wed, 15 Dec 2021 09:22:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F728B82023;
        Wed, 15 Dec 2021 17:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC2C36AE2;
        Wed, 15 Dec 2021 17:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588976;
        bh=6hBuDWH8BMVBfX9osnb514u04sGT6Ni1nhapyDoaevU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEQ/AogKhEB4bWBPujxNRQT8PuHdvzY2vQIxfGvdB+GOW85BZ0ypTVBJkJPfPlcA7
         K8miGLCkRjkJcPq/WBeDP6HeExuqA1l1LEE9+jIM/zfpjlJ9e9gwl84VVeu2xePxra
         ERlf+kV/VyYzuIsitkiBwJ2Yj8AyZkCyNYZkr+kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herve Codina <herve.codina@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/42] mtd: rawnand: Fix nand_choose_best_timings() on unsupported interface
Date:   Wed, 15 Dec 2021 18:20:47 +0100
Message-Id: <20211215172026.861612564@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 36a65982a98c4bc72fdcfef2c4aaf90193746631 ]

When the NV-DDR interface is not supported by the NAND chip,
the value of onfi->nvddr_timing_modes is 0. In this case,
the best_mode variable value in nand_choose_best_nvddr_timings()
is -1. The last for-loop is skipped and the function returns an
uninitialized value.
If this returned value is 0, the nand_choose_best_sdr_timings()
is not executed and no 'best timing' are set. This leads the host
controller and the NAND chip working at default mode 0 timing
even if a better timing can be used.

Fix this uninitialized returned value.

nand_choose_best_sdr_timings() is pretty similar to
nand_choose_best_nvddr_timings(). Even if onfi->sdr_timing_modes
should never be seen as 0, nand_choose_best_sdr_timings() returned
value is fixed.

Fixes: a9ecc8c814e9 ("mtd: rawnand: Choose the best timings, NV-DDR included")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211119150316.43080-3-herve.codina@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 5c6b065837eff..a130320de4128 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -926,7 +926,7 @@ int nand_choose_best_sdr_timings(struct nand_chip *chip,
 				 struct nand_sdr_timings *spec_timings)
 {
 	const struct nand_controller_ops *ops = chip->controller->ops;
-	int best_mode = 0, mode, ret;
+	int best_mode = 0, mode, ret = -EOPNOTSUPP;
 
 	iface->type = NAND_SDR_IFACE;
 
@@ -977,7 +977,7 @@ int nand_choose_best_nvddr_timings(struct nand_chip *chip,
 				   struct nand_nvddr_timings *spec_timings)
 {
 	const struct nand_controller_ops *ops = chip->controller->ops;
-	int best_mode = 0, mode, ret;
+	int best_mode = 0, mode, ret = -EOPNOTSUPP;
 
 	iface->type = NAND_NVDDR_IFACE;
 
-- 
2.33.0



