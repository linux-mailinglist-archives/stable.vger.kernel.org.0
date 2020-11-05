Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357882A7D95
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 12:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKELze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 06:55:34 -0500
Received: from first.geanix.com ([116.203.34.67]:37450 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbgKELzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 06:55:33 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2020 06:55:32 EST
Received: from zen.localdomain (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id A8368EC4DEB;
        Thu,  5 Nov 2020 11:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1604576982; bh=x+YqAx/ecSYGcqr/1jyRyq43brPuKux3IFeAXeK8Urk=;
        h=From:To:Cc:Subject:Date;
        b=jtlSyac+ECa1eAAI9bWrw9jKs/mYMQbODLw1N7jvD6w+c9rsRSFH7MeZISye2DVFs
         /pXi90oqAOGl15YQPUaHapjbADjkik4HPG7BooxdrJZLe/gEVhxVEeuD7x+AFri/v3
         BKeVFg38IXI8goENJSnAA09Lcx0FN4srxq35DmEXovfzXQzj25dB8EFAQtgI05H0AY
         Euk0JfoP+uK1OqS0Y7KNoXywvcleFlViIg2j6cdE1Mj5ztuGXq50PY20JTlAOrt57D
         I3wJ2++bYf3oE+ozpRzpO1DZ+/MkaK26Vtp2Y4pnWvQR2VJ+ybR8OEA51IMWdw7Epj
         E+6OizLUjQA+Q==
From:   Sean Nyekjaer <sean@geanix.com>
To:     yibin.gong@nxp.com, linux-kernel@vger.kernel.org,
        broonie@kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org
Subject: [PATCH] regualtor: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}
Date:   Thu,  5 Nov 2020 12:49:26 +0100
Message-Id: <20201105114926.734553-1-sean@geanix.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on ff3d05386fc5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Limit the fsl,pfuze-support-disable-sw to the pfuze100 and pfuze200
variants.
When enabling fsl,pfuze-support-disable-sw and using a pfuze3000 or
pfuze3001, the driver would choose pfuze100_sw_disable_regulator_ops
instead of the newly introduced and correct pfuze3000_sw_regulator_ops.

Fixes: 6f1cf5257acc ("regualtor: pfuze100: correct sw1a/sw2 on pfuze3000")
Cc: stable@vger.kernel.org
---
 drivers/regulator/pfuze100-regulator.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 7e8ba9246167..01a12cfcea7c 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -836,11 +836,14 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		 * the switched regulator till yet.
 		 */
 		if (pfuze_chip->flags & PFUZE_FLAG_DISABLE_SW) {
-			if (pfuze_chip->regulator_descs[i].sw_reg) {
-				desc->ops = &pfuze100_sw_disable_regulator_ops;
-				desc->enable_val = 0x8;
-				desc->disable_val = 0x0;
-				desc->enable_time = 500;
+			if (pfuze_chip->chip_id == PFUZE100 ||
+				pfuze_chip->chip_id == PFUZE200) {
+				if (pfuze_chip->regulator_descs[i].sw_reg) {
+					desc->ops = &pfuze100_sw_disable_regulator_ops;
+					desc->enable_val = 0x8;
+					desc->disable_val = 0x0;
+					desc->enable_time = 500;
+				}
 			}
 		}
 
-- 
2.28.0

