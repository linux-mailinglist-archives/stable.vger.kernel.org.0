Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6CD6E3245
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjDOQI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 12:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjDOQI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 12:08:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02E030FC
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 09:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681574862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=divcLMMri/nzDRpy8HMRAigJzG5y+LRUjzx7gftew9I=;
        b=OEXDNklpTj4NbFY5mJv0IKD7n03PtXn0sksiOfb0rRpWnWZWfEKcWJUANLA/nqDkF2CJSG
        tbyt9my/UH+HNVCDPz84uLJS23SsrgI5XapD4YdzKoRKgi1qjppKT+Zbyua17oxwDn59Jk
        kYD/zca4lwusXt2w/b19Ivk8Z+l2wPQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-Y_9NcvFBOjS6dd1mQCg1mQ-1; Sat, 15 Apr 2023 12:07:38 -0400
X-MC-Unique: Y_9NcvFBOjS6dd1mQCg1mQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B2B2811E7C;
        Sat, 15 Apr 2023 16:07:38 +0000 (UTC)
Received: from shalem.redhat.com (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BA5F2166B26;
        Sat, 15 Apr 2023 16:07:37 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        laji Xiao <3252204392abc@gmail.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/6] power: supply: axp288_fuel_gauge: Fix external_power_changed race
Date:   Sat, 15 Apr 2023 18:07:30 +0200
Message-Id: <20230415160734.70475-3-hdegoede@redhat.com>
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

fuel_gauge_external_power_changed() dereferences info->bat,
which gets sets in axp288_fuel_gauge_probe() like this:

  info->bat = devm_power_supply_register(dev, &fuel_gauge_desc, &psy_cfg);

As soon as devm_power_supply_register() has called device_add()
the external_power_changed callback can get called. So there is a window
where fuel_gauge_external_power_changed() may get called while
info->bat has not been set yet leading to a NULL pointer dereference.

Fixing this is easy. The external_power_changed callback gets passed
the power_supply which will eventually get stored in info->bat,
so fuel_gauge_external_power_changed() can simply directly use
the passed in psy argument which is always valid.

Fixes: 30abb3d07929 ("power: supply: axp288_fuel_gauge: Take lock before updating the valid flag")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/power/supply/axp288_fuel_gauge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 05f413178462..3be6f3b10ea4 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -507,7 +507,7 @@ static void fuel_gauge_external_power_changed(struct power_supply *psy)
 	mutex_lock(&info->lock);
 	info->valid = 0; /* Force updating of the cached registers */
 	mutex_unlock(&info->lock);
-	power_supply_changed(info->bat);
+	power_supply_changed(psy);
 }
 
 static struct power_supply_desc fuel_gauge_desc = {
-- 
2.39.1

