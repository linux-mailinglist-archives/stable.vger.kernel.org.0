Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A8B6E3248
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDOQIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjDOQI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 12:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE835AB
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681574864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HO3NR1jjOy2hneBq8NSWJ2zq3Oxl9rsO1Sm5Zmq2dqA=;
        b=G0K8gquJvVxtINFS9cOVCx1jZMaPY17q0FadSYD+KAP8B6FzL9I+pyM4yhqP2WqUWLlFLC
        +fJpRrlhGgLtnC4MRA+exvy/Du73cp0DFr7YWUmF6KGc9dMaLiSzXBL6UkkQeb5nqhgrql
        ORmfqRWgHYtWWSXIMBQNWpMDkxSSK1Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-WIy5dPSTMO6t-14EmjMuOA-1; Sat, 15 Apr 2023 12:07:41 -0400
X-MC-Unique: WIy5dPSTMO6t-14EmjMuOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2A533C0F662;
        Sat, 15 Apr 2023 16:07:40 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE912166B26;
        Sat, 15 Apr 2023 16:07:38 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        laji Xiao <3252204392abc@gmail.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>
Subject: [PATCH 3/6] power: supply: bq25890: Fix external_power_changed race
Date:   Sat, 15 Apr 2023 18:07:31 +0200
Message-Id: <20230415160734.70475-4-hdegoede@redhat.com>
In-Reply-To: <20230415160734.70475-1-hdegoede@redhat.com>
References: <20230415160734.70475-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bq25890_charger_external_power_changed() dereferences bq->charger,
which gets sets in bq25890_power_supply_init() like this:

  bq->charger = devm_power_supply_register(bq->dev, &bq->desc, &psy_cfg);

As soon as devm_power_supply_register() has called device_add()
the external_power_changed callback can get called. So there is a window
where bq25890_charger_external_power_changed() may get called while
bq->charger has not been set yet leading to a NULL pointer dereference.

This race hits during boot sometimes on a Lenovo Yoga Book 1 yb1-x90f
when the cht_wcove_pwrsrc (extcon) power_supply is done with detecting
the connected charger-type which happens to exactly hit the small window:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  <snip>
  RIP: 0010:__power_supply_is_supplied_by+0xb/0xb0
  <snip>
  Call Trace:
   <TASK>
   __power_supply_get_supplier_property+0x19/0x50
   class_for_each_device+0xb1/0xe0
   power_supply_get_property_from_supplier+0x2e/0x50
   bq25890_charger_external_power_changed+0x38/0x1b0 [bq25890_charger]
   __power_supply_changed_work+0x30/0x40
   class_for_each_device+0xb1/0xe0
   power_supply_changed_work+0x5f/0xe0
  <snip>

Fixing this is easy. The external_power_changed callback gets passed
the power_supply which will eventually get stored in bq->charger,
so bq25890_charger_external_power_changed() can simply directly use
the passed in psy argument which is always valid.

Fixes: eab25b4f93aa ("power: supply: bq25890: On the bq25892 set the IINLIM based on external charger detection")
Cc: stable@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/power/supply/bq25890_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq25890_charger.c b/drivers/power/supply/bq25890_charger.c
index 794512285629..0157713a7e7c 100644
--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -750,7 +750,7 @@ static void bq25890_charger_external_power_changed(struct power_supply *psy)
 	if (bq->chip_version != BQ25892)
 		return;
 
-	ret = power_supply_get_property_from_supplier(bq->charger,
+	ret = power_supply_get_property_from_supplier(psy,
 						      POWER_SUPPLY_PROP_USB_TYPE,
 						      &val);
 	if (ret)
-- 
2.39.1

