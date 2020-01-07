Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9261333F3
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAGVCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgAGVCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACCE12077B;
        Tue,  7 Jan 2020 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430928;
        bh=nxVG0xH/nMQVbovLHgovXOgF85noBi++nkVrBvoedYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMVH7Ly4FjuE84K+LS5uZ48ii439Wcvw3UG1oCnUUeNbGB3vlNAJbKn1qtRy/b2Rg
         nzwRS/h5ALXiohgyU0+cE2QfOWYQfvQfBRS2qPOgxXEObY5NoFbobCHBZ5yAxWfFbh
         MdGSCea7Za89CB4UocatX52jPBC1yuB+QwJCsXi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 153/191] regulator: axp20x: Fix axp20x_set_ramp_delay
Date:   Tue,  7 Jan 2020 21:54:33 +0100
Message-Id: <20200107205341.155096010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 71dd2fe5dec171b34b71603a81bb46c24c498fde upstream.

Current code set incorrect bits when set ramp_delay for AXP20X_DCDC2,
fix it.

Fixes: d29f54df8b16 ("regulator: axp20x: add support for set_ramp_delay for AXP209")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Link: https://lore.kernel.org/r/20191221081049.32490-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/axp20x-regulator.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -413,10 +413,13 @@ static int axp20x_set_ramp_delay(struct
 		int i;
 
 		for (i = 0; i < rate_count; i++) {
-			if (ramp <= slew_rates[i])
-				cfg = AXP20X_DCDC2_LDO3_V_RAMP_LDO3_RATE(i);
-			else
+			if (ramp > slew_rates[i])
 				break;
+
+			if (id == AXP20X_DCDC2)
+				cfg = AXP20X_DCDC2_LDO3_V_RAMP_DCDC2_RATE(i);
+			else
+				cfg = AXP20X_DCDC2_LDO3_V_RAMP_LDO3_RATE(i);
 		}
 
 		if (cfg == 0xff) {


