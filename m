Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C897475E7F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbhLORWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245282AbhLORWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058E6C06173E;
        Wed, 15 Dec 2021 09:22:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98652619E9;
        Wed, 15 Dec 2021 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FE6C36AE3;
        Wed, 15 Dec 2021 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588951;
        bh=7W/Bm/LIdgj6WIOClBi/WAGkDbYFDO6AZWwZk+JhK74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/RhVjJTH833VYfdW5CSFbNOUpGVzRz2U7F6wCYr7dJ0ryM02Daf7VvSSVsfcI8z+
         /iW7K9meDkII52hkVM4MKS6gOoMIvSu+rkWh3fqVpvz8jAL8hUMJ1S22LulhnTPf47
         2N9FVD5GKroACFh8XNtJwdnzM6gJ2qWeeyYA83AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Wilken Gottwalt <wilken.gottwalt@posteo.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/42] hwmon: (corsair-psu) fix plain integer used as NULL pointer
Date:   Wed, 15 Dec 2021 18:20:43 +0100
Message-Id: <20211215172026.724362197@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@posteo.net>

[ Upstream commit 8383226583251858814d5521b542e7bf7dbadc4b ]

sparse warnings: (new ones prefixed by >>)
>> drivers/hwmon/corsair-psu.c:536:82: sparse: sparse: Using plain
   integer as NULL pointer

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/YY9hAL8MZEQYLYPf@monster.localdomain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 731d5117f9f10..14389fd7afb89 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -729,7 +729,7 @@ static int corsairpsu_probe(struct hid_device *hdev, const struct hid_device_id
 	corsairpsu_check_cmd_support(priv);
 
 	priv->hwmon_dev = hwmon_device_register_with_info(&hdev->dev, "corsairpsu", priv,
-							  &corsairpsu_chip_info, 0);
+							  &corsairpsu_chip_info, NULL);
 
 	if (IS_ERR(priv->hwmon_dev)) {
 		ret = PTR_ERR(priv->hwmon_dev);
-- 
2.33.0



