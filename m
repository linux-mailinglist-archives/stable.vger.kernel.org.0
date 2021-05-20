Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F3E38AAE7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbhETLSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240488AbhETLQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D0B761D69;
        Thu, 20 May 2021 10:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505359;
        bh=c+BtpoNXJRkzS6snii+CAcxdQ6JuXuaTn74AuOTYr4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL4O2/fS0SuvGa2CQFDSKU8+imdDFzDw2lE+z2Oj1FdzY28Erv2LAXgtyxFpTDGEH
         ZyMkqm0cublOOxXCQ6EyimFwacpexf1bYYDGLr29ZnoNY8eG3uykq0aqKk2ByOwT71
         XuJOmHSIIN6HpzR13EEfpIDDKa0Sr3Rj0jGyfGLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 099/190] media: m88rs6000t: avoid potential out-of-bounds reads on arrays
Date:   Thu, 20 May 2021 11:22:43 +0200
Message-Id: <20210520092105.473603236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 504bfbc4027a..f78caf3c2bbd 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -535,7 +535,7 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 	PGA2_cri = PGA2_GC >> 2;
 	PGA2_crf = PGA2_GC & 0x03;
 
-	for (i = 0; i <= RF_GC; i++)
+	for (i = 0; i <= RF_GC && i < ARRAY_SIZE(RFGS); i++)
 		RFG += RFGS[i];
 
 	if (RF_GC == 0)
@@ -547,12 +547,12 @@ static int m88rs6000t_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
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



