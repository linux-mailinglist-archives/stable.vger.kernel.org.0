Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AE2F26D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfE3EVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbfE3DPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFA4245AC;
        Thu, 30 May 2019 03:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186111;
        bh=wro3ECXet6tn1QQSQA7tVVQwH1ZNwKWIcAwt3CH8xJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rX6gRKosnpnlSe7A7+kfseJn7/mUxi8A4oYs3KtnK/9INvSSOAo0q67kPNDYbFyHr
         hCt4EOmJhnUYavbriixJSShP1IucPIE/7dLKLR4jSBTqdv/iofq76/Hcyrz507QkU1
         YsHHIzksWmWNpFk8Tx795wg3menUvzXAA7VP2OW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 214/346] regulator: core: Avoid potential deadlock on regulator_unregister
Date:   Wed, 29 May 2019 20:04:47 -0700
Message-Id: <20190530030551.945104258@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 063773011d33bb36588a90385aa9eb75d13c6d80 ]

Lockdep reports the following issue on my setup:

Possible unsafe locking scenario:

CPU0                    CPU1
----                    ----
lock((work_completion)(&(&rdev->disable_work)->work));
                        lock(regulator_list_mutex);
                        lock((work_completion)(&(&rdev->disable_work)->work));
lock(regulator_list_mutex);

The problem is that regulator_unregister takes the
regulator_list_mutex and then calls flush_work on disable_work. But
regulator_disable_work calls regulator_lock_dependent which will
also take the regulator_list_mutex. Resulting in a deadlock if the
flush_work call actually needs to flush the work.

Fix this issue by moving the flush_work outside of the
regulator_list_mutex. The list mutex is not used to guard the point at
which the delayed work is queued, so its use adds no additional safety.

Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fb9fe26fd0fa1..218b9331475b7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5101,10 +5101,11 @@ void regulator_unregister(struct regulator_dev *rdev)
 		regulator_put(rdev->supply);
 	}
 
+	flush_work(&rdev->disable_work.work);
+
 	mutex_lock(&regulator_list_mutex);
 
 	debugfs_remove_recursive(rdev->debugfs);
-	flush_work(&rdev->disable_work.work);
 	WARN_ON(rdev->open_count);
 	regulator_remove_coupling(rdev);
 	unset_regulator_supplies(rdev);
-- 
2.20.1



