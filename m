Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D402137C1D9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhELPFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232328AbhELPDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:03:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22E5616E9;
        Wed, 12 May 2021 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831500;
        bh=JrvIiW/qHHM9SLnA5IfAcParDd5L5y2qxO9yu/1Fw+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLw9I8LqIIPRTJMZ/5FWVyTZY+jBQaqT1mdTeGyT4kMIf83Sip5PrNQF7mPhYMdgS
         ikVOoOixFafoan1Favw6GuIjvtSf1Y/1Wy7Zgh1MbJpe2//c3nSBZ6josUW8zXyEV4
         B9sZdxET5iC/5yLW3lj/WBvZxGmQW0phYWBLhB14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/244] media: m88rs6000t: avoid potential out-of-bounds reads on arrays
Date:   Wed, 12 May 2021 16:48:35 +0200
Message-Id: <20210512144747.619046190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9baa3d64e8e2373ddd11c346439e5dfccb2cbb0d ]

There a 3 array for-loops that don't check the upper bounds of the
index into arrays and this may lead to potential out-of-bounds
reads.  Fix this by adding array size upper bounds checks to be
full safe.

Addresses-Coverity: ("Out-of-bounds read")

Link: https://lore.kernel.org/linux-media/20201007121628.20676-1-colin.king@canonical.com
Fixes: 333829110f1d ("[media] m88rs6000t: add new dvb-s/s2 tuner for integrated chip M88RS6000")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/m88rs6000t.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index b3505f402476..8647c50b66e5 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -525,7 +525,7 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	PGA2_cri = PGA2_GC >> 2;
 	PGA2_crf = PGA2_GC & 0x03;
 
-	for (i = 0; i <= RF_GC; i++)
+	for (i = 0; i <= RF_GC && i < ARRAY_SIZE(RFGS); i++)
 		RFG += RFGS[i];
 
 	if (RF_GC == 0)
@@ -537,12 +537,12 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	if (RF_GC == 3)
 		RFG += 100;
 
-	for (i = 0; i <= IF_GC; i++)
+	for (i = 0; i <= IF_GC && i < ARRAY_SIZE(IFGS); i++)
 		IFG += IFGS[i];
 
 	TIAG = TIA_GC * TIA_GS;
 
-	for (i = 0; i <= BB_GC; i++)
+	for (i = 0; i <= BB_GC && i < ARRAY_SIZE(BBGS); i++)
 		BBG += BBGS[i];
 
 	PGA2G = PGA2_cri * PGA2_cri_GS + PGA2_crf * PGA2_crf_GS;
-- 
2.30.2



