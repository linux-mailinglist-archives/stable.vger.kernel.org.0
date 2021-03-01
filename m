Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676DD3288A3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhCARnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhCARfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625E064F30;
        Mon,  1 Mar 2021 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617678;
        bh=1KtywrlZ4226wpTUyG80vdzAD7VTx0OtAhfW9lHoLnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rP/OsSssfaRydQ4RiUVCX+wCvCNXU9wvZTYENny7Jejb62YDZ+I4ifRXkzjk+gfCJ
         7uCGZv9o1X3Py6/WTyT6ss76gOEeXIGRkTpS17lrGMVREZkmjSm8VSyyX4nAwWOG/c
         YI2TBmJrGZ9sIQhs/4IzrBMw/4p1b0GC3sfEGJZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/340] regulator: core: Avoid debugfs: Directory ... already present! error
Date:   Mon,  1 Mar 2021 17:11:41 +0100
Message-Id: <20210301161056.041112678@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 5b9d570df85cc..a31b6ae92a84e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1576,7 +1576,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 					  const char *supply_name)
 {
 	struct regulator *regulator;
-	int err;
+	int err = 0;
 
 	if (dev) {
 		char buf[REG_STR_SIZE];
@@ -1622,8 +1622,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
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



