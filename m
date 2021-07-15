Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7F3CA669
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbhGOSrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhGOSrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD34A613D1;
        Thu, 15 Jul 2021 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374682;
        bh=2wcLH/MjR6vnjHJ+bCuMtovL+XwRk6NvzTwRJB2jEXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mN7zYkC8OIXrjVOL89Q4PUCH/Xj51cyKdM7vpIR15TBYu9szuocwNgccwe4TcdD7n
         /eCAXFXxiF35d41rTIYGvxJveHqtgpeGLcVl2qZFEM9UZLCbM/H7JRxIJRhC4mXXn+
         9MCvBSB0ATwJ9VlclLvWnw+Bfx4ZNh51V9VJdoXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ferry Toth <ftoth@exalondelft.nl>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5.4 102/122] extcon: intel-mrfld: Sync hardware and software state on init
Date:   Thu, 15 Jul 2021 20:39:09 +0200
Message-Id: <20210715182519.076920793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

commit ecb5bdff901139850fb3ca3ae2d0cccac045bc52 upstream.

extcon driver for Basin Cove PMIC shadows the switch status used for dwc3
DRD to detect a change in the switch position. This change initializes the
status at probe time.

Cc: stable@vger.kernel.org
Fixes: 492929c54791 ("extcon: mrfld: Introduce extcon driver for Basin Cove PMIC")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-intel-mrfld.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/extcon/extcon-intel-mrfld.c
+++ b/drivers/extcon/extcon-intel-mrfld.c
@@ -197,6 +197,7 @@ static int mrfld_extcon_probe(struct pla
 	struct intel_soc_pmic *pmic = dev_get_drvdata(dev->parent);
 	struct regmap *regmap = pmic->regmap;
 	struct mrfld_extcon_data *data;
+	unsigned int status;
 	unsigned int id;
 	int irq, ret;
 
@@ -244,6 +245,14 @@ static int mrfld_extcon_probe(struct pla
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
 


