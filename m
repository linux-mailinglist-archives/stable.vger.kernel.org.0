Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3910B7B0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfK0UgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfK0UgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:36:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB30C207DD;
        Wed, 27 Nov 2019 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886963;
        bh=i4QKo1c3jisTV2BspdLecAEOwACkSI6dwzcxae6X5fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwVHRQdu0XpOecaIVky1/KVhw7fnwkFHE+x8z6INBUqr0yIzYm0l4hM/+KxO0/WYO
         YXYKtDlcNYOl2LUcPibRaIrw8yW7gaJZv2VN0tQYY1NEN/tPRsl2Xoc8zwMlnvA3aN
         drX7BASiaTBFdfo6KHbIfFruxvXgXI4tzpO2yj/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 059/132] thermal: rcar_thermal: Prevent hardware access during system suspend
Date:   Wed, 27 Nov 2019 21:30:50 +0100
Message-Id: <20191127202958.414472394@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3a31386217628ffe2491695be2db933c25dde785 ]

On r8a7791/koelsch, sometimes the following message is printed during
system suspend:

    rcar_thermal e61f0000.thermal: thermal sensor was broken

This happens if the workqueue runs while the device is already
suspended.  Fix this by using the freezable system workqueue instead,
cfr. commit 51e20d0e3a60cf46 ("thermal: Prevent polling from happening
during system suspend").

Fixes: e0a5172e9eec7f0d ("thermal: rcar: add interrupt support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/rcar_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 13d01edc7a043..487c5cd7516c0 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -350,8 +350,8 @@ static irqreturn_t rcar_thermal_irq(int irq, void *data)
 	rcar_thermal_for_each_priv(priv, common) {
 		if (rcar_thermal_had_changed(priv, status)) {
 			rcar_thermal_irq_disable(priv);
-			schedule_delayed_work(&priv->work,
-					      msecs_to_jiffies(300));
+			queue_delayed_work(system_freezable_wq, &priv->work,
+					   msecs_to_jiffies(300));
 		}
 	}
 
-- 
2.20.1



