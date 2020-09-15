Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17FD26B41A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgIOXP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBC22253D;
        Tue, 15 Sep 2020 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180175;
        bh=QDTOZ2Ua6v4ZoH4N2xPZsOjBIHzjHhGTNnXI5qojH2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lmn8S0qQbNpZZS/0RvZ4nFlhJOp5QktSFh8rmDo3uLbRbZD9P7wBwet0VhCUS1Ssz
         ntlTX+wtUDsdVUBJpOW2jbO3mkkfqLIav9Taq1M1nKh4juVsK6+eNf2R/FTiyuRZwg
         tW4tv+TK5AxbYqnj4/SmiIbtgRTo/KCw+yiIn+jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.8 137/177] regulator: core: Fix slab-out-of-bounds in regulator_unlock_recursive()
Date:   Tue, 15 Sep 2020 16:13:28 +0200
Message-Id: <20200915140700.218120657@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 0a7416f94707c60b9f66b01c0a505b7e41375f3a upstream.

The recent commit 7d8196641ee1 ("regulator: Remove pointer table
overallocation") changed the size of coupled_rdevs and now KASAN is able
to detect slab-out-of-bounds problem in regulator_unlock_recursive(),
which is a legit problem caused by a typo in the code. The recursive
unlock function uses n_coupled value of a parent regulator for unlocking
supply regulator, while supply's n_coupled should be used. In practice
problem may only affect platforms that use coupled regulators.

Cc: stable@vger.kernel.org # 5.0+
Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200831204335.19489-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -235,8 +235,8 @@ static bool regulator_supply_is_couple(s
 static void regulator_unlock_recursive(struct regulator_dev *rdev,
 				       unsigned int n_coupled)
 {
-	struct regulator_dev *c_rdev;
-	int i;
+	struct regulator_dev *c_rdev, *supply_rdev;
+	int i, supply_n_coupled;
 
 	for (i = n_coupled; i > 0; i--) {
 		c_rdev = rdev->coupling_desc.coupled_rdevs[i - 1];
@@ -244,10 +244,13 @@ static void regulator_unlock_recursive(s
 		if (!c_rdev)
 			continue;
 
-		if (c_rdev->supply && !regulator_supply_is_couple(c_rdev))
-			regulator_unlock_recursive(
-					c_rdev->supply->rdev,
-					c_rdev->coupling_desc.n_coupled);
+		if (c_rdev->supply && !regulator_supply_is_couple(c_rdev)) {
+			supply_rdev = c_rdev->supply->rdev;
+			supply_n_coupled = supply_rdev->coupling_desc.n_coupled;
+
+			regulator_unlock_recursive(supply_rdev,
+						   supply_n_coupled);
+		}
 
 		regulator_unlock(c_rdev);
 	}


