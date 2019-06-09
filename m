Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BD93A8A5
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388295AbfFIRCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388290AbfFIRCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D1F206DF;
        Sun,  9 Jun 2019 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099763;
        bh=Fbo8dytbPMSisTSOkUgK0/guHrahixpxaGNIxTv3bOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/p58+uyjrAbuNEdbStsGEZLZDp9Kf989JJbA6oj31E+Omz1IwP9VY21dWL7c9v0M
         lh+9cPQbm9erdR2vWx6pJC6PQ9++Hs7U5axFNqnP13FLWK5k87uWcOObQUKs77i7Nh
         Vfv0HcSg/woPoq3KaQ14zdHIUjpTwAfnIL1zaOrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 157/241] scsi: ufs: Avoid configuring regulator with undefined voltage range
Date:   Sun,  9 Jun 2019 18:41:39 +0200
Message-Id: <20190609164152.299169268@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3b141e8cfd54ba3e5c610717295b2a02aab26a05 ]

For regulators used by UFS, vcc, vccq and vccq2 will have voltage range
initialized by ufshcd_populate_vreg(), however other regulators may have
undefined voltage range if dt-bindings have no such definition.

In above undefined case, both "min_uV" and "max_uV" fields in ufs_vreg
struct will be zero values and these values will be configured on
regulators in different power modes.

Currently this may have no harm if both "min_uV" and "max_uV" always keep
"zero values" because regulator_set_voltage() will always bypass such
invalid values and return "good" results.

However improper values shall be fixed to avoid potential bugs.  Simply
bypass voltage configuration if voltage range is not defined.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ed76381fce4cc..7322a17660d10 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4434,12 +4434,15 @@ static int ufshcd_config_vreg(struct device *dev,
 	name = vreg->name;
 
 	if (regulator_count_voltages(reg) > 0) {
-		min_uV = on ? vreg->min_uV : 0;
-		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
-		if (ret) {
-			dev_err(dev, "%s: %s set voltage failed, err=%d\n",
+		if (vreg->min_uV && vreg->max_uV) {
+			min_uV = on ? vreg->min_uV : 0;
+			ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
+			if (ret) {
+				dev_err(dev,
+					"%s: %s set voltage failed, err=%d\n",
 					__func__, name, ret);
-			goto out;
+				goto out;
+			}
 		}
 
 		uA_load = on ? vreg->max_uA : 0;
-- 
2.20.1



