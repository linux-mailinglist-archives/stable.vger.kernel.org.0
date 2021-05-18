Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7158388256
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352582AbhERVqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:46:13 -0400
Received: from mailfilter05-out40.webhostingserver.nl ([195.211.74.36]:47114
        "EHLO mailfilter05-out40.webhostingserver.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352569AbhERVqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:46:12 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2021 17:46:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=r1V16Y5GIRXwUTK+1TLre5uwbLOjG0Lm/wFKIhXVtXY=;
        b=miTktNcY7YTq2u9lPqkSuJ6v2iSkoBIuafLAk/cz2/D9XxKL0ctaKmnse0v1D4zAJfQP/C9wo4Y3l
         UDPuCxEYRL0Dz5L5HWBxbsJvbnU4S6dT3gA4muXx+MscedtBzFDcQ6RlyxJocGmwhau/m0GEDXkBG+
         9iTT5L6Fe6p/KoOuDhWRvUqGYuOt/kFV8U9JbK4zyceLO6y1TDZZXkZZNZY47ZB8LMvUvrv8NmSi/g
         j5qSGtpbRUb/mYOzwTyuYN4Fdcu2y3aSm93vS8SRp+Qw0m95qEcw3eK2ktDU10NuhWj2vnBTmvbCua
         csoDRyTGjXozu6iHmP2B0/eIZkSHM3w==
X-Halon-ID: 086bd20a-b820-11eb-b080-001a4a4cb933
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter05.webhostingserver.nl (Halon) with ESMTPSA
        id 086bd20a-b820-11eb-b080-001a4a4cb933;
        Tue, 18 May 2021 23:28:48 +0200 (CEST)
Received: from [2001:981:6fec:1:dae6:899:1e05:8781] (helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.94.2)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1lj7Gi-004E57-8x; Tue, 18 May 2021 23:28:48 +0200
From:   Ferry Toth <ftoth@exalondelft.nl>
To:     linux-kernel@vger.kernel.org
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/1] extcon: intel-mrfld: Sync hardware and software state on init
Date:   Tue, 18 May 2021 23:27:09 +0200
Message-Id: <20210518212708.301112-1-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

extcon driver for Basin Cove PMIC shadows the switch status used for dwc3
DRD to detect a change in the switch position. This change initializes the
status at probe time.

Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Fixes: 492929c54791 ("extcon: mrfld: Introduce extcon driver for Basin Cove PMIC")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: stable@vger.kernel.org
---

v2:
 - Clarified patch title (Chanwoo)
---
 drivers/extcon/extcon-intel-mrfld.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/extcon/extcon-intel-mrfld.c b/drivers/extcon/extcon-intel-mrfld.c
index f47016fb28a8..cd1a5f230077 100644
--- a/drivers/extcon/extcon-intel-mrfld.c
+++ b/drivers/extcon/extcon-intel-mrfld.c
@@ -197,6 +197,7 @@ static int mrfld_extcon_probe(struct platform_device *pdev)
 	struct intel_soc_pmic *pmic = dev_get_drvdata(dev->parent);
 	struct regmap *regmap = pmic->regmap;
 	struct mrfld_extcon_data *data;
+	unsigned int status;
 	unsigned int id;
 	int irq, ret;
 
@@ -244,6 +245,14 @@ static int mrfld_extcon_probe(struct platform_device *pdev)
 	/* Get initial state */
 	mrfld_extcon_role_detect(data);
 
+	/*
+	 * Cached status value is used for cable detection, see comments
+	 * in mrfld_extcon_cable_detect(), we need to sync cached value
+	 * with a real state of the hardware.
+	 */
+	regmap_read(regmap, BCOVE_SCHGRIRQ1, &status);
+	data->status = status;
+
 	mrfld_extcon_clear(data, BCOVE_MIRQLVL1, BCOVE_LVL1_CHGR);
 	mrfld_extcon_clear(data, BCOVE_MCHGRIRQ1, BCOVE_CHGRIRQ_ALL);
 
-- 
2.30.2

