Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACF32B607B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgKQNJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:09:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgKQNJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:09:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77711246CD;
        Tue, 17 Nov 2020 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618585;
        bh=oAei7ARmQ4PjubjY81OMJ31y/uh0iQAxfq2TpidQzbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oT5iSBeeiumLXp56YUJkCm7AsjtVDN8sBDyf4DhuUcbUGTiDJ5+mN91M/BwBZ6HHe
         CHRJUA1onD7BENY4VyTFVyoczle4kV0QtQzIbOC0OHYM5dyx8qgiwco1Z2zLov3oCh
         5JB9TuIHtn/F9V35dEWYjMykyOY6Rx5bbVWZ5P8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Elena Petrova <lenaptr@google.com>,
        Will Deacon <will@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/78] pinctrl: devicetree: Avoid taking direct reference to device name string
Date:   Tue, 17 Nov 2020 14:04:44 +0100
Message-Id: <20201117122109.991915504@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit be4c60b563edee3712d392aaeb0943a768df7023 upstream.

When populating the pinctrl mapping table entries for a device, the
'dev_name' field for each entry is initialised to point directly at the
string returned by 'dev_name()' for the device and subsequently used by
'create_pinctrl()' when looking up the mappings for the device being
probed.

This is unreliable in the presence of calls to 'dev_set_name()', which may
reallocate the device name string leaving the pinctrl mappings with a
dangling reference. This then leads to a use-after-free every time the
name is dereferenced by a device probe:

  | BUG: KASAN: invalid-access in strcmp+0x20/0x64
  | Read of size 1 at addr 13ffffc153494b00 by task modprobe/590
  | Pointer tag: [13], memory tag: [fe]
  |
  | Call trace:
  |  __kasan_report+0x16c/0x1dc
  |  kasan_report+0x10/0x18
  |  check_memory_region
  |  __hwasan_load1_noabort+0x4c/0x54
  |  strcmp+0x20/0x64
  |  create_pinctrl+0x18c/0x7f4
  |  pinctrl_get+0x90/0x114
  |  devm_pinctrl_get+0x44/0x98
  |  pinctrl_bind_pins+0x5c/0x450
  |  really_probe+0x1c8/0x9a4
  |  driver_probe_device+0x120/0x1d8

Follow the example of sysfs, and duplicate the device name string before
stashing it away in the pinctrl mapping entries.

Cc: Linus Walleij <linus.walleij@linaro.org>
Reported-by: Elena Petrova <lenaptr@google.com>
Tested-by: Elena Petrova <lenaptr@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20191002124206.22928-1-will@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 54dad89fc9bfe..d32aedfc6dd03 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -40,6 +40,13 @@ struct pinctrl_dt_map {
 static void dt_free_map(struct pinctrl_dev *pctldev,
 		     struct pinctrl_map *map, unsigned num_maps)
 {
+	int i;
+
+	for (i = 0; i < num_maps; ++i) {
+		kfree_const(map[i].dev_name);
+		map[i].dev_name = NULL;
+	}
+
 	if (pctldev) {
 		const struct pinctrl_ops *ops = pctldev->desc->pctlops;
 		ops->dt_free_map(pctldev, map, num_maps);
@@ -73,7 +80,13 @@ static int dt_remember_or_free_map(struct pinctrl *p, const char *statename,
 
 	/* Initialize common mapping table entry fields */
 	for (i = 0; i < num_maps; i++) {
-		map[i].dev_name = dev_name(p->dev);
+		const char *devname;
+
+		devname = kstrdup_const(dev_name(p->dev), GFP_KERNEL);
+		if (!devname)
+			goto err_free_map;
+
+		map[i].dev_name = devname;
 		map[i].name = statename;
 		if (pctldev)
 			map[i].ctrl_dev_name = dev_name(pctldev->dev);
@@ -81,11 +94,8 @@ static int dt_remember_or_free_map(struct pinctrl *p, const char *statename,
 
 	/* Remember the converted mapping table entries */
 	dt_map = kzalloc(sizeof(*dt_map), GFP_KERNEL);
-	if (!dt_map) {
-		dev_err(p->dev, "failed to alloc struct pinctrl_dt_map\n");
-		dt_free_map(pctldev, map, num_maps);
-		return -ENOMEM;
-	}
+	if (!dt_map)
+		goto err_free_map;
 
 	dt_map->pctldev = pctldev;
 	dt_map->map = map;
@@ -93,6 +103,10 @@ static int dt_remember_or_free_map(struct pinctrl *p, const char *statename,
 	list_add_tail(&dt_map->node, &p->dt_maps);
 
 	return pinctrl_register_map(map, num_maps, false);
+
+err_free_map:
+	dt_free_map(pctldev, map, num_maps);
+	return -ENOMEM;
 }
 
 struct pinctrl_dev *of_pinctrl_get(struct device_node *np)
-- 
2.27.0



