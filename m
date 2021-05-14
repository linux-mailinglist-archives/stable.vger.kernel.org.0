Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953D93808E9
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 13:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhENLw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 07:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232300AbhENLw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 07:52:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E6CB6145D;
        Fri, 14 May 2021 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620993075;
        bh=kz1BDm7z8fIltgHA6x06ZGgr+rpZvBQqHlyrbI53hK0=;
        h=Subject:To:From:Date:From;
        b=svpZaqcEetQVa4TRLlwE1XUn+ZkhU4B5F7L/oEwbrFcIvGibhqxD41+H7rkOjSZqD
         joAi1Lx61YXBhKdHuwyt9DtGDyf48PhH5CydIC8zIFd3PFf1YPhF45m+d6VEoQwl4z
         +aHe3inowG6NDZ1GZsVx6NBImgYmxWsE8YFXyAFs=
Subject: patch "misc: eeprom: at24: check suspend status before disable regulator" added to char-misc-linus
To:     hsinyi@chromium.org, bgolaszewski@baylibre.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 13:51:13 +0200
Message-ID: <162099307320761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: eeprom: at24: check suspend status before disable regulator

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2962484dfef8dbb7f9059822bc26ce8a04d0e47c Mon Sep 17 00:00:00 2001
From: Hsin-Yi Wang <hsinyi@chromium.org>
Date: Tue, 20 Apr 2021 21:30:50 +0800
Subject: misc: eeprom: at24: check suspend status before disable regulator

cd5676db0574 ("misc: eeprom: at24: support pm_runtime control") disables
regulator in runtime suspend. If runtime suspend is called before
regulator disable, it will results in regulator unbalanced disabling.

Fixes: cd5676db0574 ("misc: eeprom: at24: support pm_runtime control")
Cc: stable <stable@vger.kernel.org>
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210420133050.377209-1-hsinyi@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at24.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 926408b41270..7a6f01ace78a 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -763,7 +763,8 @@ static int at24_probe(struct i2c_client *client)
 	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
 	if (IS_ERR(at24->nvmem)) {
 		pm_runtime_disable(dev);
-		regulator_disable(at24->vcc_reg);
+		if (!pm_runtime_status_suspended(dev))
+			regulator_disable(at24->vcc_reg);
 		return PTR_ERR(at24->nvmem);
 	}
 
@@ -774,7 +775,8 @@ static int at24_probe(struct i2c_client *client)
 	err = at24_read(at24, 0, &test_byte, 1);
 	if (err) {
 		pm_runtime_disable(dev);
-		regulator_disable(at24->vcc_reg);
+		if (!pm_runtime_status_suspended(dev))
+			regulator_disable(at24->vcc_reg);
 		return -ENODEV;
 	}
 
-- 
2.31.1


