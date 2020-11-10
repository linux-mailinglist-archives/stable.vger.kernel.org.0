Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BD2ADD29
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 18:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKJRlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 12:41:31 -0500
Received: from first.geanix.com ([116.203.34.67]:56216 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgKJRla (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 12:41:30 -0500
Received: from zen.localdomain (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 4C3F6EC6410;
        Tue, 10 Nov 2020 17:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1605030088; bh=cWDNNUBZUEEgc3PICpvO+QPTV4CcmewbWmJBbcmXrhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=YNyuthLBC21U1OOM0a+UPMAWHaLkOIY0pbQkEFPNvXIFnavOSt2HJTbgaU9V44UM0
         lwskaU4KPoRHKJMQsFya//iNRke7B+D8g2GS75nLMK/CZrQlndXf+fuFT2ArOzqMrF
         lQDH1Fj1nfhQorDRjH/OGVTE9K8TB2k2kNHpgI/LC/I84xBm1zRmy43PiQ8wFA48Gi
         fcggL4iNiHWL80bBLdXIV4qjcg0zi/VJi1oPBNc/f7YDIbXUebUSAk4RVsLUzeV2i5
         Db+t2vBrk1uo04oTufv1st81mewImS5oGfa8MoupoCPO9s0OR0hvOtQ7zwLnSg5yh+
         t1oY/vweygmOg==
From:   Sean Nyekjaer <sean@geanix.com>
To:     yibin.gong@nxp.com, linux-kernel@vger.kernel.org,
        broonie@kernel.org
Cc:     Sean Nyekjaer <sean@geanix.com>, stable@vger.kernel.org
Subject: [PATCH v2] regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}
Date:   Tue, 10 Nov 2020 18:41:13 +0100
Message-Id: <20201110174113.2066534-1-sean@geanix.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110172721.GA49286@sirena.org.uk>
References: 
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

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Fixes: 6f1cf5257acc ("regualtor: pfuze100: correct sw1a/sw2 on pfuze3000")
Cc: stable@vger.kernel.org
---
Changes since v1:
 - Added signoff
 - fixed typo in commit msg

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

