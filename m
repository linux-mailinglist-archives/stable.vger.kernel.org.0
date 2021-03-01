Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB5F328A1E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbhCASMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239088AbhCASFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686F4651D4;
        Mon,  1 Mar 2021 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619051;
        bh=pItgVztPsWOLbhu1XQT65dKNDo2XiajdX3r/DX5pCk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mT3HilH90EHo6oGl79kNoH8IDZ48bh2xbgShimNC2Bkg3nPRRxsRUgGUCrxvlSQz3
         Uj67XF9el9HT425QJOluBlComvy6Ph+uwsx9s/wpi/tE51wuu198LgOGUYAv+JuRiA
         GkPQNNP3TN+GQLfeHIinPVrhTLCn7co0dbe3WRek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/663] regulator: core: Avoid debugfs: Directory ... already present! error
Date:   Mon,  1 Mar 2021 17:09:22 +0100
Message-Id: <20210301161157.381011644@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit dbe954d8f1635f949a1d9a5d6e6fb749ae022b47 ]

Sometimes regulator_get() gets called twice for the same supply on the
same device. This may happen e.g. when a framework / library is used
which uses the regulator; and the driver itself also needs to enable
the regulator in some cases where the framework will not enable it.

Commit ff268b56ce8c ("regulator: core: Don't spew backtraces on
duplicate sysfs") already takes care of the backtrace which would
trigger when creating a duplicate consumer symlink under
/sys/class/regulator/regulator.%d in this scenario.

Commit c33d442328f5 ("debugfs: make error message a bit more verbose")
causes a new error to get logged in this scenario:

[   26.938425] debugfs: Directory 'wm5102-codec-MICVDD' with parent 'spi-WM510204:00-MICVDD' already present!

There is no _nowarn variant of debugfs_create_dir(), but we can detect
and avoid this problem by checking the return value of the earlier
sysfs_create_link_nowarn() call.

Add a check for the earlier sysfs_create_link_nowarn() failing with
-EEXIST and skip the debugfs_create_dir() call in that case, avoiding
this error getting logged.

Fixes: c33d442328f5 ("debugfs: make error message a bit more verbose")
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210122183250.370571-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 35098dbd32a3c..7b3de8b0b1caf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1617,7 +1617,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 					  const char *supply_name)
 {
 	struct regulator *regulator;
-	int err;
+	int err = 0;
 
 	if (dev) {
 		char buf[REG_STR_SIZE];
@@ -1663,8 +1663,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		}
 	}
 
-	regulator->debugfs = debugfs_create_dir(supply_name,
-						rdev->debugfs);
+	if (err != -EEXIST)
+		regulator->debugfs = debugfs_create_dir(supply_name, rdev->debugfs);
 	if (!regulator->debugfs) {
 		rdev_dbg(rdev, "Failed to create debugfs directory\n");
 	} else {
-- 
2.27.0



