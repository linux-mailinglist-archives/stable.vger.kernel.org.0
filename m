Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885EF178D54
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgCDJWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:22:33 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56776 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgCDJWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 04:22:33 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0249MVVd021446;
        Wed, 4 Mar 2020 03:22:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583313751;
        bh=2d9mOhOZdqG8REHoaeHfSFUIKR7jOmqd2Qz00FQ0jJE=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=aQSKRBoJaka7PthutzerBCcYwSqMPCyIAkRlyUA5H5ZTkNVvr5JAjg04o0qQw8R+b
         k4yBrVBRu3DbxFxE9EYR60+C52NubKXBqewWc1V8X4YQ3a7on3xD8vuBvM5PZdAvCM
         qplNtgS9gG57XCSEgxIA1mZBNR5kbCV8lTazCXew=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0249MVlA123075;
        Wed, 4 Mar 2020 03:22:31 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Mar
 2020 03:22:31 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Mar 2020 03:22:31 -0600
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0249MRMo067256;
        Wed, 4 Mar 2020 03:22:28 -0600
Subject: Re: [Patch] media: ti-vpe: cal: fix a kernel oops when unloading
 module
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200303172629.21339-1-bparrot@ti.com>
 <4010c13f-6a32-f3c3-5b6d-62a4e3782c64@ti.com>
 <f7f6dd87-147f-b9e9-aaa7-c063a8f3c11e@ti.com>
Message-ID: <a2e6510f-ffd9-060e-ab03-cdc261ecc778@ti.com>
Date:   Wed, 4 Mar 2020 11:22:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f7f6dd87-147f-b9e9-aaa7-c063a8f3c11e@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/03/2020 10:41, Tomi Valkeinen wrote:

>> Thanks, this fixes the crash for me.
>>
>> It does look a bit odd that something is allocated with kzalloc, and then it's freed somewhere 
>> inside v4l2_async_notifier_cleanup, though. But if that's how it supposed to be used, looks fine 
>> to me.
> 
> Well, sent that a few seconds too early... With this patch, I see kmemleaks.

This is caused by allocating asd for all ports, even if the port is not used, causing the allocated asd to be forgotten. Also, any error there would cause leak too.

I think something like this fixes both the unused port case and error paths:

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index a928c9d66d5d..4b89dd53d2b4 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -372,8 +372,6 @@ struct cal_ctx {
 	struct v4l2_subdev	*sensor;
 	struct v4l2_fwnode_endpoint	endpoint;
 
-	struct v4l2_async_subdev asd;
-
 	struct v4l2_fh		fh;
 	struct cal_dev		*dev;
 	struct cc_data		*cc;
@@ -2020,7 +2018,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 
 	parent = pdev->dev.of_node;
 
-	asd = &ctx->asd;
 	endpoint = &ctx->endpoint;
 
 	ep_node = NULL;
@@ -2067,8 +2064,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		ctx_dbg(3, ctx, "can't get remote parent\n");
 		goto cleanup_exit;
 	}
-	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
 
@@ -2098,9 +2093,17 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 
 	v4l2_async_notifier_init(&ctx->notifier);
 
+	asd = kzalloc(sizeof(*asd), GFP_KERNEL);
+	if (!asd)
+		goto cleanup_exit;
+
+	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
+	asd->match.fwnode = of_fwnode_handle(sensor_node);
+
 	ret = v4l2_async_notifier_add_subdev(&ctx->notifier, asd);
 	if (ret) {
 		ctx_err(ctx, "Error adding asd\n");
+		kfree(asd);
 		goto cleanup_exit;
 	}
 
 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
